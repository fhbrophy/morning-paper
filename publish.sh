#!/bin/bash
# usage: publish.sh YYYY-MM-DD /path/to/paper.html
set -e
D="$1"; F="$2"; cd /workspace/morning-paper-site
mkdir -p issues && cp "$F" "issues/$D.html"
LABEL=$(date -d "$D" '+%A, %b %-d, %Y')
grep -q "issues/$D.html" index.html || sed -i "s#<!-- ISSUES -->#<!-- ISSUES -->\n<li><a href=\"issues/$D.html\">$LABEL</a></li>#" index.html
git add -A && git -c user.name=fhbrophy -c user.email=fhbrophy@users.noreply.github.com commit -qm "Paper $D" && git push -q
URL="https://fhbrophy.github.io/morning-paper/issues/$D.html"
for i in $(seq 1 30); do c=$(curl -s -o /dev/null -w "%{http_code}" "$URL?v=$RANDOM"); [ "$c" = 200 ] && { echo "LIVE $URL"; exit 0; }; sleep 8; done
echo "NOT LIVE YET $URL"; exit 1
