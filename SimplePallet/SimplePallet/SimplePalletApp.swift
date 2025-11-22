import SwiftUI
import AppKit
import Sparkle

/**
 SimplePallet のメインエントリーポイント

 メニューバー常駐アプリとして動作し、Dockには表示しない。
 グローバルキーボードショートカットで最前面ウィンドウをスナップする機能を提供。
 */
@main
struct SimplePalletApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var languageManager = LanguageManager.shared

    var body: some Scene {
        Settings {
            EmptyView()
        }
        .environment(\.locale, Locale(identifier: languageManager.getEffectiveLanguageCode()))
    }
}

/**
 アプリケーションのライフサイクルを管理
 */
class AppDelegate: NSObject, NSApplicationDelegate {
    var menuBarController: MenuBarController?
    var shortcutManager: KeyboardShortcutManager?

    // Sparkle自動アップデート（MenuBarControllerからアクセスするため internal）
    let updaterController: SPUStandardUpdaterController

    override init() {
        // Sparkleの初期化
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
        super.init()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Dockアイコンを非表示に設定
        NSApp.setActivationPolicy(.accessory)

        // 各コンポーネントの初期化
        setupComponents()
    }

    private func setupComponents() {
        // アクセシビリティ権限チェック
        let hasPermission = AccessibilityPermission.isGranted()

        if !hasPermission {
            // 権限がない場合はリクエスト
            AccessibilityPermission.requestPermission()
        }

        // メニューバーコントローラーの初期化
        menuBarController = MenuBarController()

        // キーボードショートカットマネージャーの初期化
        shortcutManager = KeyboardShortcutManager.shared
        shortcutManager?.registerShortcuts()
    }
}

