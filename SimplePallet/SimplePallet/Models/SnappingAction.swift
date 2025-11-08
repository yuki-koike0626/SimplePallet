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

    /// 表示名（日本語）
    var displayName: String {
        switch self {
        case .maximize: return "最大化"
        case .left: return "左半分"
        case .right: return "右半分"
        case .leftThird: return "左1/3"
        case .centerThird: return "中央1/3"
        case .rightThird: return "右1/3"
        }
    }

    /// KeyboardShortcutsライブラリで使用するユニークな識別子
    var shortcutName: String {
        return "com.yuki.SimplePallet.\(rawValue)"
    }
}
