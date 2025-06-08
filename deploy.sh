#!/bin/bash
# Script de deploy automatizado para o blog Jekyll com tema Chirpy
set -e
JEKYLL_ENV=production bundle exec jekyll build
cd _site
if [ -z "$(git rev-parse --git-dir 2>/dev/null)" ]; then
  git init
  git checkout -b gh-pages
fi
git add .
msg="Deploy `date '+%Y-%m-%d %H:%M:%S'`"
git commit -m "$msg" || true
REMOTE_URL=$(git config --get remote.origin.url || echo "https://github.com/SEU_USUARIO/SEU_REPO.git")

git remote add origin "$REMOTE_URL" 2>/dev/null || true
git push -f origin gh-pages
cd ..
