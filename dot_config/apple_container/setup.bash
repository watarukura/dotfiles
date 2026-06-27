#!/usr/bin/env bash
# Apple container machine(Ubuntu/systemd) に docker/compose 環境を用意する冪等セットアップ。
# 何度実行しても同じ結果になる（from-scratch でも既存状態でもOK）。
# 必要権限: 不要（container CLI はユーザー権限。sudo を使うステップは含めない）
#
# 使い方:  sh setup.sh
set -euo pipefail

MACHINE="${MACHINE:-ubuntu}"
IMAGE="${IMAGE:-local/ubuntu-machine:latest}"
SELF_DIR="$(cd "$(dirname "$0")" && pwd)"
KERNELS_DIR="$HOME/Library/Application Support/com.apple.container/kernels"

say() { printf '\n=== %s ===\n' "$*"; }

# 1) systemd+docker 入り Ubuntu イメージをビルド（冪等: 同タグ上書き）
say "1. build image ($IMAGE)"
container build -t "$IMAGE" -f "$SELF_DIR/Dockerfile" "$SELF_DIR" >/dev/null
echo "built: $IMAGE"

# 2) netfilter 入りカーネルへ差し替え（冪等: 既に 6.18.x 系なら skip）
say "2. ensure netfilter kernel"
cur="$(readlink "$KERNELS_DIR/default.kernel-arm64" 2>/dev/null || true)"
case "$cur" in
*vmlinux-6.1[89]* | *vmlinux-6.2* | *vmlinux-7*)
  echo "kernel already netfilter-capable: $(basename "$cur")"
  ;;
*)
  echo "swapping to recommended Kata kernel..."
  container system kernel set --recommended --force
  ;;
esac

# 3) machine を用意（冪等: 無ければ create、あれば再利用）
say "3. ensure machine ($MACHINE)"
if container machine list 2>/dev/null | awk 'NR>1{print $1}' | grep -qx "$MACHINE"; then
  echo "machine exists: $MACHINE"
else
  container machine create -n "$MACHINE" "$IMAGE"
  echo "created: $MACHINE"
fi

# 4) 起動して docker が active になるまで待つ（冪等: 何度でも）
say "4. boot & wait for docker"
# 初回 run がまれに 'Operation not supported by device' を返すのでリトライ
i=0
while [ "$i" -lt 5 ]; do
  if container machine run -n "$MACHINE" --user root -- true 2>/dev/null; then break; fi
  container machine stop "$MACHINE" >/dev/null 2>&1 || true
  i=$((i + 1))
  sleep 2
done
# docker が active になるまでポーリング
i=0
until container machine run -n "$MACHINE" --user root -- systemctl is-active --quiet docker 2>/dev/null; do
  i=$((i + 1))
  [ "$i" -ge 15 ] && {
    echo "ERROR: docker not active"
    exit 1
  }
  sleep 2
done

say "DONE"
printf 'kernel : '
container machine run -n "$MACHINE" --user root -- uname -r
printf 'docker : '
container machine run -n "$MACHINE" --user root -- docker --version
printf 'compose: '
container machine run -n "$MACHINE" --user root -- docker compose version
echo
echo "machine '$MACHINE' は docker 利用可能です。"
