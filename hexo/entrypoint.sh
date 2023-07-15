#!/bin/bash

while getopts ":cd" arg; do
  case $arg in
  c)    COPY_BACK=True;;
  d)    DEPLOY_FLAG=True;;
  *)    exit 1
  esac
done

WORKING_DIR=/working

if [ -d /${WORKING_DIR}/source/_posts ]; then
  source /root/.nvm/nvm.sh

  cp -r /${WORKING_DIR}/source/. /root/blog/source/.
  cd /root/blog

  if [ "x${DEPLOY_FLAG}" == "xTrue" ]; then
    npx gulp deploy
  else
    npx gulp
  fi

  if [ "x${COPY_BACK}" == "xTrue" ]; then
    cp -r public /${WORKING_DIR}/.
  fi
else
  echo "There is no post under /${WORKING_DIR}/source/_posts..."
fi

