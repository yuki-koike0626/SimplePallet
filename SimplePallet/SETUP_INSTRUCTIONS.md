# Simple palet セットアップ手順

リファクタリング後の新しい実装では、KeyboardShortcutsライブラリを使用します。
以下の手順に従ってセットアップを完了してください。

## ✅ 完了した作業

以下の作業は既に完了しています：

- ✅ 新しいファイルの作成（AccessibilityPermission.swift, WindowManager.swift, etc.）
- ✅ 古いファイルの削除（HotKeyManager.swift, AXPermission.swift, etc.）
- ✅ 既存ファイルの更新（SimplePalletApp.swift, SettingsView.swift, etc.）

## 🔧 残りのセットアップ手順

### 1. KeyboardShortcutsライブラリの追加

1. Xcodeで `SimplePallet.xcodeproj` を開く
2. プロジェクトナビゲーターでプロジェクトファイルを選択
3. 「Package Dependencies」タブを選択
4. 「+」ボタンをクリック
5. 以下のURLを入力（**`.git`拡張子を忘れずに！**）:
   ```
   https://github.com/sindresorhus/KeyboardShortcuts.git
   ```
6. 「Up to Next Major Version」を選択し、バージョンは最新を使用（2.0.0以上）
7. 「Add Package」をクリック
8. ターゲット「SimplePallet」に `KeyboardShortcuts` を追加
9. パッケージの解決とダウンロードが完了するまで待つ

### 2. 新しいファイルをXcodeプロジェクトに追加

新しいファイルは既にファイルシステムに存在していますが、Xcodeプロジェクトに追加する必要があります。

#### Modelsフォルダのファイルを追加:
1. Xcodeのプロジェクトナビゲーターで「Models」フォルダを右クリック
2. 「Add Files to "SimplePallet"...」を選択
3. `/Users/koikeyuuki/Simple-palet/SimplePallet/SimplePallet/Models/SnappingAction.swift` を選択
4. 「Copy items if needed」のチェックを**外す**
5. 「Add to targets:」で「SimplePallet」にチェック
6. 「Add」をクリック

#### Coreフォルダのファイルを追加:
1. Xcodeのプロジェクトナビゲーターで「Core」フォルダを右クリック
2. 「Add Files to "SimplePallet"...」を選択
3. 以下のファイルを**全て**選択（Commandキーを押しながら複数選択）:
   - `AccessibilityPermission.swift`
   - `ScreenCalculator.swift`
   - `WindowManager.swift`
   - `KeyboardShortcutManager.swift`
4. 「Copy items if needed」のチェックを**外す**
5. 「Add to targets:」で「SimplePallet」にチェック
6. 「Add」をクリック

### 3. Xcodeプロジェクトから古いファイルの参照を削除

プロジェクトナビゲーターで以下のファイルが赤く表示されている場合（既に削除済み）、参照を削除してください：

1. 赤いファイル名を右クリック
2. 「Delete」を選択
3. 「Remove Reference」を選択（Move to Trashは不要）

対象ファイル:
- `Core/HotKeyManager.swift`
- `Core/AXPermission.swift`
- `Core/WindowMover.swift`
- `Core/ScreenUtil.swift`

### 4. ビルドとテスト

1. プロジェクトをクリーンビルド（⌘⇧K）
2. ビルド（⌘B）
3. エラーがないことを確認
4. 実行（⌘R）
5. アクセシビリティ権限を許可
6. デフォルトのショートカット（⌘+↑/←/→）をテスト

## リファクタリングの主な変更点

### 削減されたコード行数
- `HotKeyManager.swift`: 362行 → `KeyboardShortcutManager.swift`: 約90行
- `WindowMover.swift`: 730行 → `WindowManager.swift`: 約300行
- `AXPermission.swift`: 115行 → `AccessibilityPermission.swift`: 約50行
- `ScreenUtil.swift`: 122行 → `ScreenCalculator.swift`: 約115行
- `AppSettings.swift`: 172行 → 約50行

### アーキテクチャの改善
1. **CGEventTap → KeyboardShortcuts**: 複雑な独自実装を信頼性の高いライブラリに置き換え
2. **責務の分離**: 各クラスが単一の責務を持つように再設計
3. **コードの簡略化**: デバッグログ、複雑なエラーハンドリング、監視タイマーなどを削除
4. **保守性の向上**: シンプルで読みやすいコード

### 新しいファイル構造
```
SimplePallet/
├── App/
│   ├── SimplePalletApp.swift
│   ├── MenuBarController.swift
│   ├── SettingsView.swift
│   └── ToastView.swift
├── Core/
│   ├── KeyboardShortcutManager.swift  # グローバルショートカット管理
│   ├── WindowManager.swift            # ウィンドウ操作
│   ├── ScreenCalculator.swift         # 画面計算
│   └── AccessibilityPermission.swift  # 権限管理
└── Models/
    ├── SnappingAction.swift           # アクション定義
    └── AppSettings.swift              # 設定管理
```

## トラブルシューティング

### ビルドエラーが発生する場合
1. DerivedDataをクリーン: `⌘⇧K`
2. Xcodeを再起動
3. Package Dependenciesを更新: File > Packages > Update to Latest Package Versions

### ショートカットが動作しない場合
1. アクセシビリティ権限を確認
2. メニューバーから設定を開き、ショートカットが正しく登録されているか確認
3. システム環境設定で他のアプリと競合していないか確認
