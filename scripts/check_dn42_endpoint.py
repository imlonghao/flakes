#!/usr/bin/env python3

import ipaddress
import re
import socket
import sys
from pathlib import Path

ENDPOINT_RE = re.compile(r'endpoint\s*=\s*"([^"]+)"\s*;')
HOST_RE = re.compile(r'^\[(?P<ipv6>[^\]]+)\](?::(?P<port>\d+))?$|^(?P<host>[^:]+)(?::(?P<port2>\d+))?$')


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


def resolve_host(host: str) -> bool:
    try:
        socket.getaddrinfo(host, None)
    except socket.gaierror:
        return False
    return True


def iter_endpoints(path: Path):
    for lineno, line in enumerate(path.read_text().splitlines(), start=1):
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
