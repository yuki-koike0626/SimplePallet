import SwiftUI
import AppKit
import Combine

/**
 友達に勧めるためのモーダル

 アプリの紹介文とリンクを表示し、クリップボードへのコピー機能を提供する。
 */
struct RecommendModalView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var hasCopied = false

    private let recommendURL = "https://yuki-koike0626.github.io/SimplePallet/"

    var body: some View {
        VStack(spacing: 24) {
            // ヘッダー
            VStack(alignment: .leading, spacing: 12) {
                Text("友達に勧める")
                    .font(.title)
                    .fontWeight(.bold)

                Text("SimplePalletを広めよう")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Divider()

            // メインコンテンツ
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("「画面分割を一生懸命カーソルで行っている。」")
                    Text("「そもそも画面分割のやり方が分かっていない。」")
                    Text("「このアプリをダウンロードすれば自分みたいにショートカットキーで快適に分割できるのに...」")
                }
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)

                Text("など思ったらぜひSimplePalletを紹介してください！")
                    .font(.body)
                    .fontWeight(.medium)
                    .padding(.top, 4)
            }
            .padding(.vertical, 8)

            // リンクコピーセクション
            VStack(spacing: 12) {
                HStack {
                    Text(recommendURL)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color(NSColor.separatorColor), lineWidth: 1)
                        )

                    Button(action: copyToClipboard) {
                        Image(systemName: hasCopied ? "checkmark" : "doc.on.doc")
                            .frame(width: 20)
                    }
                    .buttonStyle(.borderedProminent)
                    .help("リンクをコピー")
                }

                if hasCopied {
                    Text("リンクをコピーしました！")
                        .font(.caption)
                        .foregroundColor(.green)
                        .transition(.opacity)
                }
            }

            Spacer()

            // 閉じるボタン
            HStack {
                Spacer()
                Button("閉じる") {
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(24)
        .frame(width: 500) // 高さは自動調整
        .fixedSize(horizontal: false, vertical: true) // 縦方向のサイズをコンテンツに合わせる
    }

    private func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(recommendURL, forType: .string)

        withAnimation {
            hasCopied = true
        }

        // 3秒後にリセット
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                hasCopied = false
            }
        }
    }
}

/**
 友達に勧めるモーダルの管理クラス
 */
class RecommendModalManager {
    static let shared = RecommendModalManager()

    private var modalWindow: NSWindow?
    private var cancellables = Set<AnyCancellable>()

    private init() {
        // 言語変更の監視が必要な場合はここに追加
    }

    /**
     モーダルを表示
     */
    func show() {
        // 既存のウィンドウがあれば閉じる
        modalWindow?.close()
        modalWindow = nil

        // SwiftUI ビューを作成
        let modalView = RecommendModalView()
        let hostingController = NSHostingController(rootView: modalView)

        // ウィンドウを作成
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 400),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

        window.contentViewController = hostingController
        window.title = "友達に勧める"
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
}

