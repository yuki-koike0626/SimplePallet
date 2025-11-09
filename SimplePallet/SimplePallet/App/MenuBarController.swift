import Cocoa
import SwiftUI
import Combine

/**
 メニューバーの管理

 NSStatusBar にアイコンを表示し、メニュー項目を管理。
 設定画面、使い方、終了機能を提供。
 */
class MenuBarController {
    private var statusItem: NSStatusItem?
    private var settingsWindow: NSWindow?
    private var cancellables = Set<AnyCancellable>()

    init() {
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

        // 設定
        let settingsItem = NSMenuItem(title: L("menu.settings"), action: #selector(showSettings), keyEquivalent: ",")
        settingsItem.target = self
        menu.addItem(settingsItem)

        // 使い方を見る
        let howToUseItem = NSMenuItem(title: L("menu.howToUse"), action: #selector(showHowToUse), keyEquivalent: "")
        howToUseItem.target = self
        menu.addItem(howToUseItem)

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
     アプリを終了
     */
    @objc private func quit() {
        NSApplication.shared.terminate(nil)
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

