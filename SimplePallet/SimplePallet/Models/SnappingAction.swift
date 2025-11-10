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
        case .maximize: return L("action.maximize")
        case .left: return L("action.left")
        case .right: return L("action.right")
        case .leftThird: return L("action.leftThird")
        case .centerThird: return L("action.centerThird")
        case .rightThird: return L("action.rightThird")
        }
    }

    /// メニューバー表示用のSF Symbolsアイコン名
    var iconName: String {
        switch self {
        case .maximize:
            return "rectangle.fill"
        case .left:
            return "rectangle.lefthalf.filled"
        case .right:
            return "rectangle.righthalf.filled"
        case .leftThird:
            return "rectangle.leftthird.inset.filled"
        case .centerThird:
            return "rectangle.center.inset.filled"
        case .rightThird:
            return "rectangle.rightthird.inset.filled"
        }
    }

    /// KeyboardShortcutsライブラリで使用するユニークな識別子
    var shortcutName: String {
        return "com.yuki.SimplePallet.\(rawValue)"
    }
}
