import Cocoa
import SwiftUI

/**
 メニューバーの管理

 NSStatusBar にアイコンを表示し、メニュー項目を管理。
 設定画面、使い方、終了機能を提供。
 */
class MenuBarController {
    private var statusItem: NSStatusItem?
    private var settingsWindow: NSWindow?

    init() {
        setupMenuBar()
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
        let settingsItem = NSMenuItem(title: String(localized: "menu.settings", bundle: .main, comment: "Settings menu item"), action: #selector(showSettings), keyEquivalent: ",")
        settingsItem.target = self
        menu.addItem(settingsItem)

        // 使い方を見る
        let howToUseItem = NSMenuItem(title: String(localized: "menu.howToUse", bundle: .main, comment: "How to use menu item"), action: #selector(showHowToUse), keyEquivalent: "")
        howToUseItem.target = self
        menu.addItem(howToUseItem)

        menu.addItem(NSMenuItem.separator())

        // 終了
        let quitItem = NSMenuItem(title: String(localized: "menu.quit", bundle: .main, comment: "Quit menu item"), action: #selector(quit), keyEquivalent: "q")
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
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 600),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )

        window.contentViewController = hostingController
        window.title = String(localized: "window.settings", bundle: .main, comment: "Settings window title")
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
}

