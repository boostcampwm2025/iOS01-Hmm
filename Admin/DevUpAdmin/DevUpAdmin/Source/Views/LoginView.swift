import SwiftUI

struct LoginView: View {
    @Binding var username: String
    @Environment(\.dismiss) private var dismiss
    @State private var inputName = ""

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "person.badge.key.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color.accentColor)

            VStack(spacing: 8) {
                Text("DevUp 어드민")
                    .font(.title.bold())
                Text("수정 이력에 기록될 이름을 입력하세요.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            TextField("이름 (예: 홍길동)", text: $inputName)
                .textFieldStyle(.roundedBorder)
                .frame(width: 280)
                .onSubmit { confirm() }

            Button(action: confirm) {
                Text("시작하기")
                    .frame(width: 280)
            }
            .buttonStyle(.borderedProminent)
            .disabled(inputName.trimmingCharacters(in: .whitespaces).isEmpty)
            .keyboardShortcut(.defaultAction)
        }
        .padding(40)
        .frame(width: 400, height: 320)
    }

    private func confirm() {
        let trimmed = inputName.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        username = trimmed
        dismiss()
    }
}
