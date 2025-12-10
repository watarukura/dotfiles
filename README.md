# dotfiles

## Macでの初期化手順

1. 本リポジトリをcloneする
  - gitの利用のために`xcode-select --install`が必要
2. homebrewをinstallする
  - https://brew.sh/ja/
3. nixをinstallする
  - https://nixos.org/download/
4. nix-darwinをinstallする
  - https://github.com/nix-darwin/nix-darwin?tab=readme-ov-file#getting-started
  - /etc/zshrc, /etc/bashrc をnix install前のbackupに戻しておく必要あり

```shell
❯ cd /etc
❯ sudo cp bashrc.backup-before-nix bashrc
❯ sudo cp bashrc bashrc.backup-after-nix
❯ sudo cp zshrc.backup-before-nix zshrc
❯ sudo cp zshrc bashrc.backup-after-nix
```

5. nix.confを作成する

```shell
❯ cat .config/nix/nix.conf
experimental-features = nix-command flakes
```

6. 本リポジトリをcloneしたディレクトリ下よりdot_zshrcをsourceした後、`nix run .#update`を実行する
  - 初回は実行後に再起動が必要
7. chezmoiがinstallされたら、`chezmoi init https://github.com/watarukura/dotfiles.git` を実行する
8. 以後は、`chezmoi cd` してファイル更新を行う
