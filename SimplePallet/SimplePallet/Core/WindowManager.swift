import Cocoa
import ApplicationServices

/**
 ウィンドウ操作のエラー型
 */
enum WindowOperationError: Error, LocalizedError {
    case noFrontmostWindow
    case fullScreenWindow
    case permissionDenied
    case notResizable
    case unknown

    var errorDescription: String? {
        switch self {
        case .noFrontmostWindow:
            return "操作対象のウィンドウが見つかりません"
        case .fullScreenWindow:
            return "フルスクリーン中のウィンドウは操作できません"
        case .permissionDenied:
            return "アクセシビリティ権限が必要です"
        case .notResizable:
            return "このウィンドウは移動・リサイズできません"
        case .unknown:
            return "予期しないエラーが発生しました"
        }
    }
}

/**
 ウィンドウ操作を担当

 AX APIを使用して最前面のウィンドウを取得し、
 指定された矩形に移動・リサイズする。

 シンプルな設計: 常に指定されたサイズに変更（トグル機能なし）
 */
enum WindowManager {

    // MARK: - Public Methods

    /**
     最前面ウィンドウを最大化
     */
    static func maximizeWindow() -> Result<Void, WindowOperationError> {
        guard let window = getFrontmostWindow() else {
            return .failure(.noFrontmostWindow)
        }

        let screen = ScreenCalculator.targetScreen(for: window)
        let targetFrame = ScreenCalculator.frameForMaximize(on: screen)

        return moveWindow(window, to: targetFrame)
    }

    /**
     最前面ウィンドウを左半分に配置
     */
    static func moveToLeft() -> Result<Void, WindowOperationError> {
        guard let window = getFrontmostWindow() else {
            return .failure(.noFrontmostWindow)
        }

        let screen = ScreenCalculator.targetScreen(for: window)
        let targetFrame = ScreenCalculator.frameForLeft(on: screen)

        return moveWindow(window, to: targetFrame)
    }

    /**
     最前面ウィンドウを右半分に配置
     */
    static func moveToRight() -> Result<Void, WindowOperationError> {
        guard let window = getFrontmostWindow() else {
            return .failure(.noFrontmostWindow)
        }

        let screen = ScreenCalculator.targetScreen(for: window)
        let targetFrame = ScreenCalculator.frameForRight(on: screen)

        return moveWindow(window, to: targetFrame)
    }

    // MARK: - Private Helpers

    /**
     アクティブ中のウィンドウを取得

     最前面のアプリケーションのフォーカスウィンドウを返す。
     */
    private static func getFrontmostWindow() -> AXUIElement? {
        // アクティブなアプリケーションを取得
        guard let frontmost = NSWorkspace.shared.frontmostApplication else {
            return nil
        }

        // アクティブなアプリのAX要素を作成
        let appElement = AXUIElementCreateApplication(frontmost.processIdentifier)

        // フォーカスウィンドウを取得
        var focusedWindow: CFTypeRef?
        guard AXUIElementCopyAttributeValue(appElement, kAXFocusedWindowAttribute as CFString, &focusedWindow) == .success,
              let window = focusedWindow else {
            return nil
        }

        return (window as! AXUIElement)
    }

    /**
     ウィンドウを指定された矩形に移動・リサイズ
     */
    private static func moveWindow(_ window: AXUIElement, to frame: CGRect) -> Result<Void, WindowOperationError> {
        // フルスクリーンチェック
        if isFullScreen(window) {
            return .failure(.fullScreenWindow)
        }

        // 位置とサイズが設定可能か確認
        guard isSettable(window, attribute: kAXPositionAttribute),
              isSettable(window, attribute: kAXSizeAttribute) else {
            return .failure(.notResizable)
        }

        // 位置を設定
        var position = frame.origin
        if let positionValue = AXValueCreate(.cgPoint, &position) {
            let result = AXUIElementSetAttributeValue(window, kAXPositionAttribute as CFString, positionValue)
            if result != .success {
                return .failure(.permissionDenied)
            }
        }

        // サイズを設定
        var size = frame.size
        if let sizeValue = AXValueCreate(.cgSize, &size) {
            let result = AXUIElementSetAttributeValue(window, kAXSizeAttribute as CFString, sizeValue)
            if result != .success {
                return .failure(.permissionDenied)
            }
        }

        return .success(())
    }

    /**
     ウィンドウがフルスクリーンかどうか判定
     */
    private static func isFullScreen(_ window: AXUIElement) -> Bool {
        var fullScreenValue: CFTypeRef?
        guard AXUIElementCopyAttributeValue(window, "AXFullScreen" as CFString, &fullScreenValue) == .success,
              let value = fullScreenValue as? Bool else {
            return false
        }
        return value
    }

    /**
     指定された属性が設定可能かチェック
     */
    private static func isSettable(_ window: AXUIElement, attribute: String) -> Bool {
        var settable: DarwinBoolean = false
        AXUIElementIsAttributeSettable(window, attribute as CFString, &settable)
        return settable.boolValue
    }
}
