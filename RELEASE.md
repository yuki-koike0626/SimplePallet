# リリース手順

SimplePalletの新しいバージョンをリリースする手順です。

## 📋 事前準備

### 1. Developer ID証明書の確認
```bash
security find-identity -v -p codesigning
```

「Developer ID Application」証明書があることを確認してください。

### 2. Sparkle署名鍵の生成（初回のみ）
```bash
# Sparkleのgenerate_keysツールを使用
./path/to/Sparkle/bin/generate_keys
```

生成された公開鍵を `Info.plist` の `SUPublicEDKey` に設定してください。
秘密鍵は**安全に保管**してください。

## 🚀 リリース手順

### ステップ1: バージョン番号の更新

1. Xcodeでプロジェクトを開く
2. Target > General > Identity
3. `Version` と `Build` を更新
4. `Info.plist` の `CFBundleShortVersionString` と `CFBundleVersion` も確認

### ステップ2: アプリのアーカイブ

```bash
# Xcodeでアーカイブ
# Product > Archive
```

または、コマンドラインで：

```bash
xcodebuild -scheme SimplePallet \
  -configuration Release \
  -archivePath ./build/SimplePallet.xcarchive \
  archive
```

### ステップ3: アプリのエクスポート

Xcodeの Organizer から：
1. 作成したアーカイブを選択
2. 「Distribute App」をクリック
3. 「Developer ID」を選択
4. 「Export」を選択
5. エクスポート先を `./build/` に指定

### ステップ4: DMGの作成

```bash
./scripts/create-dmg.sh
```

これで `./dist/SimplePallet-1.0.dmg` が作成されます。

### ステップ5: DMGの署名と公証

```bash
# 署名
codesign --sign "Developer ID Application: Your Name (TEAM_ID)" \
  --timestamp \
  ./dist/SimplePallet-1.0.dmg

# 公証の申請
xcrun notarytool submit ./dist/SimplePallet-1.0.dmg \
  --apple-id "your-email@example.com" \
  --team-id "TEAM_ID" \
  --password "app-specific-password" \
  --wait

# 公証のステープル
xcrun stapler staple ./dist/SimplePallet-1.0.dmg
```

**注意**: App用パスワードは https://appleid.apple.com で生成できます。

### ステップ6: GitHub Releasesへのアップロード

1. GitHubリポジトリの「Releases」タブを開く
2. 「Draft a new release」をクリック
3. Tag version: `v1.0`
4. Release title: `SimplePallet 1.0`
5. リリースノートを記入
6. DMGファイルをドラッグ＆ドロップ
7. 「Publish release」をクリック

### ステップ7: appcast.xmlの更新

1. DMGファイルのサイズを取得：
```bash
ls -l ./dist/SimplePallet-1.0.dmg
```

2. EdDSA署名を生成：
```bash
./path/to/Sparkle/bin/sign_update ./dist/SimplePallet-1.0.dmg \
  --ed-key-file /path/to/your/private_key
```

3. `appcast.xml` を更新：
   - `url`: GitHub ReleasesのDMGの直接ダウンロードURL
   - `length`: DMGファイルのサイズ（バイト）
   - `sparkle:edSignature`: 生成した署名
   - `pubDate`: 現在の日時

4. appcast.xmlをGitHub Pagesまたはホスティングサーバーにアップロード

### ステップ8: 動作確認

1. SimplePalletを起動
2. メニューから「アップデートをチェック」
3. 新しいバージョンが検出されることを確認
4. アップデートが正常に動作することを確認

## 📝 appcast.xmlのホスティング方法

### 方法1: GitHub Pages（推奨）

1. リポジトリの Settings > Pages を開く
2. Source を「main branch」に設定
3. `appcast.xml` をリポジトリのルートに配置
4. URL: `https://yourusername.github.io/SimplePallet/appcast.xml`

### 方法2: 独自サーバー

- HTTPSで配信可能なサーバーに `appcast.xml` をアップロード
- Info.plistの `SUFeedURL` を更新

## ⚠️ トラブルシューティング

### 署名エラー

```bash
# 証明書の有効期限を確認
security find-certificate -c "Developer ID Application"
```

### 公証エラー

```bash
# 公証のログを確認
xcrun notarytool log <submission-id> \
  --apple-id "your-email@example.com" \
  --team-id "TEAM_ID" \
  --password "app-specific-password"
```

### Sparkleが更新を検出しない

- appcast.xmlのURL が正しいか確認
- appcast.xmlが有効なXMLか確認（オンラインのXMLバリデータを使用）
- バージョン番号が正しく増加しているか確認

