#!/bin/sh
# certbot's deploy hook for ernest-httpd, installed as
# /etc/letsencrypt/renewal-hooks/deploy/ernest-httpd.sh (docs/design.md
# §13). certbot runs it once the certificate is issued or renewed: it
# copies the certificate's chain and its key into the node's directory,
# /home/httpd/ernest-httpd/node, owned by the server's user, httpd, and the
# key readable by that user alone, since certbot's own are root's, and
# restarts the server, which reads them at its start. It does nothing else.
set -eu
install -o httpd -g httpd -m 0644 /etc/letsencrypt/live/ernest-lang.org/fullchain.pem /home/httpd/ernest-httpd/node/fullchain.pem
install -o httpd -g httpd -m 0600 /etc/letsencrypt/live/ernest-lang.org/privkey.pem /home/httpd/ernest-httpd/node/privkey.pem
systemctl restart ernest-httpd.service
