import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: PolicyEditorViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("버전 이력")
                    .font(.headline)
                Spacer()
                Button("닫기") { dismiss() }
                    .buttonStyle(.plain)
            }
            .padding()
            .background(Color(NSColor.windowBackgroundColor))

            Divider()

            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.versionHistory.isEmpty {
                Text("저장된 버전이 없습니다.")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(viewModel.versionHistory) { meta in
                    HistoryRowView(meta: meta) {
                        Task {
                            await viewModel.loadVersion(meta.version)
                            dismiss()
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .frame(width: 320, height: 480)
    }
}

private struct HistoryRowView: View {
    let meta: PolicyVersionMeta
    let onLoad: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(meta.versionLabel)
                    .font(.headline)
                HStack(spacing: 8) {
                    Label(meta.modifiedBy, systemImage: "person.fill")
                    Label(meta.modifiedAtFormatted, systemImage: "clock")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            Spacer()
            Button("불러오기") { onLoad() }
                .buttonStyle(.borderless)
                .foregroundStyle(Color.accentColor)
        }
        .padding(.vertical, 4)
    }
}
