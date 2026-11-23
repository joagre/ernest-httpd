#!/bin/sh
# The visitor's shell, installed as /home/httpd/ernest-httpd/shell.sh
# (docs/design.md §13): podman run with the arguments given, in a container
# that ends with its terminal. podman run detaches from a container whose
# terminal hangs up and leaves it running, so the container's id is kept in
# a file, and the container is removed by it at the terminal's hangup, at a
# termination, and at podman's own end. At the hangup and the termination
# podman is killed and waited for first, so that the id stands whole
# wherever podman wrote one. The removal runs in a session of its own, so
# that a kill of the wrapper's process group, the server's once
# shell.hangup has passed, leaves it running; the wrapper waits for it.
set -u
# Under /run/user, which podman's namespaces share; /tmp they need not.
dir=$(mktemp -d -p "/run/user/$(id -u)") || exit 1

# The end, with the wrapper's status, a signal from here on ignored.
# podman, the one job in the background, is killed and waited for where
# the shell's jobs say it still runs, the shell's note of the kill dropped:
# a signal that comes as the wait reaps podman finds its job done, so that
# no process is killed by an id a wait has reaped. The removal holds
# neither the terminal nor its copy.
end() {
    trap '' HUP TERM
    jobs > "$dir/jobs"
    read -r number current state < "$dir/jobs" || state=
    if [ "$state" = Running ]; then
        kill -KILL "$!"
        wait "$!" 2> /dev/null
    fi
    setsid -w sh -c 'podman rm -f -t 0 --cidfile "$1/cid"; rm -rf "$1"' sh "$dir" \
        < /dev/null > /dev/null 2>&1 3<&-
    exit "$1"
}

trap 'end 129' HUP
trap 'end 143' TERM
# The terminal kept as fd 3 and given to podman as its standard input,
# which a command in the background is otherwise not given.
exec 3<&0
podman run --cidfile "$dir/cid" "$@" <&3 &
wait "$!"
end "$?"
