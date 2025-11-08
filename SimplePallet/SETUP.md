# セットアップガイド

このドキュメントでは、SimplePallet プロジェクトのセットアップ方法を説明します。

## 前提条件

- macOS 13 Ventura 以降
- Xcode 15.0 以降
- Git

## プロジェクトのセットアップ

### 1. Xcode プロジェクトの作成

現在のプロジェクトは Swift ファイルのみで構成されています。
Xcode プロジェクトを作成する必要があります。

**ディレクトリ構造の確認：**
```
SimplePallet/                          ← ワークスペースルート
└── SimplePallet/                       ← ① Xcodeプロジェクトがある階層
    ├── Package.swift
    ├── README.md
    ├── SETUP.md
    └── SimplePallet/                   ← ② ソースコードがある階層
        ├── SimplePalletApp.swift
        ├── SimplePallet.xcodeproj/    ← Xcodeプロジェクト
        ├── SimplePallet.entitlements
        ├── Info.plist
        ├── App/
        ├── Core/
        ├── Models/
        ├── Modal/
        └── Resources/
```

#### オプション A: Xcode から新規プロジェクトを作成（推奨）

1. Xcode を開く
2. **File → New → Project**
3. **macOS → App** を選択
4. プロジェクト設定：
   - **Product Name**: `SimplePallet`
   - **Team**: 自分の開発チーム
   - **Organization Identifier**: `com.koike`
   - **Bundle Identifier**: `com.koike.SimplePallet`
   - **Interface**: `SwiftUI`
   - **Language**: `Swift`
   - **Storage**: `None`
   - **Create Document Types**: オフ
   - **Create Widget Extension**: オフ
5. 保存先を選択：
   - **重要**: プロジェクトルートディレクトリを選択
   - `Package.swift` が入っているディレクトリ
   - ⚠️ その中の `SimplePallet/SimplePallet/`（ソースコードがある階層）ではない

6. **既存のSwiftファイルをプロジェクトに追加：**
   - Xcode のプロジェクトナビゲーターで `SimplePallet` グループを右クリック
   - **Add Files to "SimplePallet"...**
   - `SimplePallet/SimplePallet/` 内の以下のフォルダ/ファイルを選択：
     - `App/` フォルダ
     - `Core/` フォルダ
     - `Models/` フォルダ
     - `Modal/` フォルダ
     - `Resources/` フォルダ
     - `SimplePalletApp.swift`
     - `SimplePallet.entitlements`
     - `Info.plist`
   - **Options で "Create groups" を選択**
   - **Add** をクリック

7. **デフォルトで作成された不要なファイルを削除：**
   - `ContentView.swift`（自動生成されたもの）
   - `SimplePalletApp.swift`（自動生成されたもの、既に自前のものがある）
   - `Assets.xcassets`（必要に応じて残す）

#### オプション B: swift package generate-xcodeproj を使用（非推奨）

```bash
cd SimplePallet
swift package generate-xcodeproj
```

※ この方法は Swift 5.9 以降では非推奨ですが、一時的には動作します。

### 2. プロジェクト設定の調整

Xcode でプロジェクトを開いた後、以下の設定を確認・変更します。

#### General タブ

- **Display Name**: `SimplePallet`
- **Bundle Identifier**: `com.koike.SimplePallet`
- **Version**: `1.0`
- **Build**: `1`
- **Minimum Deployments**: `macOS 13.0`

#### Signing & Capabilities タブ

1. **Automatically manage signing** をオン
2. **Team** を選択

3. **Capability を追加：**
   - **App Sandbox** を追加（App Store 配布に必須）
   - **Hardened Runtime** を追加

4. **App Sandbox の設定：**
   - ✅ **Outgoing Connections (Client)**（システム設定を開くため）
   - ❌ その他は全てオフ（最小権限）

#### Info タブ

1. **Custom macOS Application Target Properties** で以下を確認：
   - `Application is agent (UIElement)`: `YES`（Dockに表示しない）
   - `Privacy - Accessibility Usage Description`: `SimplePalletは他のアプリのウィンドウを操作するためにアクセシビリティ機能を使用します。`

2. `Info.plist` を直接編集する場合：
   - プロジェクトに含まれている `Info.plist` を使用
   - または Xcode の Info タブで設定

#### Build Settings タブ

- **Product Name**: `SimplePallet`
- **Product Bundle Identifier**: `com.koike.SimplePallet`
- **Info.plist File**: `SimplePallet/Info.plist`（パスを確認）
- **Create Info.plist Section in Binary**: `YES`

