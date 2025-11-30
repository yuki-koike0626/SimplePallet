# SimplePallet 開発ガイド

このドキュメントは、SimplePallet の開発、ビルド、リリースプロセスに関する技術的な詳細をまとめています。

## プロジェクト構成

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
├── SETUP_INSTRUCTIONS.md                  # 初回セットアップ詳細
├── RELEASE.md                             # リリース手順詳細
└── scripts/
    └── create-dmg.sh                      # DMG作成スクリプト
```

## セットアップ

### 必須要件
- Xcode 14.0以上
- macOS 13.0以上 (開発用)

### クイックスタート
1. リポジトリをクローン
2. `SimplePallet.xcodeproj` を開く
3. Swift Package Dependencies の読み込みを待つ
   - [KeyboardShortcuts](https://github.com/sindresorhus/KeyboardShortcuts)
   - [Sparkle](https://github.com/sparkle-project/Sparkle)
4. ターゲットを選択してビルド (Cmd + B)

## アーキテクチャ

本アプリは **MVVM** パターンを採用していますが、SwiftUI の標準的なデータフローを重視しています。
また、macOS のアクセシビリティAPIを使用するため、`Core/` ディレクトリにロジックを集約しています。

- **MenuBarController**: `NSStatusItem` を管理し、アプリのライフサイクルとメニューバーのインタラクションを制御します。
- **WindowManager**: `AXUIElement` を使用した低レイヤーのウィンドウ操作をラップしています。

## リリースプロセス

1. バージョン番号の更新
2. アーカイブの作成
3. 公証 (Notarization)
4. DMGの作成と署名
5. Sparkle用の署名生成
6. `appcast.xml` の更新

詳細な手順は `RELEASE.md` を参照してください。

## トラブルシューティング（開発時）

### アクセシビリティ権限のリセット
開発中に権限がおかしくなった場合は、以下のコマンドでリセットできます：
```bash
tccutil reset Accessibility com.yuki.SimplePallet
```

