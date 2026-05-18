#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HOST_TARGET="/usr/local/bin/session_block_host"
MANIFEST_DIR="$HOME/Library/Application Support/Mozilla/NativeMessagingHosts"
CMD_PATH="/tmp/session_block.cmd"

echo "=== Session Block インストール ==="

# 1. ホストスクリプトをコピーして実行権限を付与
echo "→ ホストスクリプトをコピー中..."
sudo cp "$SCRIPT_DIR/session_block_host.py" "$HOST_TARGET"
sudo chmod +x "$HOST_TARGET"
echo "  完了: $HOST_TARGET"

# 2. ホストマニフェストを配置
echo "→ ホストマニフェストを配置中..."
mkdir -p "$MANIFEST_DIR"
cp "$SCRIPT_DIR/com.haruharu.sessionblock.json" "$MANIFEST_DIR/com.haruharu.sessionblock.json"
echo "  完了: $MANIFEST_DIR/com.haruharu.sessionblock.json"

echo "→ コマンドは curl http://127.0.0.1:7373/start|stop|break で送信"

echo ""
echo "=== インストール完了 ==="
echo ""
echo "次のステップ:"
echo "1. Firefox の about:debugging を開く"
echo "2. 'この Firefox' → '一時的なアドオンを読み込む'"
echo "3. $(dirname "$SCRIPT_DIR")/manifest-firefox.json を選択"
echo ""
echo "Stay in Session の Automation 設定に以下の AppleScript を登録:"
echo ""
echo "  session_start 用:"
echo '    do shell script "echo '"'"'start'"'"' > /tmp/session_block.pipe"'
echo ""
echo "  break_start / stop_working 用:"
echo '    do shell script "echo '"'"'break'"'"' > /tmp/session_block.pipe"'
