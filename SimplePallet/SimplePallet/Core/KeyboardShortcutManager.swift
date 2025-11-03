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
        guard isEnabled else { return }

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
        }
    }
}

// MARK: - KeyboardShortcuts Extension

extension KeyboardShortcuts.Name {
    static let maximize = Self("com.yuki.SimplePallet.maximize", default: .init(.upArrow, modifiers: [.command]))
    static let left = Self("com.yuki.SimplePallet.left", default: .init(.leftArrow, modifiers: [.command]))
    static let right = Self("com.yuki.SimplePallet.right", default: .init(.rightArrow, modifiers: [.command]))
}
