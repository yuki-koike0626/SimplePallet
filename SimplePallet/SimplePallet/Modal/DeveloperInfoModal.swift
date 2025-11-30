import SwiftUI
import AppKit
import Combine

/**
 開発者情報を表示するモーダル

 開発者のプロフィールと連絡先を表示。
 */
struct DeveloperInfoModalView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var refreshID = UUID()
    @State private var copiedFeedback: String?

    var body: some View {
        VStack(spacing: 24) {
            // ヘッダー
            VStack(spacing: 16) {
                HStack(spacing: 8) {
                    LText("developer.title")
                        .font(.title)
                        .fontWeight(.bold)

                    Text(":")
                        .font(.title)
                        .fontWeight(.bold)

                    LText("developer.name")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
            }
            .padding(.top, 8)

            Divider()

            // 説明文
            VStack(spacing: 12) {
                LText("developer.theme")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.center)

                LText("developer.description")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 20)
            }

            Divider()

            // 連絡先
            VStack(alignment: .leading, spacing: 16) {
                LText("developer.contact")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)

                // メール
                contactRow(
                    icon: "envelope.fill",
                    label: LText("developer.email"),
                    value: "xiaochiyouxi18@gmail.com",
                    color: .blue
                )

                // Instagram
                contactRow(
                    icon: "at",
                    label: LText("developer.instagram"),
                    value: "k_yuuki1023",
                    color: .purple
                )
            }
            .padding(.horizontal, 20)

            // コピーフィードバック
            if let feedback = copiedFeedback {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text(feedback)
                        .font(.caption)
                        .foregroundColor(.green)
                }
                .transition(.opacity)
            }

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
        .frame(width: 500)
        .fixedSize(horizontal: false, vertical: true)
        .id(refreshID)
        .onReceive(LanguageManager.shared.languageDidChange) { _ in
            // 言語変更時にビュー全体を再描画
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                refreshID = UUID()
            }
        }
    }

    // MARK: - Helper Views

    private func contactRow(icon: String, label: some View, value: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                label
                    .font(.caption)
                    .foregroundColor(.secondary)

                HStack(spacing: 8) {
                    Text(value)
                        .font(.body)
                        .foregroundColor(.primary)
                        .textSelection(.enabled)

                    Button(action: {
                        copyToClipboard(value)
                    }) {
                        Image(systemName: "doc.on.doc")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(.plain)
                    .help(L("developer.copyToClipboard"))
                }
            }

            Spacer()
        }
        .padding(12)
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }

    // MARK: - Actions

    private func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)

        // フィードバック表示
        withAnimation(.easeInOut(duration: 0.2)) {
            copiedFeedback = L("developer.copied")
        }

        // 1.5秒後にフィードバックを消す
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 0.2)) {
                copiedFeedback = nil
            }
        }
    }
}

/**
 開発者情報モーダルのマネージャー

 モーダルウィンドウを管理し、表示・非表示を制御。
 */
class DeveloperInfoModalManager {
    static let shared = DeveloperInfoModalManager()

    private var modalWindow: NSWindow?
    private var cancellables = Set<AnyCancellable>()

    private init() {
        observeLanguageChanges()
    }

    /**
     開発者情報モーダルを表示
     */
    func show() {
        // 既存のウィンドウがあれば閉じる
        modalWindow?.close()
        modalWindow = nil

        // SwiftUI ビューを作成
        let modalView = DeveloperInfoModalView()
        let hostingController = NSHostingController(rootView: modalView)

        // ウィンドウを作成
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 550),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

        window.contentViewController = hostingController
        window.title = L("window.developerInfo")
        window.center()
        window.level = .floating
        window.isReleasedWhenClosed = false
        window.titlebarAppearsTransparent = true

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

struct DeveloperInfoModalView_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperInfoModalView()
    }
}

