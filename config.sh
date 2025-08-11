#!/bin/bash

#==============================================================================
# Simple Window Switcher - Configuration File
#==============================================================================

# デバッグ設定
DEBUG=${DEBUG:-0}                    # 0=OFF, 1=ON (環境変数で上書き可能)

# ログファイル設定
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$SCRIPT_DIR/simple_switcher.log"

# ウィンドウ切り替え動作設定
MIN_WINDOWS_FOR_SWITCH=2             # 切り替えに必要な最小ウィンドウ数
ENABLE_SWITCH_CONFIRMATION=false     # 切り替え後の確認ログ (true/false)

# 依存ツールのパス（通常は自動検出されるため変更不要）
YABAI_CMD="yabai"                    # yabaiコマンドのパス
JQ_CMD="jq"                          # jqコマンドのパス

# ログ出力レベル
# 0: エラーのみ
# 1: 基本情報
# 2: 詳細情報（デバッグモード時）
LOG_LEVEL=2
