#!/bin/sh
git_retries=20
try=0
export GIT_SSH_COMMAND='ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null"'
until timeout 10 git clone --recurse-submodules ${CONTENT_GIT_REPO} /app ; do
  echo "Retry git pull after error ($try / $git_retries)"
  try=$((try+1))
  if [ $try -eq $git_retries  ]; then
    exit 1
  fi
  sleep 1
done
cd /app
if [ -e index.html ] ; then
    mv index.html index-embedded.html
fi
cat <<EOF >index.html
<html>
<head>
    <title>Html-Kube-Tester fron ${KUBE_NODE_NAME}</title>
</head>
<body>
    <p align="center">
        From node ${KUBE_NODE_NAME}
    </p>
    <iframe
        id="embeddedcontent"
        title="embeddedcontent"
        width="100%"
        height="90%"
        src="./index-embedded.html" />
</body>
</html>
EOF

