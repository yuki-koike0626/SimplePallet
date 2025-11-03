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
            // メニューバーアイコン（SF Symbols を使用）
            button.image = NSImage(systemSymbolName: "rectangle.3.group", accessibilityDescription: "Simple palet")
            button.image?.isTemplate = true
        }

        setupMenu()
    }

    /**
     メニュー項目を構築
     */
    private func setupMenu() {
        let menu = NSMenu()

        // 終了
        let quitItem = NSMenuItem(title: "SimplePaletを終了", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem?.menu = menu
    }

    /**
     アプリを終了
     */
    @objc private func quit() {
        NSApplication.shared.terminate(nil)
    }
}

