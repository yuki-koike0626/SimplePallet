import Foundation

/**
 ウィンドウスナップのアクション種別

 ウィンドウを配置する3つの基本アクションを定義。
 */
enum SnappingAction: String, CaseIterable, Codable {
    case maximize = "maximize"
    case left = "left"
    case right = "right"
    case leftThird = "leftThird"
    case centerThird = "centerThird"
    case rightThird = "rightThird"

    /// 表示名（ローカライズ対応）
    var displayName: String {
        switch self {
        case .maximize: return String(localized: "action.maximize", bundle: .main, comment: "Maximize action")
        case .left: return String(localized: "action.left", bundle: .main, comment: "Left half action")
        case .right: return String(localized: "action.right", bundle: .main, comment: "Right half action")
        case .leftThird: return String(localized: "action.leftThird", bundle: .main, comment: "Left third action")
        case .centerThird: return String(localized: "action.centerThird", bundle: .main, comment: "Center third action")
        case .rightThird: return String(localized: "action.rightThird", bundle: .main, comment: "Right third action")
        }
    }

    /// KeyboardShortcutsライブラリで使用するユニークな識別子
    var shortcutName: String {
        return "com.yuki.SimplePallet.\(rawValue)"
    }
}
