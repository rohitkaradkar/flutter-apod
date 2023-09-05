#!/bin/bash
hookFile='.git/hooks/pre-push'
gitDir='.git'

# function that checks if previous command was successful else exits
function appendCheckSuccess() {
  # shellcheck disable=SC2028
  echo "if [ \$? -ne 0 ]; then\\n exit 1\\nfi" >> $hookFile
}

if [ ! -d $gitDir ]
then
  echo 'git not initialised yet'
  exit 1
elif [ ! -f $hookFile ]
then
  echo 'flutter test' >> $hookFile
  appendCheckSuccess

  echo 'dart format -o none --set-exit-if-changed .' >> $hookFile
  appendCheckSuccess

  chmod +x $hookFile
  echo 'pre-push hook added'
else
  echo 'pre-push hook already present'
  echo 'check .git/hooks/pre-push for more details'
fi