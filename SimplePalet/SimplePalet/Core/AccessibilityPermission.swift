import Cocoa
import ApplicationServices

/**
 アクセシビリティ権限の管理

 macOSのアクセシビリティ権限のチェックとシステム設定への誘導を担当。
 シンプルで必要最小限の実装。
 */
enum AccessibilityPermission {

    /**
     アクセシビリティ権限の状態をチェック

     - Returns: 権限が許可されている場合はtrue
     */
    static func isGranted() -> Bool {
        return AXIsProcessTrusted()
    }

    /**
     権限リクエストダイアログを表示

     初回実行時などにシステムダイアログを表示。
     macOS 10.9以降で利用可能。
     */
    static func requestPermission() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true] as CFDictionary
        _ = AXIsProcessTrustedWithOptions(options)
    }

    /**
     システム設定のアクセシビリティページを開く

     ユーザーが手動で権限を付与できるように誘導。
     */
    static func openSystemPreferences() {
        let url: URL

        if #available(macOS 13.0, *) {
            // macOS 13 Ventura以降
            url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
        } else {
            // macOS 12以前
            url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
        }

        NSWorkspace.shared.open(url)
    }
}
