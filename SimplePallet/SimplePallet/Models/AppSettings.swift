import Foundation
import Combine
import ServiceManagement

/**
 アプリ全体の設定を管理

 ショートカットの有効/無効状態と自動起動設定を管理。
 ショートカット自体の設定はKeyboardShortcutsライブラリが管理する。
 */
class AppSettings: ObservableObject {
    static let shared = AppSettings()

    /// ショートカットの有効/無効状態
    @Published var isEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isEnabled, forKey: Keys.isEnabled)
        }
    }

    /// ログイン時の自動起動
    @Published var launchAtLogin: Bool {
        didSet {
            UserDefaults.standard.set(launchAtLogin, forKey: Keys.launchAtLogin)
            do {
                try updateLoginItem()
            } catch {
                #if DEBUG
                print("⚠️ ログイン時起動の自動更新に失敗: \(error.localizedDescription)")
                #endif
            }
        }
    }

    private enum Keys {
        static let isEnabled = "SimplePallet.IsEnabled"
        static let launchAtLogin = "SimplePallet.LaunchAtLogin"
    }

    private init() {
        self.isEnabled = UserDefaults.standard.object(forKey: Keys.isEnabled) as? Bool ?? true
        self.launchAtLogin = UserDefaults.standard.bool(forKey: Keys.launchAtLogin)
    }

    /**
     設定を明示的に保存する

     UIから明示的に呼び出される際に使用。成功/失敗をthrowで返す。
     */
    func saveSettings() throws {
        UserDefaults.standard.set(isEnabled, forKey: Keys.isEnabled)
        UserDefaults.standard.set(launchAtLogin, forKey: Keys.launchAtLogin)
        try updateLoginItem()
    }

    /**
     ログイン時の自動起動設定を更新

     macOS 13以降ではSMAppServiceを使用する。
     */
    private func updateLoginItem() throws {
        if #available(macOS 13, *) {
            if launchAtLogin {
                // ログイン項目に登録
                try SMAppService.mainApp.register()
                #if DEBUG
                print("✅ ログイン時起動を有効化しました")
                #endif
            } else {
                // ログイン項目から削除
                try SMAppService.mainApp.unregister()
                #if DEBUG
                print("❌ ログイン時起動を無効化しました")
                #endif
            }
        } else {
            // macOS 12以下の場合は非対応
            #if DEBUG
            print("⚠️ ログイン時起動はmacOS 13以降でサポートされます")
            #endif
        }
    }
}

