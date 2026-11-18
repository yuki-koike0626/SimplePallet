# SimplePallet

macOS 向けのシンプルなウィンドウ管理アプリ。キーボードショートカットで最前面ウィンドウを「最大化 / 2分割 / 3分割」に即座にスナップできます。

## 📥 ダウンロード

### 最新版をダウンロード

[![最新リリース](https://img.shields.io/github/v/release/yuki-koike0626/SimplePallet?label=最新版&logo=apple&color=blue)](https://github.com/yuki-koike0626/SimplePallet/releases/latest)
[![ダウンロード数](https://img.shields.io/github/downloads/yuki-koike0626/SimplePallet/total?label=ダウンロード数&logo=github&color=green)](https://github.com/yuki-koike0626/SimplePallet/releases/latest)

**[SimplePallet-1.3.zip をダウンロード](https://github.com/yuki-koike0626/SimplePallet/releases/download/v1.3/SimplePallet-1.3.zip)**

### システム要件

- macOS 13 (Ventura) 以降
- Intel Mac / Apple Silicon Mac 両対応

## 🚀 インストール方法

1. **DMGファイルをダウンロード**
   - 上記のリンクから最新版の `SimplePallet-X.X.dmg` をダウンロード

2. **DMGファイルを開く**
   - ダウンロードした DMG ファイルをダブルクリック

3. **アプリをインストール**
   - 表示されたウィンドウで、SimplePallet アイコンを「Applications」フォルダにドラッグ＆ドロップ

4. **初回起動**
   - アプリケーションフォルダから SimplePallet を起動
   - 「開発元を確認できません」と表示される場合：
     - 右クリック（または Control + クリック）→「開く」を選択
     - または、システム環境設定 → プライバシーとセキュリティ → 「このまま開く」をクリック

5. **アクセシビリティ権限を許可**
   - 初回起動時に権限リクエストのダイアログが表示されます
   - 「システム環境設定を開く」をクリック
   - SimplePallet にチェックを入れて許可

6. **完了！**
   - メニューバーにアイコンが表示されます
   - キーボードショートカットですぐに使えます

## ✨ 機能

- **2分割スナップアクション**
  - 最大化: `⌘ + ↑`（デフォルト）
  - 左半分: `⌘ + ←`（デフォルト）
  - 右半分: `⌘ + →`（デフォルト）

- **3分割スナップアクション**
  - 左1/3: `⌥ + ⌘ + ←`（デフォルト）
  - 中央1/3: `⌥ + ⌘ + ↑`（デフォルト）
  - 右1/3: `⌥ + ⌘ + →`（デフォルト）

- **マルチディスプレイ対応**
  - アクティブ中のウィンドウの画面を自動検出し、その画面内で最大化・2分割・3分割を実現

- **メニューバー常駐**
  - Dockに表示せず、メニューバーから操作

## 📖 使い方

1. **メニューバーアイコン**
   - アプリを起動するとメニューバーにアイコンが表示されます
   - アイコンをクリックしてメニューを開けます

2. **キーボードショートカット**
   - デフォルトのショートカットで即座にウィンドウをスナップ
   - メニューバーから設定画面を開いてカスタマイズ可能

3. **自動アップデート**
   - 新しいバージョンがリリースされると自動で通知
   - ワンクリックでアップデート完了

## トラブルシューティング

### ショートカットが動作しない

1. **アクセシビリティ権限を確認**
   - システム環境設定 → プライバシーとセキュリティ → アクセシビリティ
   - SimplePallet にチェックが入っているか確認

2. **ショートカットの競合をチェック**
   - 他のアプリが同じショートカットを使用していないか確認
   - 設定画面から別のキーに変更してみる

3. **一時停止状態を確認**
   - メニューバーから「一時停止」になっていないか確認

### フルスクリーンアプリで動作しない

仕様です。フルスクリーンモードのアプリはウィンドウ操作の対象外となります。
フルスクリーンを解除してから操作してください。

### 特定のアプリで動作しない

一部のアプリ（システム環境設定、一部のモーダルウィンドウなど）は、
アクセシビリティ API で操作できない場合があります。

## プライバシー

SimplePallet は以下のポリシーに基づいています：

- **データ収集なし**: 個人情報や使用統計は一切収集しません
- **ローカル処理のみ**: 全ての処理はデバイス内で完結します
- **必要最小限の権限**: アクセシビリティ権限のみを要求します

## 🔧 開発者向け情報

**開発者の方へ**: このセクションはアプリを自分でビルドしたい開発者向けです。
エンドユーザーの方は上記の「ダウンロード」セクションから DMG をダウンロードしてください。

### セットアップ

**詳細なセットアップ手順は [SETUP_INSTRUCTIONS.md](SETUP_INSTRUCTIONS.md) を参照してください。**

#### クイックスタート

1. Xcodeでプロジェクトを開く
2. Sparkleを追加（File > Add Package Dependencies）
   - URL: `https://github.com/sparkle-project/Sparkle`
3. ビルド & 実行 (⌘R)

### リリース手順

新しいバージョンをリリースする詳細な手順は [RELEASE.md](../RELEASE.md) を参照してください。

### プロジェクト構成

```
SimplePallet/
├── SimplePallet/
│   ├── SimplePalletApp.swift              # エントリーポイント
│   ├── App/                               # UI関連
│   │   ├── MenuBarController.swift
│   │   ├── SettingsView.swift
│   │   └── ToastView.swift
│   ├── Core/                              # ビジネスロジック
│   │   ├── KeyboardShortcutManager.swift  # グローバルショートカット管理
│   │   ├── WindowManager.swift            # ウィンドウ操作
│   │   ├── ScreenCalculator.swift         # 画面計算
│   │   └── AccessibilityPermission.swift  # 権限管理
│   ├── Models/                            # データモデル
│   │   ├── SnappingAction.swift           # アクション定義
│   │   └── AppSettings.swift              # 設定管理
│   └── Resources/
├── SETUP_INSTRUCTIONS.md                  # セットアップ手順
└── README.md
```

### 依存ライブラリ

- [KeyboardShortcuts](https://github.com/sindresorhus/KeyboardShortcuts): グローバルキーボードショートカット登録
- [Sparkle](https://github.com/sparkle-project/Sparkle): 自動アップデート機能

### DMGの作成

```bash
# DMGビルドスクリプトを実行
./scripts/create-dmg.sh
```

詳細は [RELEASE.md](../RELEASE.md) を参照してください。

## ライセンス

Copyright © 2025 Yuki. All rights reserved.

## サポート

問題が発生した場合は、GitHub Issues で報告してください。