### 3. 依存関係の追加

SimplePallet は **KeyboardShortcuts** ライブラリを使用してグローバルショートカットを実装しています。

#### KeyboardShortcuts ライブラリの追加

1. Xcode でプロジェクトを開く
2. プロジェクトナビゲーターでプロジェクトファイルを選択
3. **Package Dependencies** タブを選択
4. **+** ボタンをクリック
5. 以下の URL を入力（**`.git` 拡張子を忘れずに！**）:
   ```
   https://github.com/sindresorhus/KeyboardShortcuts.git
   ```
6. **Up to Next Major Version** を選択し、バージョンは最新を使用（2.0.0 以上）
7. **Add Package** をクリック
8. ターゲット **SimplePallet** に `KeyboardShortcuts` を追加
9. パッケージの解決とダウンロードが完了するまで待つ

**技術的な詳細：**
- KeyboardShortcuts ライブラリによるグローバルショートカット登録
- アクセシビリティ API によるウィンドウ操作
- シンプルで信頼性の高い実装

### 4. Entitlements ファイルの作成

1. **File → New → File**
2. **Property List** を選択
3. **Save As**: `SimplePallet.entitlements`
4. 以下の内容を追加：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.app-sandbox</key>
    <true/>
    <key>com.apple.security.network.client</key>
    <true/>
</dict>
</plist>
```

5. **Build Settings** で `Code Signing Entitlements` に `SimplePallet/SimplePallet.entitlements` を設定

### 5. ビルドと実行

1. **Product → Build** (⌘B) でビルド
2. エラーが出た場合は、import文やターゲットメンバーシップを確認
3. **Product → Run** (⌘R) で実行

### 6. 動作確認

1. アプリが起動すると、メニューバーにアイコンが表示されます
2. アクセシビリティ権限のダイアログが表示されるので、許可します
3. **システム設定 → プライバシーとセキュリティ → アクセシビリティ** で SimplePallet にチェック
4. アプリを再起動
5. メニューバーアイコンから以下の機能を確認：
   - **設定...**: 設定画面が開く
   - **使い方を見る**: 使い方モーダルが開く
6. デフォルトのショートカットでウィンドウをスナップ：
   - `⌘ + ↑`: 最大化
   - `⌘ + ←`: 左半分
   - `⌘ + →`: 右半分
7. **重要**: 何回でも連続して動作することを確認してください（トグル機能なし、常に指定サイズに変更）

## トラブルシューティング

### ビルドエラー: "Cannot find type 'XXX' in scope"

- 各 Swift ファイルがプロジェクトのターゲットに追加されているか確認
- ファイルを選択して、右サイドバーの **Target Membership** で `SimplePallet` にチェック

### アプリが起動しない

- **Signing & Capabilities** で正しいチームが選択されているか確認
- **Build Settings** で `Code Signing Identity` が設定されているか確認

### 実行時エラー: `SimplePallet.debug.dylib` が読み込めない

LLDB やターミナルから `SimplePallet.app` を起動したときに次のようなエラーが出る場合、

```
Error creating LLDB target at path '.../SimplePallet.app'
dyld: Library not loaded: @rpath/SimplePallet.debug.dylib
```

デバッグ用のサポートライブラリ `SimplePallet.debug.dylib` がアプリバンドルにコピーされていません。以下の手順で再ビルドすると解消できます。

1. 念のため対象プロジェクトの DerivedData を削除します。
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData/SimplePallet-*
   ```
2. プロジェクトルート（`SimplePallet/SimplePallet/SimplePallet/`）で Xcode 用ビルドを実行します。
   ```bash
   xcodebuild -scheme SimplePallet -configuration Debug build
   ```
   もしくは Xcode を開いて `⌘B` でビルドします。
3. ビルド後に `~/Library/Developer/Xcode/DerivedData/.../Debug/SimplePallet.app/Contents/MacOS/`
   内に `SimplePallet` と `SimplePallet.debug.dylib` が揃っていることを確認してください。

ライブラリが揃っていれば、`SimplePallet.app` を直接起動しても同エラーは発生しません。

### ショートカットが動作しない

- アクセシビリティ権限が許可されているか確認
- システム環境設定で他のアプリとショートカットが競合していないか確認

## 次のステップ

- [README.md](README.md) でアプリの使い方を確認
- [PRIVACY_POLICY.md](PRIVACY_POLICY.md) でプライバシーポリシーを確認
- App Store 配布の準備（アイコン、スクリーンショット、App Store Connect 登録）

## サポート

問題が発生した場合は、GitHub Issues で報告してください。
