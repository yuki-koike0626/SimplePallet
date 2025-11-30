# Sparkle統合手順

SimplePalletにSparkle（自動アップデート機能）を統合する手順です。

## 📦 ステップ1: SparkleパッケージをXcodeに追加

1. **Xcodeでプロジェクトを開く**
   ```
   SimplePallet/SimplePallet/SimplePallet.xcodeproj
   ```

2. **Package Dependenciesを追加**
   - メニューバー: `File` > `Add Package Dependencies...`

3. **SparkleのURLを入力**
   - 検索欄に以下を入力：
   ```
   https://github.com/sparkle-project/Sparkle
   ```

4. **バージョンを選択**
   - `Dependency Rule`: "Up to Next Major Version"
   - Version: `2.0.0` 以上を選択
   - 「Add Package」をクリック

5. **ターゲットに追加**
   - `Sparkle` にチェックを入れる
   - 「Add Package」をクリック

## 🔧 ステップ2: コードのコメントを解除

Sparkleが追加されたら、準備済みのコードのコメントを解除します。

### 1. SimplePalletApp.swift

```swift
// この行のコメントを解除：
import Sparkle

// そして、AppDelegateクラス内のコメントも解除：
private let updaterController: SPUStandardUpdaterController

override init() {
    updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    super.init()
}
```

### 2. MenuBarController.swift

```swift
// メニュー内のアップデートチェック項目のコメントを解除：
let updateItem = NSMenuItem(title: L("menu.checkForUpdates"), action: #selector(checkForUpdates), keyEquivalent: "")
updateItem.target = self
menu.addItem(updateItem)

menu.addItem(NSMenuItem.separator())

// そして、メソッドのコメントも解除：
@objc private func checkForUpdates() {
    if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
        appDelegate.updaterController.updater.checkForUpdates()
    }
}
```

### 3. Localizable.xcstrings

多言語対応のために、以下のキーを追加してください：

```json
"menu.checkForUpdates" : {
  "extractionState" : "manual",
  "localizations" : {
    "en" : {
      "stringUnit" : {
        "state" : "translated",
        "value" : "Check for Updates..."
      }
    },
    "ja" : {
      "stringUnit" : {
        "state" : "translated",
        "value" : "アップデートを確認..."
      }
    },
    "ko" : {
      "stringUnit" : {
        "state" : "translated",
        "value" : "업데이트 확인..."
      }
    },
    "zh-Hans" : {
      "stringUnit" : {
        "state" : "translated",
        "value" : "检查更新..."
      }
    },
    "zh-Hant" : {
      "stringUnit" : {
        "state" : "translated",
        "value" : "檢查更新..."
      }
    }
  }
}
```

## 🔐 ステップ3: EdDSA署名鍵の生成

Sparkle 2では、セキュアなアップデートのためにEdDSA署名が必要です。

### macOS / Linuxの場合

```bash
# Sparkleのツールをダウンロード（もしくはビルド後のSparkle.frameworkから使用）
# generate_keysツールを実行
./Sparkle.framework/Versions/Current/Resources/generate_keys

# または、Sparkleを一度ビルドすれば、以下のパスに生成されます：
# ~/Library/Developer/Xcode/DerivedData/SimplePallet-xxxxx/Build/Products/Debug/Sparkle.framework/Versions/B/Resources/generate_keys
```

### 鍵の生成

```bash
# 実行すると、以下が表示されます：
A key has been generated and saved in your keychain (ed25519)
Add the public key to your Info.plist:

<key>SUPublicEDKey</key>
<string>YOUR_PUBLIC_KEY_HERE</string>

The private key has also been saved to your keychain.
To use it for signing updates, use:
./sign_update path/to/update.dmg
```

### Info.plistを更新

生成された公開鍵を `Info.plist` の `SUPublicEDKey` に設定してください：

```xml
<key>SUPublicEDKey</key>
<string>ここに生成された公開鍵を貼り付け</string>
```

**重要**: 秘密鍵はキーチェーンに保存されます。絶対にGitにコミットしないでください。

