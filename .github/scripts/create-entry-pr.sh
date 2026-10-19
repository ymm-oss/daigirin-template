#!/usr/bin/env bash
# 参加表明用の空コミットのドラフト PR を作成する。
# ローカルにリポジトリを clone しなくても、GitHub API 経由でブランチと空コミットを作成する。
#
# 使い方:
#   .github/scripts/create-entry-pr.sh [--login <GitHub ID>] [--name <表示名>] [--message <ひとこと>] [--repo <owner/repo>] [--base <ブランチ>]
#
# 必要なもの:
#   - GitHub CLI (gh) と、対象リポジトリへの書き込み権限を持つ認証情報（GH_TOKEN または gh auth login）

set -euo pipefail

LOGIN=""
NAME=""
MESSAGE=""
REPO=""
BASE=""

while [ $# -gt 0 ]; do
  case "$1" in
    --login) LOGIN="$2"; shift 2 ;;
    --name) NAME="$2"; shift 2 ;;
    --message) MESSAGE="$2"; shift 2 ;;
    --repo) REPO="$2"; shift 2 ;;
    --base) BASE="$2"; shift 2 ;;
    -h|--help) sed -n '2,9p' "$0"; exit 0 ;;
    *) echo "エラー: 不明な引数です: $1" >&2; exit 1 ;;
  esac
done

if [ -z "$REPO" ]; then
  REPO=$(gh repo view --json nameWithOwner --jq .nameWithOwner)
fi
if [ -z "$BASE" ]; then
  BASE=$(gh api "repos/${REPO}" --jq .default_branch)
fi
if [ -z "$LOGIN" ]; then
  LOGIN=$(gh api user --jq .login)
fi

BRANCH="entry/${LOGIN}"

if [ -n "$NAME" ]; then
  TITLE="[参加表明] ${NAME} (@${LOGIN})"
  WHO="@${LOGIN}（${NAME}）"
else
  TITLE="[参加表明] @${LOGIN}"
  WHO="@${LOGIN}"
fi

# 同じ参加者のブランチがすでにある場合は、既存の PR を案内して終了する
if gh api "repos/${REPO}/git/ref/heads/${BRANCH}" > /dev/null 2>&1; then
  EXISTING_PR=$(gh pr list --repo "$REPO" --head "$BRANCH" --state open --json url --jq '.[0].url // empty')
  if [ -n "$EXISTING_PR" ]; then
    echo "${WHO} の参加表明 PR はすでに存在します: ${EXISTING_PR}"
    exit 0
  fi
  echo "エラー: ブランチ ${BRANCH} がすでに存在しますが、オープンな PR がありません。ブランチを削除するか、手動で PR を作成してください。" >&2
  exit 1
fi

# ベースブランチの最新コミットと同じツリーを持つ空コミットを作成する
BASE_SHA=$(gh api "repos/${REPO}/git/ref/heads/${BASE}" --jq .object.sha)
TREE_SHA=$(gh api "repos/${REPO}/git/commits/${BASE_SHA}" --jq .tree.sha)
COMMIT_SHA=$(gh api "repos/${REPO}/git/commits" \
  -f message="参加表明: ${WHO}" \
  -f tree="$TREE_SHA" \
  -f "parents[]=${BASE_SHA}" \
  --jq .sha)

gh api "repos/${REPO}/git/refs" \
  -f ref="refs/heads/${BRANCH}" \
  -f sha="$COMMIT_SHA" > /dev/null

BODY=$(cat <<EOF
## 参加表明

${WHO} は、本書への参加を表明します。

## ひとこと

${MESSAGE:-（なし）}

## 補足

- この PR は進捗管理のための参加表明用ドラフト PR です。
- 空コミットのみの状態ではマージしないでください。
- 執筆を始めるときは、このブランチ \`${BRANCH}\` に原稿を追加してください。
EOF
)

PR_URL=$(gh pr create \
  --repo "$REPO" \
  --base "$BASE" \
  --head "$BRANCH" \
  --draft \
  --title "$TITLE" \
  --body "$BODY")

# 担当者の設定は失敗しても PR 作成自体は成功しているため、警告のみとする
gh pr edit "$PR_URL" --repo "$REPO" --add-assignee "$LOGIN" > /dev/null 2>&1 \
  || echo "警告: 担当者 @${LOGIN} を設定できませんでした。" >&2

echo "参加表明 PR を作成しました: ${PR_URL}"

if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
  echo "参加表明 PR を作成しました: ${PR_URL}" >> "$GITHUB_STEP_SUMMARY"
fi
