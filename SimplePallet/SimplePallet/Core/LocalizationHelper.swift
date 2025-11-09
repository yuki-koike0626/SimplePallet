import SwiftUI

/**
 ローカライゼーションヘルパー

 動的な言語切り替えをサポートするヘルパー関数とビュー。
 単一責任の原則: ローカライズされたテキストの取得と表示のみを担当。
 */

/// ローカライズされた文字列を取得（動的Bundle対応）
/// - Parameters:
///   - key: ローカライゼーションキー
///   - comment: コメント（オプション）
/// - Returns: ローカライズされた文字列
func L(_ key: String, comment: String = "") -> String {
    return LanguageManager.shared.localizedString(for: key, comment: comment)
}

/**
 動的にローカライズされるTextビュー

 LanguageManagerの言語変更を監視して自動的に更新される。
 使用例: LText("settings.title")
 */
struct LText: View {
    @ObservedObject private var languageManager = LanguageManager.shared
    let key: String
    let comment: String

    init(_ key: String, comment: String = "") {
        self.key = key
        self.comment = comment
    }

    var body: some View {
        Text(languageManager.localizedString(for: key, comment: comment))
    }
}

