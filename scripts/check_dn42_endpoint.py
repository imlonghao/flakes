#!/usr/bin/env python3

import ipaddress
import re
import socket
import subprocess
import sys
from pathlib import Path

ENDPOINT_RE = re.compile(r'endpoint\s*=\s*"([^"]+)"\s*;')
HOST_RE = re.compile(r'^\[(?P<ipv6>[^\]]+)\](?::(?P<port>\d+))?$|^(?P<host>[^:]+)(?::(?P<port2>\d+))?$')
DNS_QUERY = '''
import socket
import sys

try:
    addresses = socket.getaddrinfo(sys.argv[1], None, int(sys.argv[2]))
except socket.gaierror:
    sys.exit(1)
sys.exit(0 if addresses else 1)
'''


def parse_host(endpoint: str) -> str | None:
    match = HOST_RE.match(endpoint)
    if not match:
        return None
    return match.group('ipv6') or match.group('host')


def is_ip_address(value: str) -> bool:
    try:
        ipaddress.ip_address(value)
    except ValueError:
        return False
    return True


def resolve_host(host: str, timeout: float = 5.0) -> bool:
    """Return True if host resolves to at least one address.

    Queries IPv6 first since DN42 is IPv6-based, then IPv4.
    Each family runs in a separate process that is killed and reaped on
    timeout, so a stuck system resolver cannot delay return or script exit.
    """
    for family in (socket.AF_INET6, socket.AF_INET):
        try:
            result = subprocess.run(
                [sys.executable, '-c', DNS_QUERY, host, str(int(family))],
                stdin=subprocess.DEVNULL,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                timeout=timeout,
            )
            if result.returncode == 0:
                return True
        except subprocess.TimeoutExpired:
            continue
    return False


def iter_endpoints(path: Path):
    for lineno, line in enumerate(path.read_text().splitlines(), start=1):
        stripped = line.lstrip()
        if stripped.startswith('#'):
            continue

        match = ENDPOINT_RE.search(line)
        if match:
            yield lineno, match.group(1)


def main() -> int:
    root = Path(__file__).resolve().parent.parent
    files = sorted(root.glob('hosts/*/*/dn42.nix'))

    unresolved = []
    skipped = 0
    checked = 0

    for path in files:
        for lineno, endpoint in iter_endpoints(path):
            host = parse_host(endpoint)
            if host is None:
                unresolved.append((path, lineno, endpoint, 'invalid endpoint format'))
                continue

            if is_ip_address(host):
                skipped += 1
                continue

            checked += 1
            if not resolve_host(host):
                unresolved.append((path, lineno, endpoint, f'cannot resolve host {host}'))

    if unresolved:
        for path, lineno, endpoint, reason in unresolved:
            print(f'{path.relative_to(root)}:{lineno}: {endpoint} - {reason}')
        print(
            f'\nFound {len(unresolved)} unresolved endpoint(s); '
            f'checked {checked} hostname(s), skipped {skipped} IP endpoint(s).'
        )
        return 1

    print(f'All DN42 endpoints resolved; checked {checked} hostname(s), skipped {skipped} IP endpoint(s).')
    return 0


if __name__ == '__main__':
    sys.exit(main())
