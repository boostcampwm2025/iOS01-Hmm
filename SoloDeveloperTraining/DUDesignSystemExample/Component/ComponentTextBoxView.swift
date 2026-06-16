//
//  ComponentTextBoxView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentTextBoxView: View {

    @State private var text: String = "당근마켓에서 15만원짜리 중고 노트북을 샀다. 팬 소리가 비행기 이륙 수준이지만 괜찮다."

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Preview Area
            PreviewArea {
                TextBox(text: text)
                    .padding(.horizontal, TokenSpacing.lg)
            }

            // MARK: - Controls
            List {
                Section("내용") {
                    HStack {
                        TextField("내용 입력", text: $text)
                        if !text.isEmpty {
                            Button { text = "" } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(Color.gray400)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
        .background(Color.beige200)
        .navigationTitle("TextBox")
    }
}

#Preview {
    NavigationStack {
        ComponentTextBoxView()
    }
}
