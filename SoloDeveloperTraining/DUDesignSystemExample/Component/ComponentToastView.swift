//
//  ComponentToastView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentToastView: View {

    @State private var message: String = "토스트 안내 메시지입니다."

    var body: some View {
        List {
            // MARK: - Preview
            Section {
                Toast(message: message)
                    .padding(.vertical, TokenSpacing.lg)
            }
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 0, leading: TokenSpacing.md, bottom: 0, trailing: TokenSpacing.md))

            // MARK: - 메시지
            Section("메시지") {
                HStack {
                    TextField("메시지 입력", text: $message)
                    if !message.isEmpty {
                        Button { message = "" } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(Color.gray400)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.beige200)
        .navigationTitle("Toast")
    }
}

#Preview {
    NavigationStack {
        ComponentToastView()
    }
}
