import Foundation
import Combine

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
            updateLoginItem()
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
     ログイン時の自動起動設定を更新

     macOS 13以降ではSMAppServiceを使用する必要がある。
     */
    private func updateLoginItem() {
        // TODO: macOS 13+ では SMAppService.mainApp を使用
        #if DEBUG
        print("ログイン時起動: \(launchAtLogin)")
        #endif
    }
}

