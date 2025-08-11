#!/bin/bash

#==============================================================================
# Simple Window Switcher (赤枠なし版)
#==============================================================================
# 機能: yabaiを使用して同一アプリケーション内のウィンドウを順次切り替え
# 特徴: シンプル、高速、視覚効果なし
#==============================================================================

# 設定ファイルの読み込み
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

# ログ関数（レベル別）
log() {
    local level=$1
    shift
    local message="$*"
    local timestamp="[$(date '+%Y-%m-%d %H:%M:%S')]"
    
    # DEBUGモードまたは指定ログレベル以下の場合のみログ出力
    if [ "$DEBUG" = "1" ] || [ "$level" -le "$LOG_LEVEL" ]; then
        case $level in
            0) echo "$timestamp [ERROR] $message" >> "$LOG_FILE" ;;
            1) echo "$timestamp [INFO] $message" >> "$LOG_FILE" ;;
            2) echo "$timestamp [DEBUG] $message" >> "$LOG_FILE" ;;
        esac
    fi
}

# ログレベル別関数
log_error() { log 0 "$*"; }
log_info() { log 1 "$*"; }
log_debug() { log 2 "$*"; }

# メインのウィンドウ切り替え処理
switch_window() {
    log_info "=== Simple Window Switcher Started ==="
    
    # 現在のウィンドウ情報取得
    current_window=$($YABAI_CMD -m query --windows --window)
    current_app=$(echo "$current_window" | $JQ_CMD -r '.app')
    current_id=$(echo "$current_window" | $JQ_CMD -r '.id')
    
    log_debug "Current: App=$current_app, ID=$current_id"
    
    # 同一アプリのウィンドウリスト取得（ソート済み）
    app_windows=$($YABAI_CMD -m query --windows | $JQ_CMD -r ".[] | select(.app == \"$current_app\" and .\"is-minimized\" == false) | .id" | sort -n)
    windows_array=($app_windows)
    
    log_debug "Available windows: ${windows_array[*]}"
    
    # ウィンドウが設定値未満の場合は何もしない
    if [ ${#windows_array[@]} -lt $MIN_WINDOWS_FOR_SWITCH ]; then
        log_info "Only ${#windows_array[@]} window(s) available, no switching needed"
        return 0
    fi
    
    # 現在のウィンドウのインデックス検索
    current_index=-1
    for i in "${!windows_array[@]}"; do
        if [ "${windows_array[$i]}" = "$current_id" ]; then
            current_index=$i
            break
        fi
    done
    
    if [ "$current_index" -ge 0 ]; then
        # 次のウィンドウ決定
        next_index=$((current_index + 1))
        local target_window
        
        if [ "$next_index" -lt "${#windows_array[@]}" ]; then
            # 次のウィンドウへ
            target_window="${windows_array[$next_index]}"
            log_debug "Switching to next window: $target_window"
        else
            # 最後のウィンドウの場合は最初に戻る
            target_window="${windows_array[0]}"
            log_debug "Cycling to first window: $target_window"
        fi
        
        # ウィンドウ切り替え実行
        $YABAI_CMD -m window --focus "$target_window"
        
        # 切り替え後の確認（設定で有効な場合）
        if [ "$ENABLE_SWITCH_CONFIRMATION" = "true" ]; then
            new_window=$($YABAI_CMD -m query --windows --window)
            new_id=$(echo "$new_window" | $JQ_CMD -r '.id')
            new_title=$(echo "$new_window" | $JQ_CMD -r '.title')
            log_debug "Switch result: ID=$new_id, Title=$new_title"
        fi
        
        log_info "Window switch completed successfully"
    else
        log_error "Error: Current window not found in window list"
        return 1
    fi
}

# 必要ツールの確認
check_dependencies() {
    if ! command -v "$YABAI_CMD" >/dev/null 2>&1; then
        echo "Error: $YABAI_CMD not found. Please install yabai first."
        exit 1
    fi
    
    if ! command -v "$JQ_CMD" >/dev/null 2>&1; then
        echo "Error: $JQ_CMD not found. Please install jq first."
        exit 1
    fi
}

#==============================================================================
# メイン実行
#==============================================================================

# 依存関係チェック
check_dependencies

# ウィンドウ切り替え実行
switch_window

log_info "=== Simple Window Switcher Completed ==="
