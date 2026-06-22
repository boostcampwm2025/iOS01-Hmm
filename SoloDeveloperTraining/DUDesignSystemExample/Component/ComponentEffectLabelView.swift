//
//  ComponentEffectLabelView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentEffectLabelView: View {

    @State private var text: String = "100"
    @State private var selectedType: EffectLabel.EffectLabelType = .plus
    @State private var id = UUID()

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Preview Area
            PreviewArea {
                EffectLabel(type: selectedType, text: text)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .id(id)
            }

            // MARK: - Controls
            List {
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

                Section("타입") {
                    Picker("타입", selection: $selectedType) {
                        Text("Plus").tag(EffectLabel.EffectLabelType.plus)
                        Text("Minus").tag(EffectLabel.EffectLabelType.minus)
                    }
                    .pickerStyle(.segmented)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

                Section {
                    Button("다시 보기") {
                        id = UUID()
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
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
