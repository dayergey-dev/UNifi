#!/bin/bash
# ── UniFi AI Connector — push to new GitHub repo ──────────────────────────
# Usage: bash push_to_github.sh <github-username> <github-token>
# Get a token at: https://github.com/settings/tokens (needs repo scope)

GITHUB_USER="${1:?Pass your GitHub username as arg 1}"
GITHUB_TOKEN="${2:?Pass your GitHub token as arg 2}"
REPO_NAME="unifi-ai-connector"

echo "→ Creating GitHub repo: $GITHUB_USER/$REPO_NAME"
curl -s -o /dev/null -w "  HTTP %{http_code}\n" \
  -X POST https://api.github.com/user/repos \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"name\": \"$REPO_NAME\",
    \"description\": \"UniFi Cloud × Perplexity / Claude AI connector\",
    \"private\": false,
    \"auto_init\": false
  }"

echo "→ Initialising local repo"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"
git init
git add unifi_ai_connector_v2.html
git commit -m "feat: UniFi Cloud × Perplexity/Claude AI connector"

echo "→ Pushing to GitHub"
git remote add origin "https://$GITHUB_USER:$GITHUB_TOKEN@github.com/$GITHUB_USER/$REPO_NAME.git"
git branch -M main
git push -u origin main

echo ""
echo "✓ Done → https://github.com/$GITHUB_USER/$REPO_NAME"
