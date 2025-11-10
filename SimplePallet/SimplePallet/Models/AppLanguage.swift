import Foundation

/**
 アプリで利用可能な言語

 各言語のコードと表示名を定義。
 単一責任の原則: 言語の定義のみを担当。
 */
enum AppLanguage: String, CaseIterable, Codable {
    case system = "system"
    case japanese = "ja"
    case english = "en"
    case korean = "ko"
    case simplifiedChinese = "zh-Hans"
    case traditionalChinese = "zh-Hant"

    /// 言語コード（ローカライゼーションで使用）
    var languageCode: String? {
        switch self {
        case .system:
            return nil // システム言語に従う
        case .japanese:
            return "ja"
        case .english:
            return "en"
        case .korean:
            return "ko"
        case .simplifiedChinese:
            return "zh-Hans"
        case .traditionalChinese:
            return "zh-Hant"
        }
    }

    /// 表示名（各言語で表示）
    var displayName: String {
        switch self {
        case .system:
            return L("language.system")
        case .japanese:
            return "日本語"
        case .english:
            return "English"
        case .korean:
            return "한국어"
        case .simplifiedChinese:
            return "简体中文"
        case .traditionalChinese:
            return "繁體中文"
        }
    }

    /// システム言語から最適な言語を取得
    static func fromSystemLanguage() -> AppLanguage {
        guard let preferredLanguage = Locale.preferredLanguages.first else {
            return .japanese
        }

        if preferredLanguage.hasPrefix("ja") {
            return .japanese
        } else if preferredLanguage.hasPrefix("en") {
            return .english
        } else if preferredLanguage.hasPrefix("ko") {
            return .korean
        } else if preferredLanguage.hasPrefix("zh-Hans") || preferredLanguage.contains("CN") {
            return .simplifiedChinese
        } else if preferredLanguage.hasPrefix("zh-Hant") || preferredLanguage.contains("TW") || preferredLanguage.contains("HK") {
            return .traditionalChinese
        }

        return .japanese // デフォルト
    }
}

