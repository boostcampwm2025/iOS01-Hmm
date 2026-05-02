import SwiftUI

struct LoginView: View {
    @Binding var username: String
    @Environment(\.dismiss) private var dismiss
    @State private var inputName = ""

    var body: some View {
        ZStack {
            Color(.windowBackgroundColor).ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 32) {
                    // 로고
                    VStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 80, height: 80)
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 30, weight: .semibold))
                                .foregroundStyle(.blue)
                        }

                        VStack(spacing: 6) {
                            Text("DevUp Admin")
                                .font(.title.bold())
                            Text("수정 이력에 기록될 이름을 입력하세요.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    // 입력 카드
                    VStack(spacing: 14) {
                        TextField("이름 입력 (예: 홍길동)", text: $inputName)
                            .textFieldStyle(.plain)
                            .font(.body)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color(.controlBackgroundColor))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onSubmit { confirm() }

                        Button(action: confirm) {
                            Text("시작하기")
                                .font(.callout.bold())
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 11)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(inputName.trimmingCharacters(in: .whitespaces).isEmpty)
                        .keyboardShortcut(.defaultAction)
                    }
                    .padding(24)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.08), radius: 20, x: 0, y: 6)
                }
                .frame(width: 360)

                Spacer()
            }
        }
        .frame(width: 480, height: 420)
    }

    private func confirm() {
        let trimmed = inputName.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        username = trimmed
        dismiss()
    }
}
