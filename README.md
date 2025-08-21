# Dotfiles & Development Environment

このリポジトリはmacOSの開発環境を管理するための設定ファイルとスクリプトです。

## 🚀 セットアップ

### 1. Homebrewのインストール（未インストールの場合）
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. このリポジトリをクローン
```bash
git clone [your-repo-url] ~/dotfiles
cd ~/dotfiles
```

### 3. パッケージのインストール
```bash
chmod +x install.sh
./install.sh
```

## 📦 含まれるパッケージ

### ブラウザ
- Google Chrome
- Firefox

### 開発ツール
- Visual Studio Code
- iTerm2
- Docker
- Git, GitHub CLI
- Node.js, Python, Ruby, Go, Rust

### データベース
- PostgreSQL
- MySQL
- Redis
- SQLite

### ユーティリティ
- Raycast（Spotlight代替）
- Rectangle（ウィンドウ管理）
- Stats（システムモニター）

詳細は `Brewfile` を参照してください。

## 🔧 使い方

### パッケージの更新
```bash
./update.sh
```

### 現在の環境をバックアップ
```bash
./backup.sh
```

### Brewfileの編集
```bash
# 新しいパッケージを追加
echo 'cask "spotify"' >> Brewfile

# インストール
brew bundle
```

## 📝 Brewfileの書き方

```ruby
# Homebrewパッケージ
brew "package-name"

# GUIアプリケーション
cask "app-name"

# Mac App Storeアプリ
mas "App Name", id: 123456789

# Tapの追加
tap "user/repo"
```

## 🔄 Git管理

```bash
cd ~/dotfiles
git add .
git commit -m "Update packages"
git push
```

## 💡 Tips

- `brew bundle list` で現在のBrewfileの内容を確認
- `brew bundle check` で未インストールのパッケージを確認
- `brew bundle cleanup` で不要なパッケージを削除
- `mas search "app name"` でMac App StoreアプリのIDを検索