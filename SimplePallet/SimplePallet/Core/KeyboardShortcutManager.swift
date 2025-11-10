import Foundation
import AppKit
import KeyboardShortcuts

/**
 グローバルキーボードショートカットの管理

 KeyboardShortcutsライブラリを使用してシステム全体で動作するショートカットを登録。
 シンプルで安定した実装を実現。
 */
class KeyboardShortcutManager {
    static let shared = KeyboardShortcutManager()

    private var isEnabled: Bool = true

    private init() {}

    /**
     全てのショートカットを登録
     */
    func registerShortcuts() {
        // 最大化
        KeyboardShortcuts.onKeyUp(for: .maximize) { [weak self] in
            self?.handleShortcut(.maximize)
        }

        // 左半分
        KeyboardShortcuts.onKeyUp(for: .left) { [weak self] in
            self?.handleShortcut(.left)
        }

        // 右半分
        KeyboardShortcuts.onKeyUp(for: .right) { [weak self] in
            self?.handleShortcut(.right)
        }

        // 左1/3
        KeyboardShortcuts.onKeyUp(for: .leftThird) { [weak self] in
            self?.handleShortcut(.leftThird)
        }

        // 中央1/3
        KeyboardShortcuts.onKeyUp(for: .centerThird) { [weak self] in
            self?.handleShortcut(.centerThird)
        }

        // 右1/3
        KeyboardShortcuts.onKeyUp(for: .rightThird) { [weak self] in
            self?.handleShortcut(.rightThird)
        }
    }

    /**
     ショートカットの有効/無効を切り替え
     */
    func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
    }

    /**
     ショートカットが押された時の処理
     */
    private func handleShortcut(_ action: SnappingAction) {
        guard isEnabled else {
            return
        }

        // アクセシビリティ権限チェック
        guard AccessibilityPermission.isGranted() else {
            return
        }

        // ウィンドウ操作を実行
        switch action {
        case .maximize:
            _ = WindowManager.maximizeWindow()
        case .left:
            _ = WindowManager.moveToLeft()
        case .right:
            _ = WindowManager.moveToRight()
        case .leftThird:
            _ = WindowManager.moveToLeftThird()
        case .centerThird:
            _ = WindowManager.moveToCenterThird()
        case .rightThird:
            _ = WindowManager.moveToRightThird()
        }
    }
}

// MARK: - KeyboardShortcuts Extension

extension KeyboardShortcuts.Name {
    static let maximize = Self("com.yuki.SimplePallet.maximize", default: .init(.upArrow, modifiers: [.command]))
    static let left = Self("com.yuki.SimplePallet.left", default: .init(.leftArrow, modifiers: [.command]))
    static let right = Self("com.yuki.SimplePallet.right", default: .init(.rightArrow, modifiers: [.command]))
    static let leftThird = Self("com.yuki.SimplePallet.leftThird", default: .init(.leftArrow, modifiers: [.option, .command]))
    static let centerThird = Self("com.yuki.SimplePallet.centerThird", default: .init(.upArrow, modifiers: [.option, .command]))
    static let rightThird = Self("com.yuki.SimplePallet.rightThird", default: .init(.rightArrow, modifiers: [.option, .command]))
}

// MARK: - ShortcutFormatter

/**
 ショートカットキー表示のフォーマット処理

 KeyboardShortcutsライブラリから取得したショートカット情報を、
 メニューバーで表示可能な文字列に変換する。
 単一責任の原則: ショートカットキーの表示文字列生成のみを担当。
 */
enum ShortcutFormatter {

    /**
     ショートカットキーの表示文字列を取得

     - Parameter name: KeyboardShortcuts.Name
     - Returns: 表示用の文字列（例: "⌘↑"）。未設定の場合は空文字列
     */
    static func displayString(for name: KeyboardShortcuts.Name) -> String {
        guard let shortcut = KeyboardShortcuts.getShortcut(for: name) else {
            return ""
        }

        return formatShortcut(shortcut)
    }

    /**
     ショートカット情報を表示文字列に変換

     - Parameter shortcut: KeyboardShortcuts.Shortcut
     - Returns: フォーマット済み文字列（例: "⌥⌘←"）
     */
    private static func formatShortcut(_ shortcut: KeyboardShortcuts.Shortcut) -> String {
        var result = ""

        // モディファイアキーの順序: Control → Option → Shift → Command
        if shortcut.modifiers.contains(.control) {
            result += "⌃"
        }
        if shortcut.modifiers.contains(.option) {
            result += "⌥"
        }
        if shortcut.modifiers.contains(.shift) {
            result += "⇧"
        }
        if shortcut.modifiers.contains(.command) {
            result += "⌘"
        }

        // キーの記号化
        result += keySymbol(for: shortcut.key)

        return result
    }

    /**
     キーコードを表示用の記号に変換

     - Parameter key: KeyboardShortcuts.Key
     - Returns: 表示用の記号（例: "↑"）
     */
    private static func keySymbol(for key: KeyboardShortcuts.Key?) -> String {
        guard let key = key else {
            return ""
        }

        // よく使われる矢印キー
        switch key {
        case .upArrow:
            return "↑"
        case .downArrow:
            return "↓"
        case .leftArrow:
            return "←"
        case .rightArrow:
            return "→"
        default:
            // その他のキーは空文字を返す（複雑なキーは表示しない）
            return ""
        }
    }
}
