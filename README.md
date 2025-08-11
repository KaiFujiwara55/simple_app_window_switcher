# Simple Window Switcher

シンプルなウィンドウ切り替えツール（赤枠表示なし）

## 🚀 クイックスタート

```bash
# 実行
./simple_window_switcher.sh

# デバッグモードで実行  
DEBUG=1 ./simple_window_switcher.sh
```

## ⚙️ セットアップ方法

### 1. 必要な依存関係をインストール

```bash
# yabaiのインストール（Homebrew）
brew install koekeishiya/formulae/yabai

# jqのインストール
brew install jq
```

### 2. yabaiの設定

```bash
# yabaiサービス開始
yabai --start-service

# 自動起動設定（オプション）
brew services start yabai
```

### 3. スクリプトに実行権限を付与

```bash
chmod +x simple_window_switcher.sh
```

### 4. 動作確認

```bash
# テスト実行
./simple_window_switcher.sh

# ログ確認
tail -f simple_switcher.log
```

## 🔧 設定ファイル (`config.sh`)

| 設定項目 | デフォルト | 説明 |
|---------|------------|------|
| `DEBUG` | `0` | デバッグモード (0=OFF, 1=ON) |
| `LOG_LEVEL` | `2` | ログレベル (0=エラーのみ, 1=基本情報, 2=詳細) |
| `MIN_WINDOWS_FOR_SWITCH` | `2` | 切り替えに必要な最小ウィンドウ数 |
| `ENABLE_SWITCH_CONFIRMATION` | `false` | 切り替え後の確認ログ |
| `LOG_FILE` | `simple_switcher.log` | ログファイルパス |

### 設定例

```bash
# config.sh を編集
vim config.sh

# エラーのみログ出力
LOG_LEVEL=0

# 基本情報まで出力（推奨）
LOG_LEVEL=1

# 詳細ログ出力（デバッグ用）
LOG_LEVEL=2
```

## 📝 使用方法

### 基本操作

1. 任意のアプリケーションのウィンドウにフォーカス
2. スクリプトを実行
3. 同一アプリの次のウィンドウに切り替わる
4. 最後のウィンドウの場合は最初に戻る（循環）


## 📊 ログレベル別出力例

### LOG_LEVEL=0 (エラーのみ)
```
[2025-08-11 14:30:15] [ERROR] Error: Current window not found in window list
```

### LOG_LEVEL=1 (基本情報)
```
[2025-08-11 14:30:15] [INFO] === Simple Window Switcher Started ===
[2025-08-11 14:30:15] [INFO] Window switch completed successfully
[2025-08-11 14:30:15] [INFO] === Simple Window Switcher Completed ===
```

### LOG_LEVEL=2 (詳細情報)
```
[2025-08-11 14:30:15] [INFO] === Simple Window Switcher Started ===
[2025-08-11 14:30:15] [DEBUG] Current: App=ターミナル, ID=298
[2025-08-11 14:30:15] [DEBUG] Available windows: 298 2198 2243
[2025-08-11 14:30:15] [DEBUG] Switching to next window: 2198
[2025-08-11 14:30:15] [INFO] Window switch completed successfully
```

## 🔍 トラブルシューティング

### よくある問題

1. **yabaiが見つからない**
   ```bash
   Error: yabai not found. Please install yabai first.
   ```
   → `brew install koekeishiya/formulae/yabai`

2. **jqが見つからない**
   ```bash
   Error: jq not found. Please install jq first.
   ```
   → `brew install jq`

3. **ウィンドウが切り替わらない**
   - yabaiサービスが起動しているか確認: `brew services list | grep yabai`
   - System Preferences → Security & Privacy → Accessibility でyabaiを許可

### デバッグ方法

```bash
# 詳細ログで実行
DEBUG=1 LOG_LEVEL=2 ./simple_window_switcher.sh

# ログをリアルタイム監視
tail -f simple_switcher.log
```

## ✨ 特徴

- ✅ **軽量**: 視覚効果なしでメモリ使用量最小
- ✅ **高速**: 遅延なしの即座切り替え
- ✅ **シンプル**: 設定ファイルで簡単カスタマイズ
- ✅ **安全**: プロセス管理なしでクリーン動作
