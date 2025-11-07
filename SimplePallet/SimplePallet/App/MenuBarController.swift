import Cocoa

/**
 メニューバーの管理

 NSStatusBar にアイコンを表示し、メニュー項目を管理。
 シンプルに終了機能のみを提供。
 */
class MenuBarController {
    private var statusItem: NSStatusItem?

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

        // 使い方を見る
        let howToUseItem = NSMenuItem(title: "使い方を見る", action: #selector(showHowToUse), keyEquivalent: "")
        howToUseItem.target = self
        menu.addItem(howToUseItem)

        menu.addItem(NSMenuItem.separator())

        // 終了
        let quitItem = NSMenuItem(title: "SimplePalletを終了", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem?.menu = menu
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