## 🌐 ステップ4: appcast.xmlのホスティング

### 方法1: GitHub Pages（推奨）

1. GitHubリポジトリの Settings > Pages を開く
2. Source を "Deploy from a branch" に設定
3. Branch を `main` (または `master`) に設定
4. Save をクリック

5. `appcast.xml` をリポジトリのルートに配置

6. `Info.plist` の `SUFeedURL` を更新：
```xml
<key>SUFeedURL</key>
<string>https://yourusername.github.io/SimplePallet/appcast.xml</string>
```

### 方法2: カスタムドメイン

独自ドメインを使用する場合：

1. `appcast.xml` をHTTPS対応のサーバーにアップロード
2. `Info.plist` の `SUFeedURL` を更新

## ✅ ステップ5: 動作確認

1. **ビルド & 実行**
   ```bash
   # Xcodeで
   ⌘ + R
   ```

2. **アップデートチェックをテスト**
   - メニューバーのSimplePalletアイコンをクリック
   - 「アップデートを確認...」が表示されることを確認
   - クリックしてアップデートチェックが動作することを確認

3. **ビルドエラーがないことを確認**
   - Sparkleがインポートされている
   - コンパイルエラーがない

## 🚀 初回リリース後のアップデートフロー

### 1. 新しいバージョンをビルド

```bash
# Info.plistのバージョンを更新
# 例: 1.0 → 1.1
```

### 2. DMGを作成

```bash
./scripts/create-dmg.sh
```

### 3. DMGに署名

```bash
# sign_updateツールで署名を生成
./Sparkle.framework/Resources/sign_update ./dist/SimplePallet-1.1.dmg
```

出力例：
```
sparkle:edSignature="SIGNATURE_STRING_HERE" length="12345678"
```

### 4. appcast.xmlを更新

```xml
<item>
  <title>Version 1.1</title>
  <sparkle:version>1.1</sparkle:version>
  <sparkle:shortVersionString>1.1</sparkle:shortVersionString>
  <description><![CDATA[
    <h2>新機能</h2>
    <ul>
      <li>バグ修正</li>
    </ul>
  ]]></description>
  <pubDate>Mon, 01 Dec 2025 00:00:00 +0900</pubDate>
  <enclosure
    url="https://github.com/yourusername/SimplePallet/releases/download/v1.1/SimplePallet-1.1.dmg"
    sparkle:version="1.1"
    sparkle:shortVersionString="1.1"
    length="12345678"
    type="application/octet-stream"
    sparkle:edSignature="SIGNATURE_STRING_HERE"
  />
  <sparkle:minimumSystemVersion>13.0</sparkle:minimumSystemVersion>
</item>
```

### 5. GitHub Releasesにアップロード

1. DMGをGitHub Releasesにアップロード
2. 更新した `appcast.xml` をpush

### 6. ユーザーに通知

既存のユーザーは次回アプリ起動時に自動でアップデート通知を受け取ります！

## 🐛 トラブルシューティング

### ビルドエラー: "No such module 'Sparkle'"

- Xcodeを再起動
- Product > Clean Build Folder (⌘ + Shift + K)
- File > Packages > Reset Package Caches

### アップデートチェックが動作しない

1. **appcast.xmlが正しくホストされているか確認**
   ```bash
   curl https://yourusername.github.io/SimplePallet/appcast.xml
   ```

2. **Info.plistのSUFeedURLが正しいか確認**

3. **署名が正しいか確認**
   - 公開鍵が Info.plist に設定されている
   - appcast.xml の edSignature が正しい

### コンソールログの確認

```bash
# Xcodeのコンソールで以下のようなログを確認：
2025-11-22 12:00:00.000 SimplePallet[12345:6789] Sparkle: Checking for updates...
```

## 📚 参考リンク

- [Sparkle公式ドキュメント](https://sparkle-project.org/documentation/)
- [Sparkle GitHub](https://github.com/sparkle-project/Sparkle)
- [Appcast Format](https://sparkle-project.org/documentation/publishing/)

