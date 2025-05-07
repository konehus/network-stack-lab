#!/usr/bin/env bash
set -e

# Rewrite commits authored or committed by terassyi (<emails>) to Henok Haile <konehus@gmail.com>
#
# Usage: ./rewrite_terassyi.sh

git filter-branch --force --env-filter '
if [ "$GIT_AUTHOR_EMAIL" = "iscale821@gmail.com" ] || \
   [ "$GIT_AUTHOR_EMAIL" = "49265363+terassyi@users.noreply.github.com" ]; then
  export GIT_AUTHOR_NAME="Henok Haile"
  export GIT_AUTHOR_EMAIL="konehus@gmail.com"
fi
if [ "$GIT_COMMITTER_EMAIL" = "iscale821@gmail.com" ] || \
   [ "$GIT_COMMITTER_EMAIL" = "49265363+terassyi@users.noreply.github.com" ]; then
  export GIT_COMMITTER_NAME="Henok Haile"
  export GIT_COMMITTER_EMAIL="konehus@gmail.com"
fi
' --tag-name-filter cat -- --branches --tags

echo "Rewritten terassyi commits to Henok Haile <konehus@gmail.com>"