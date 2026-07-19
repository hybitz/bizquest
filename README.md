# 環境構築手順
## AlmaLinux 9 を用意
### sudo 権限を付与
```
（ユーザで）$ su
（ルートで）# sed -i -e 's/\(\/sbin:\/bin:\/usr\/sbin:\/usr\/bin\)$/&:\/usr\/local\/bin/' /etc/sudoers
（ルートで）# echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER
```
### Rust環境をインストール
```
$ sudo dnf install git gcc
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
### Node.js / Yarn をインストール
```
$ sudo dnf module install nodejs:22
$ sudo npm install -g yarn
```
## BizQuestの準備
### BizQuestのソースを取得
```
$ git clone [https://github.com/hybitz/bizquest.git または git@github.com:hybitz/bizquest.git]
$ cd bizquest
```
### ライブラリのインストール
```
$ yarn install
```
### アセットのビルド
```
$ yarn build:css
$ yarn build
```
# 遊び方
### 起動
```
$ cargo run --release
```
ブラウザから http://localhost:3000 にアクセスします。
# 開発
### ultraman をインストール
```
$ cargo install ultraman
```
### 開発サーバーの起動
```
$ ultraman start -f Procfile.dev
```
サーバーの起動に加えて、JS/CSS の変更を監視して自動で再ビルドします。
