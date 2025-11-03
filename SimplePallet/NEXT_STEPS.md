# 次のステップ

Simple palet MVP の基本実装が完了しました！🎉

## 完成したもの

### ✅ コア機能
- **ScreenUtil**: マルチディスプレイ対応、画面選択・矩形計算
- **WindowMover**: AX API でウィンドウ操作、エラーハンドリング
- **AXPermission**: アクセシビリティ権限チェック・誘導
- **HotKeyManager**: HotKey ライブラリでグローバルショートカット登録

### ✅ UI/UX
- **MenuBarController**: メニューバーアイコンとメニュー項目
- **SettingsView**: SwiftUI で設定画面（ショートカット変更、権限誘導）
- **ToastView**: 軽量フィードバック表示

### ✅ データ管理
- **AppSettings**: ショートカット設定の永続化、自動起動設定

### ✅ ドキュメント
- **README.md**: 概要と使い方
- **SETUP.md**: 詳細なセットアップ手順
- **PRIVACY_POLICY.md**: プライバシーポリシー

## 今すぐやること

### 1. Xcode プロジェクトを作成
[SETUP.md](SETUP.md) の手順に従って、Xcode プロジェクトをセットアップしてください。

### 2. ビルドして動作確認
```bash
# Xcode でプロジェクトを開く
open SimplePallet.xcodeproj  # プロジェクト作成後

# または Xcode GUI から
# File → Open → SimplePallet.xcodeproj
```

### 3. テスト
- ✅ 1画面環境でウィンドウスナップが動作するか
- ✅ 2画面環境で正しい画面にスナップするか
- ✅ フルスクリーンアプリで適切なエラーが表示されるか
- ✅ 権限がない状態で適切なガイダンスが出るか
- ✅ ショートカット変更が保存されるか（※現在録画機能は未実装）

## 将来の実装（フェーズ2以降）

### 1. ショートカット録画機能の完全実装
現在の `SettingsView` では録画機能がモック実装になっています。
NSEvent のモニタリングを追加して、実際のキー入力を録画できるようにする必要があります。

**実装方針:**
```swift
// NSEvent.addGlobalMonitorForEvents を使用
let monitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
    // キーコードとモディファイアを取得
    let keyCode = event.keyCode
    let modifiers = event.modifierFlags
    // KeyCombination として保存
}
```

### 2. StoreKit2 統合（課金機能）
- `Purchase` フォルダの追加
- `PurchaseManager` の実装
- 年額 550円 のサブスクリプション設定
- 利用制限ロジック（未購入時は1日10回まで）
- 購入/復元ボタンを SettingsView に追加

**実装方針:**
```swift
// Purchase/PurchaseManager.swift
import StoreKit

class PurchaseManager: ObservableObject {
    static let shared = PurchaseManager()
    static let productID = "com.yuki.SimplePallet.yearly"

    @Published var hasPurchased: Bool = false
    @Published var products: [Product] = []

    func loadProducts() async { /* StoreKit2 */ }
    func purchase(_ product: Product) async { /* StoreKit2 */ }
    func restorePurchases() async { /* StoreKit2 */ }
}
```

### 3. 自動起動機能の完全実装
現在の `AppSettings.updateLoginItem()` はプレースホルダー実装です。
macOS 13+ では `SMAppService` を使用する必要があります。

**実装方針:**
```swift
import ServiceManagement

// macOS 13+
if #available(macOS 13.0, *) {
    try? SMAppService.mainApp.register()
    // or unregister()
}
```

### 4. アイコンデザイン
`Resources/Assets.xcassets/AppIcon.appiconset/` にアイコン画像を追加してください。

**必要なサイズ:**
- 16x16, 32x32, 128x128, 256x256, 512x512（各 @1x, @2x）

**デザインガイドライン:**
- メニューバーアイコン用なので、シンプルで視認性の高いデザイン
- モノクロ（テンプレート画像）推奨
- ウィンドウのスナップをイメージさせるアイコン

### 5. ユニットテスト
**実装すべきテスト:**

```swift
// SimplePalletTests/ScreenUtilTests.swift
class ScreenUtilTests: XCTestCase {
    func testFrameCalculation() {
        // 矩形計算のロジックをテスト
    }
}

// SimplePalletTests/AppSettingsTests.swift
class AppSettingsTests: XCTestCase {
    func testShortcutSaving() {
        // UserDefaults への保存/読み込みをテスト
    }
}
```

### 6. App Store 準備
- [ ] App Store Connect でアプリ登録
- [ ] スクリーンショット作成（最大化/左/右のデモ）
- [ ] アプリ説明文の作成（日本語・英語）
- [ ] プライバシーポリシーをWeb公開
- [ ] サポートURL の設定
- [ ] TestFlight でベータテスト

### 7. 最適化・改善
- [ ] パフォーマンス計測（レスポンスタイム < 150ms）
- [ ] メモリ使用量の確認（< 50MB）
- [ ] クラッシュレポートの設定（オプトイン）
- [ ] 競合するショートカットの検出機能強化

### 8. 多言語対応
- [ ] 英語ローカライゼーション
- [ ] Localizable.strings の作成

### 9. アクセシビリティ向上
- [ ] VoiceOver 対応
- [ ] キーボードナビゲーションの強化

## 既知の制限事項

1. **ショートカット録画機能**: 現在はモック実装（2秒後に「開発中」メッセージ）
2. **自動起動**: プレースホルダー実装（DEBUG ログのみ）
3. **課金機能**: 未実装（フェーズ2）
4. **アイコン**: デフォルトのSFシンボルを使用、カスタムアイコン未作成

## サポート & フィードバック

問題が発生した場合や機能要望がある場合は、GitHub Issues で報告してください。

---

**おめでとうございます！** 🎉

Simple palet の基本機能は実装完了です。
次は実際にビルドして動作確認し、必要に応じて調整を行ってください。

