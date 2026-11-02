#!/bin/sh
# The visitor's shell, installed as /home/httpd/ernest-httpd/shell.sh
# (docs/design.md §13): podman run with the arguments given, in a container
# that ends with its terminal. podman run detaches from a container whose
# terminal hangs up and leaves it running, so the container's id is kept in
# a file and the container is removed at the terminal's hangup, at a
# termination, and at podman's own end.
set -u
# Under /run/user, which podman's namespaces share; /tmp they need not.
dir=$(mktemp -d -p "/run/user/$(id -u)") || exit 1
end() {
    podman rm -f -t 0 --cidfile "$dir/cid" > /dev/null 2>&1
    rm -rf "$dir"
}
trap 'end; exit 129' HUP
trap 'end; exit 143' TERM
exec 3<&0
podman run --cidfile "$dir/cid" "$@" <&3 &
wait $!
status=$?
end
exit $status
