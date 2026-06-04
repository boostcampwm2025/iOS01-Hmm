//
//  ComponentEffectLabelView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentEffectLabelView: View {

    @State private var text: String = "100"
    @State private var selectedType: EffectLabel.EffectLabelType = .plus
    @State private var opacity: Double = 1.0

    var body: some View {
        List {
            // MARK: - Preview
            Section {
                EffectLabel(type: selectedType, text: text)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, TokenSpacing.lg)
                    .opacity(opacity)
            }
            .listRowBackground(Color.clear)

            // MARK: - 텍스트
            Section("텍스트") {
                HStack {
                    TextField("텍스트 입력", text: $text)
                    if !text.isEmpty {
                        Button { text = "" } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(Color.gray400)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            // MARK: - 타입
            Section("타입") {
                Picker("타입", selection: $selectedType) {
                    Text("Plus").tag(EffectLabel.EffectLabelType.plus)
                    Text("Minus").tag(EffectLabel.EffectLabelType.minus)
                }
                .pickerStyle(.segmented)
            }
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

            // MARK: - Opacity
            Section("Opacity  \(String(format: "%.2f", opacity))") {
                Slider(value: $opacity, in: 0...1)
                    .tint(Color.orange300)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.beige200)
        .navigationTitle("EffectLabel")
        .navigationSubtitle("코인 획득/차감 효과 레이블")
    }
}

#Preview {
    NavigationStack {
        ComponentEffectLabelView()
    }
}
