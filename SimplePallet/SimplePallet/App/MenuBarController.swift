import Cocoa
import SwiftUI
import Combine
import Sparkle

/**
 メニューバーの管理

 NSStatusBar にアイコンを表示し、メニュー項目を管理。
 設定画面、使い方、終了機能を提供。
 */
class MenuBarController {
    private var statusItem: NSStatusItem?
    private var settingsWindow: NSWindow?
    private var cancellables = Set<AnyCancellable>()

    // Sparkle Updater（AppDelegateから渡される）
    private weak var updaterController: SPUStandardUpdaterController?

    init(updaterController: SPUStandardUpdaterController? = nil) {
        self.updaterController = updaterController
        setupMenuBar()
        observeLanguageChanges()
    }

    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            // メニューバーアイコン（カスタムアイコンを使用）
            button.image = NSImage(named: "MenuBarIcon")
            button.image?.isTemplate = true // システムテーマに応じて色が変わる
        }

        setupMenu()
    }

    /**
     メニュー項目を構築
     */
    private func setupMenu() {
        let menu = NSMenu()

        // ウィンドウ操作セクション
        addWindowActionsSection(to: menu)

        menu.addItem(NSMenuItem.separator())

        // 設定
        let settingsItem = NSMenuItem(title: L("menu.settings"), action: #selector(showSettings), keyEquivalent: ",")
        settingsItem.target = self
        menu.addItem(settingsItem)

        // 使い方を見る
        let howToUseItem = NSMenuItem(title: L("menu.howToUse"), action: #selector(showHowToUse), keyEquivalent: "")
        howToUseItem.target = self
        menu.addItem(howToUseItem)

        // 友達に勧める
        let recommendItem = NSMenuItem(title: "友達に勧める", action: #selector(showRecommend), keyEquivalent: "")
        recommendItem.target = self
        menu.addItem(recommendItem)

        // 開発者
        let developerItem = NSMenuItem(title: L("menu.developerInfo"), action: #selector(showDeveloperInfo), keyEquivalent: "")
        developerItem.target = self
        menu.addItem(developerItem)

        menu.addItem(NSMenuItem.separator())

        // アップデートをチェック
        let updateItem = NSMenuItem(title: L("menu.checkForUpdates"), action: #selector(checkForUpdates), keyEquivalent: "")
        updateItem.target = self
        menu.addItem(updateItem)

        menu.addItem(NSMenuItem.separator())

        // 終了
        let quitItem = NSMenuItem(title: L("menu.quit"), action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem?.menu = menu
    }

    /**
     設定画面を表示
     */
    @objc private func showSettings() {
        // 既存のウィンドウがあれば前面に表示
        if let window = settingsWindow, window.isVisible {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        // 設定画面を作成
        let settingsView = SettingsView()
        let hostingController = NSHostingController(rootView: settingsView)

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 700),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )

        window.contentViewController = hostingController
        window.title = L("window.settings")
        window.center()
        window.isReleasedWhenClosed = false

        // ウィンドウを表示
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

        settingsWindow = window
    }

    /**
     使い方モーダルを表示
     */
    @objc private func showHowToUse() {
        HowToUseModalManager.shared.show()
    }

    /**
     友達に勧めるモーダルを表示
     */
    @objc private func showRecommend() {
        RecommendModalManager.shared.show()
    }

    /**
     開発者情報モーダルを表示
     */
    @objc private func showDeveloperInfo() {
        DeveloperInfoModalManager.shared.show()
    }

    /**
     アプリを終了
     */
    @objc private func quit() {
        NSApplication.shared.terminate(nil)
    }

    /**
     アップデートをチェック
     */
    @objc private func checkForUpdates() {
        // バックグラウンドアプリの場合、ダイアログを表示する前にアプリをアクティブにする
        NSApp.activate(ignoringOtherApps: true)

        guard let updaterController = updaterController else {
            return
        }

        updaterController.updater.checkForUpdates()
    }

    // MARK: - Window Actions

    /**
     ウィンドウ操作メニューセクションを追加

     最大化、左半分、右半分のメニュー項目を作成し、
     現在設定されているショートカットキーを表示する。
     */
    private func addWindowActionsSection(to menu: NSMenu) {
        // 最大化
        let maximizeItem = createWindowActionMenuItem(
            action: .maximize,
            selector: #selector(executeMaximize)
        )
        menu.addItem(maximizeItem)

        // 左半分
        let leftItem = createWindowActionMenuItem(
            action: .left,
            selector: #selector(executeLeft)
        )
        menu.addItem(leftItem)

        // 右半分
        let rightItem = createWindowActionMenuItem(
            action: .right,
            selector: #selector(executeRight)
        )
        menu.addItem(rightItem)
    }

    /**
     ウィンドウ操作用のメニュー項目を作成

     - Parameters:
       - action: SnappingAction
       - selector: 実行するセレクタ
     - Returns: 設定済みのNSMenuItem
     */
    private func createWindowActionMenuItem(
        action: SnappingAction,
        selector: Selector
    ) -> NSMenuItem {
        let item = NSMenuItem(
            title: action.displayName,
            action: selector,
            keyEquivalent: ""
        )
        item.target = self

        // アイコンを設定
        if let icon = NSImage(systemSymbolName: action.iconName, accessibilityDescription: action.displayName) {
            item.image = icon
        }

        return item
    }

    /**
     最大化を実行
     */
    @objc private func executeMaximize() {
        executeWindowAction(.maximize)
    }

    /**
     左半分に移動を実行
     */
    @objc private func executeLeft() {
        executeWindowAction(.left)
    }

    /**
     右半分に移動を実行
     */
    @objc private func executeRight() {
        executeWindowAction(.right)
    }

    /**
     ウィンドウ操作を実行する共通メソッド

     アクセシビリティ権限のチェックと、実際のウィンドウ操作を行う。
     エラー時にはトーストでユーザーに通知する。
     */
    private func executeWindowAction(_ action: SnappingAction) {
        // アクセシビリティ権限チェック
        guard AccessibilityPermission.isGranted() else {
            showAccessibilityPermissionError()
            return
        }

        // ショートカットが有効かチェック
        guard AppSettings.shared.isEnabled else {
            return
        }

        // ウィンドウ操作を実行
        let result: Result<Void, WindowOperationError>
        switch action {
        case .maximize:
            result = WindowManager.maximizeWindow()
        case .left:
            result = WindowManager.moveToLeft()
        case .right:
            result = WindowManager.moveToRight()
        case .leftThird:
            result = WindowManager.moveToLeftThird()
        case .centerThird:
            result = WindowManager.moveToCenterThird()
        case .rightThird:
            result = WindowManager.moveToRightThird()
        }

        // エラーハンドリング
        if case .failure(let error) = result {
            handleWindowOperationError(error)
        }
    }

    /**
     アクセシビリティ権限エラーを表示
     */
    private func showAccessibilityPermissionError() {
        ToastManager.shared.showToast(
            message: L("error.accessibility.notGranted"),
            type: .error
        )
    }

    /**
     ウィンドウ操作エラーをハンドリング
     */
    private func handleWindowOperationError(_ error: WindowOperationError) {
        let message: String
        switch error {
        case .noFrontmostWindow:
            message = L("error.window.noFrontmost")
        case .fullScreenWindow:
            message = L("error.window.fullScreen")
        case .permissionDenied:
            message = L("error.accessibility.notGranted")
        case .notResizable:
            message = L("error.window.notResizable")
        case .unknown:
            message = L("error.window.unknown")
        }

        ToastManager.shared.showToast(
            message: message,
            type: .error
        )
    }

    /**
     言語変更を監視してメニューを更新
     */
    private func observeLanguageChanges() {
        LanguageManager.shared.languageDidChange
            .sink { [weak self] _ in
                self?.setupMenu()
                self?.closeAndReopenSettingsIfNeeded()
            }
            .store(in: &cancellables)
    }

    /**
     設定ウィンドウが開いている場合は閉じて再度開く
     */
    private func closeAndReopenSettingsIfNeeded() {
        if let window = settingsWindow, window.isVisible {
            window.close()
            settingsWindow = nil
            // 少し待ってから再度開く
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.showSettings()
            }
        }
    }
}

