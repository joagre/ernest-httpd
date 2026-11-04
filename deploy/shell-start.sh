#!/bin/sh
# The shell's start, installed in the image as /usr/local/bin/shell-start
# (docs/design.md §13): the visitor's two nodes. The image's directories a
# and foo are copied into the home, since the container is read-only and a
# node writes ernest.pid in its directory; foo is started as a bare node
# and read until it listens; and then ern shell on a runs in the script's
# place, so that the container ends with the shell, and foo with it.
set -u
share=/usr/local/share/ernest-shell
# -p keeps the modes, since a node refuses a directory or a key anyone but
# its owner may open.
cp -Rp "$share/a" "$share/foo" "$HOME/" || exit 1
fifo="$HOME/.foo-listening"
mkfifo -m 0600 "$fifo" || exit 1
# foo's lines are read to its end, and dropped, so that foo never writes to
# a closed pipe; the fifo is told once, at the line that says foo listens,
# or at foo's end where it ended first.
ern run --config-dir "$HOME/foo" 2>&1 | {
    told=no
    while IFS= read -r line; do
        case $told$line in
            no*"listening on"*)
                echo listening > "$fifo"
                told=yes
                ;;
        esac
    done
    [ "$told" = yes ] || echo ended > "$fifo"
} &
read -r said < "$fifo"
rm -f "$fifo"
if [ "$said" != listening ]; then
    echo "foo did not start" >&2
    exit 1
fi
exec ern shell --config-dir "$HOME/a"
