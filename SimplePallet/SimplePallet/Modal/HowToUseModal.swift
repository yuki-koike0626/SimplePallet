import SwiftUI
import AppKit
import Combine

/**
 使い方を表示するモーダル

 ショートカットキーの説明とアプリの推奨使用方法を表示。
 */
struct HowToUseModalView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var refreshID = UUID()

    var body: some View {
        VStack(spacing: 24) {
            // ヘッダー
            VStack(alignment: .leading, spacing: 12) {
                LText("howToUse.title")
                    .font(.title)
                    .fontWeight(.bold)

                LText("howToUse.description")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 8)

            Divider()

            HStack(alignment: .top, spacing: 16) {
                // 左側と中央: ショートカットキーセクション
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top, spacing: 16) {
                        // 左側: 2分割ショートカットキー
                        VStack(alignment: .leading, spacing: 12) {
                            sectionHeader(L("howToUse.shortcutKeys"))

                            shortcutRow(
                                icon: "rectangle.fill",
                                shortcut: "⌘ + ↑",
                                description: L("action.maximize")
                            )

                            shortcutRow(
                                icon: "rectangle.lefthalf.filled",
                                shortcut: "⌘ + ←",
                                description: L("action.left")
                            )

                            shortcutRow(
                                icon: "rectangle.righthalf.filled",
                                shortcut: "⌘ + →",
                                description: L("action.right")
                            )
                        }
                        .frame(maxWidth: .infinity)

                        // 中央: 3分割の場合
                        VStack(alignment: .leading, spacing: 12) {
                            sectionHeader(L("howToUse.thirdSplit"))

                            shortcutRow(
                                icon: "rectangle.leadingthird.inset.filled",
                                shortcut: "⌥ + ⌘ + ←",
                                description: L("action.leftThird")
                            )

                            shortcutRow(
                                icon: "rectangle.center.inset.filled",
                                shortcut: "⌥ + ⌘ + ↑",
                                description: L("action.centerThird")
                            )

                            shortcutRow(
                                icon: "rectangle.trailingthird.inset.filled",
                                shortcut: "⌥ + ⌘ + →",
                                description: L("action.rightThird")
                            )
                        }
                        .frame(maxWidth: .infinity)
                    }

                    Spacer()
                        .frame(height: 8)

                    // よくあるミスセクション
                    VStack(alignment: .leading, spacing: 12) {
                        sectionHeader(L("howToUse.commonMistakes"))
                        warningBox(text: L("howToUse.fullscreenWarning"))
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(minWidth: 600, maxWidth: .infinity)

                // 右側: アプリ間移動と推奨設定
                VStack(alignment: .leading, spacing: 12) {
                    sectionHeader(L("howToUse.appSwitching"))

                    VStack(spacing: 8) {
                        HStack(spacing: 12) {
                            Image(systemName: "rectangle.stack.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                                .frame(width: 32)

                            VStack(alignment: .leading, spacing: 4) {
                                LText("howToUse.cmdTab")
                                    .font(.system(.callout, design: .monospaced))
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.secondary.opacity(0.2))
                                    .cornerRadius(6)

                                LText("howToUse.cmdTabDesc")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()
                        }
                        .padding(10)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)

                        HStack(spacing: 12) {
                            Image(systemName: "minus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.orange)
                                .frame(width: 32)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("howToUse.minimizeDock", bundle: .main, comment: "Minimize dock shortcut")
                                    .font(.system(.callout, design: .monospaced))
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.secondary.opacity(0.2))
                                    .cornerRadius(6)

                                Text("howToUse.minimizeDockDesc", bundle: .main, comment: "Minimize dock description")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }

                            Spacer()
                        }
                        .padding(10)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(10)

                        HStack(spacing: 12) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                                .frame(width: 32)

                            VStack(alignment: .leading, spacing: 4) {
                                LText("howToUse.cmdTabOption")
                                    .font(.system(.callout, design: .monospaced))
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.secondary.opacity(0.2))
                                    .cornerRadius(6)

                                LText("howToUse.cmdTabOptionDesc")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }

                            Spacer()
                        }
                        .padding(10)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(10)
                    }

                    Spacer()
                        .frame(height: 8)

                    sectionHeader(L("howToUse.recommendationsTitle"))

                    recommendationRow(
                        icon: "desktopcomputer",
                        title: L("howToUse.recommendationsSingleDesktop"),
                        description: L("howToUse.recommendationsSingleDesktopDesc")
                    )

                    recommendationRow(
                        icon: "rectangle.3.group",
                        title: L("howToUse.appSwitching"),
                        description: L("howToUse.appSwitchingDesc")
                    )
                }
                .frame(maxWidth: 250)
            }
            .padding(.horizontal, 4)

            Divider()

            // フッター
            HStack {
                Spacer()

                Button(L("button.close")) {
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
                .controlSize(.large)
            }
        }
        .padding(24)
        .frame(width: 900)
        .id(refreshID)
        .onReceive(LanguageManager.shared.languageDidChange) { _ in
            // 言語変更時にビュー全体を再描画
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                refreshID = UUID()
            }
        }
    }

    // MARK: - Helper Views

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.primary)
    }

    private func warningBox(text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title3)
                .foregroundColor(.orange)
                .frame(width: 24, alignment: .top)
                .padding(.top, 2)

            Text(text)
                .font(.body)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(8)
    }

    private func shortcutRow(icon: String, shortcut: String, description: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.green)
                .frame(width: 35)

            VStack(alignment: .leading, spacing: 3) {
                Text(shortcut)
                    .font(.system(.callout, design: .monospaced))
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(6)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(12)
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
    }

    private func recommendationRow(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.orange)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)

                Text(description)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(10)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(10)
    }
}

/**
 使い方モーダルのマネージャー

 モーダルウィンドウを管理し、表示・非表示を制御。
 */
class HowToUseModalManager {
    static let shared = HowToUseModalManager()

    private var modalWindow: NSWindow?
    private var cancellables = Set<AnyCancellable>()

    private init() {
        observeLanguageChanges()
    }

    /**
     使い方モーダルを表示
     */
    func show() {
        // 既存のウィンドウがあれば閉じる
        modalWindow?.close()
        modalWindow = nil

        // SwiftUI ビューを作成
        let modalView = HowToUseModalView()
        let hostingController = NSHostingController(rootView: modalView)

        // ウィンドウを作成
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 900, height: 700),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

        window.contentViewController = hostingController
        window.title = L("window.howToUse")
        window.center()
        window.level = .floating
        window.isReleasedWhenClosed = false
        window.titlebarAppearsTransparent = true

        // コンテンツに合わせてウィンドウサイズを調整
        window.setContentSize(hostingController.view.fittingSize)

        // ウィンドウを表示
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

        modalWindow = window
    }

    /**
     言語変更を監視してモーダルを更新
     */
    private func observeLanguageChanges() {
        LanguageManager.shared.languageDidChange
            .sink { [weak self] _ in
                self?.closeAndReopenIfNeeded()
            }
            .store(in: &cancellables)
    }

    /**
     モーダルが開いている場合は閉じて再度開く
     */
    private func closeAndReopenIfNeeded() {
        if let window = modalWindow, window.isVisible {
            window.close()
            modalWindow = nil
            // 少し待ってから再度開く
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.show()
            }
        }
    }
}

// MARK: - プレビュー

struct HowToUseModalView_Previews: PreviewProvider {
    static var previews: some View {
        HowToUseModalView()
    }
}
