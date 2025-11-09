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
        if let savedLanguageRawValue = UserDefaults.standard.string(forKey: userDefaultsKey),
           let savedLanguage = AppLanguage(rawValue: savedLanguageRawValue) {
            self.currentLanguage = savedLanguage
        } else {
            // 初回起動時はシステムに従う
            self.currentLanguage = .system
        }

        // 初期Bundleを設定
        self.currentBundle = Bundle.main

        // 起動時に言語を適用
        applyLanguage(currentLanguage)
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

            // Bundleを動的に変更
            if let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
               let bundle = Bundle(path: path) {
                self.currentBundle = bundle
            } else {
                self.currentBundle = Bundle.main
            }
        } else {
            // システム言語に従う（AppleLanguagesをリセット）
            UserDefaults.standard.removeObject(forKey: "AppleLanguages")
            self.currentBundle = Bundle.main
        }

        UserDefaults.standard.synchronize()

        // Bundleの変更を通知
        objectWillChange.send()
    }

    /**
     現在有効な言語コードを取得

     - Returns: 言語コード（システム言語の場合はシステムの言語）
     */
    func getEffectiveLanguageCode() -> String {
        if let languageCode = currentLanguage.languageCode {
            return languageCode
        } else {
            return Locale.preferredLanguages.first ?? "ja"
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

