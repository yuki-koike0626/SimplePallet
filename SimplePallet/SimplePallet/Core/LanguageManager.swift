import Foundation
import Combine

/**
 言語管理マネージャー

 アプリの言語設定を管理し、言語切り替えを制御する。
 単一責任の原則: 言語の管理と切り替えのみを担当。
 */
class LanguageManager: ObservableObject {
    static let shared = LanguageManager()

    /// 現在選択されている言語
    @Published private(set) var currentLanguage: AppLanguage

    /// 現在のBundle（動的に変更可能）
    @Published private(set) var currentBundle: Bundle

    /// 言語変更通知
    let languageDidChange = PassthroughSubject<AppLanguage, Never>()

    private let userDefaultsKey = "SimplePallet.AppLanguage"

    private init() {
        // 保存されている言語設定を読み込む
        let language: AppLanguage
        if let savedLanguageRawValue = UserDefaults.standard.string(forKey: userDefaultsKey),
           let savedLanguage = AppLanguage(rawValue: savedLanguageRawValue) {
            language = savedLanguage
        } else {
            // 初回起動時はシステムに従う
            language = .system
        }

        // プロパティを初期化
        self.currentLanguage = language
        self.currentBundle = Self.resolveBundle(for: language)

        // 起動時に言語を適用
        applyLanguage(language)
    }

    /**
     言語を変更する

     - Parameter language: 新しい言語
     */
    func changeLanguage(_ language: AppLanguage) {
        guard language != currentLanguage else { return }

        currentLanguage = language

        // UserDefaultsに保存
        UserDefaults.standard.set(language.rawValue, forKey: userDefaultsKey)

        // 言語を適用
        applyLanguage(language)

        // 変更通知を発行
        languageDidChange.send(language)

        #if DEBUG
        print("🌐 言語を変更しました: \(language.displayName)")
        #endif
    }

    /**
     言語を適用する

     - Parameter language: 適用する言語
     */
    private func applyLanguage(_ language: AppLanguage) {
        if let languageCode = language.languageCode {
            // 特定の言語コードを設定
            UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        } else {
            // システム言語に従う（AppleLanguagesをリセット）
            UserDefaults.standard.removeObject(forKey: "AppleLanguages")
        }

        UserDefaults.standard.synchronize()

        // Bundleを動的に変更
        self.currentBundle = Self.resolveBundle(for: language)

        // Bundleの変更を通知
        objectWillChange.send()
    }

    /**
     指定された言語に対応するBundleを解決する

     システム言語の場合は、システムの優先言語から適切なBundleを選択する。
     単一責任: Bundleの解決ロジックのみを担当。

     - Parameter language: 対象の言語
     - Returns: 解決されたBundle
     */
    private static func resolveBundle(for language: AppLanguage) -> Bundle {
        // システム言語の場合は、システムの優先言語から判定
        let effectiveLanguageCode: String?
        if language == .system {
            // システムの優先言語からアプリがサポートしている言語を取得
            effectiveLanguageCode = AppLanguage.fromSystemLanguage().languageCode
        } else {
            effectiveLanguageCode = language.languageCode
        }

        // 言語コードに対応するBundleを取得
        if let languageCode = effectiveLanguageCode,
           let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return bundle
        }

        // フォールバック: メインBundle
        return Bundle.main
    }

    /**
     現在有効な言語コードを取得

     - Returns: 言語コード（システム言語の場合はシステムの言語）
     */
    func getEffectiveLanguageCode() -> String {
        if currentLanguage == .system {
            // システム言語の場合は、実際のシステム言語コードを返す
            return AppLanguage.fromSystemLanguage().languageCode ?? "ja"
        } else if let languageCode = currentLanguage.languageCode {
            return languageCode
        } else {
            return "ja"
        }
    }

    /**
     ローカライズされた文字列を取得

     - Parameters:
       - key: ローカライゼーションキー
       - comment: コメント（オプション）
     - Returns: ローカライズされた文字列
     */
    func localizedString(for key: String, comment: String = "") -> String {
        return currentBundle.localizedString(forKey: key, value: nil, table: nil)
    }
}

