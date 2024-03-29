#!/usr/bin/env bash
#
# Measurement script for the dn42 peer finder, see http://dn42.us/peers
# Dependencies: curl, sed, ping
#
# This script is designed to be run in cron every 5 minutes, like this:
#
#   UUID=<Your UUID goes here>
#   */5 * * * * /home/foo/cron.sh
#

# Put your UUID here, and keep it secret!
# shellcheck disable=SC2269 # Intended assignment of UUID
UUID=${UUID}
PEERFINDER=${PEERFINDER:-"https://dn42.us/peers"}
NB_PINGS=${NB_PINGS:-5}
LOGFILE=${LOGFILE:-/dev/stdout}   # Set to /dev/null to only receive errors.
                                  # Set to a file writable by the cron runner to record pings.
                                  #  (Errors will be sent in cron mail)
WARNLOCK=${WARNLOCK:-warn.lock}   # Set this variable if you want a file written when the script updates.
LOCKFILE=${LOCKFILE:-exec.lock}   # Set this variable if you want the script to not run multiple instances at once.
LOCKFD=${LOCKFD:-42}

# This avoids synchronisation (everybody fetching jobs and running
# measurements simultaneously)
# RANDOM_DELAY=30
# SLEEP=$((RANDOM % RANDOM_DELAY))
# sleep "$SLEEP"

function die() {
  echo "## PEERFINDER ERROR $(date) ## " \
    "$*"
  exit 1
}

eval "exec $LOCKFD>$LOCKFILE"

flock -n "$LOCKFD" || die "Unable to acquire lock."

VERSION=1.2.1
# shellcheck disable=SC2046 # Intended splitting of VERSION
# shellcheck disable=SC2183 #
ver() { printf "%03d%03d%03d%03d" $(echo "$1" | tr '.' ' '); }

[ -e "$LOGFILE" ] || touch "$LOGFILE"
exec >> "$LOGFILE"

echo "STARTING PEERFINDER (v. $VERSION)"

# check for IPv4 binary
PING4=$(which ping)

# check for IPv6 binary. if ping6 is missing assume 'ping -6'
PING6=$(which ping6)
[ -z "$PING6" ] && [ -n "$PING4" ] && PING6="$PING4 -6"

CURL=$(which curl)
if [ -z "$CURL" ]; then
  die "Unable to find a suitable curl binary."
fi
CURL="$CURL -A PeerFinder -sf"

while true ; do

  JOB=$(mktemp)

  $CURL -H 'accept: text/environment' "$PEERFINDER/pending/$UUID" | tee "$JOB"

  REQ_ID=$(grep REQ_ID "$JOB"|cut -d'=' -f2|tr -d '[$`;><{}%|&!()]"\\/')
  REQ_IP=$(grep REQ_IP "$JOB"|cut -d'=' -f2|tr -d '[$`;><{}%|&!()]"\\/')
  REQ_FAMILY=$(grep REQ_FAMILY "$JOB"|cut -d'=' -f2|tr -d '[$`;><{}%|&!()]"\\/')
  CUR_VERSION=$(grep SCRIPT_VERSION "$JOB"|cut -d'=' -f2|tr -d '[$`;><{}%|&!()]"\\/')

  rm "$JOB"

  if [ "$(ver "$VERSION")" -lt "$(ver "$CUR_VERSION")" ]; then
    echo "## PEERFINDER WARN $(date) ## " \
         "Current script version is $CUR_VERSION. You are running $VERSION " \
         "Get it here: https://dn42.us/peers/script"

    [ -z "$WARNLOCK" ] && touch "$WARNLOCK"
  else
    [ -z "$WARNLOCK" ] || [ -f "$WARNLOCK" ] && rm "$WARNLOCK"
  fi

  # Avoid empty fields
  [ -z "$REQ_ID" ] && [ -z "$REQ_IP" ] && exit

  [ "$REQ_FAMILY" -eq "1" ] && [ -n "$PING4" ] && PING="ping -n -q"
  [ "$REQ_FAMILY" -eq "2" ] && [ -n "$PING6" ] && PING="$PING6 -n -q"

  if [ -z "$PING" ]; then
    die "Unable to find a suitable ping binary."
  fi

  echo "PINGING TO: $REQ_IP for $REQ_ID..."

  # Parsing ping output, for Linux
  if ! output=$($PING -c "$NB_PINGS" "$REQ_IP" 2>&1 | grep -A1 "packets transmitted"); then
    sent=0
    received=0
    args="res_latency=NULL"
    echo "Target $REQ_ID ($REQ_IP) is unreachable"
  else
     pattern='([0-9]*) packets transmitted, ([0-9]*)( packets)? received'
     if [[ $output =~ $pattern ]]; then
         sent=${BASH_REMATCH[1]}
         received=${BASH_REMATCH[2]}
         if [ "$received" -eq 0 ]
         then
             args="res_latency=NULL"
             echo "Target $REQ_ID ($REQ_IP) is unreachable"
         else
             pattern='(rtt|round-trip) min\/avg\/max.*= ([.0-9]+)\/([.0-9]+)\/([.0-9]+)\/?([.0-9]+)? ms'
             if [[ $output =~ $pattern ]]; then
                 minrtt=${BASH_REMATCH[2]}
                 avgrtt=${BASH_REMATCH[3]}
                 maxrtt=${BASH_REMATCH[4]}
                 jitter=${BASH_REMATCH[5]}
                 [ -z "$avgrtt" ] && exit
                 echo "RTT to target $REQ_ID ($REQ_IP) is $avgrtt"
                 args="res_latency=${avgrtt}&res_jitter=${jitter}&res_minrtt=${minrtt}&res_maxrtt=${maxrtt}&res_sent=${sent}&res_recv=${received}"
             else
                 args="res_latency=NULL"
             fi
         fi
      else
          args="res_latency=NULL"
      fi
  fi

  # Report results back to peerfinder
  echo "RESULT $args"
  $CURL -X POST "$PEERFINDER/req/$REQ_ID" -d "peer_id=$UUID&peer_version=$VERSION&$args" -H 'accept: text/environment'

done