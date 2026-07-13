//
//  ComponentIconButtonView.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 6/15/26.
//


//
//  ComponentIconButtonView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentIconButtonView: View {

    @State private var text: String = "텍스트"
    @State private var selectedSize: IconButton.IconButtonSize = .large

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Preview Area
            PreviewArea {
                IconButton(
                    text: text,
                    icon: .coinStack,
                    size: selectedSize,
                    action: {}
                )
                    .frame(maxWidth: .infinity)
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
                Section("크기") {
                    Picker("크기", selection: $selectedSize) {
                        Text("Large").tag(IconButton.IconButtonSize.large)
                        Text("Medium").tag(IconButton.IconButtonSize.medium)
                    }
                    .pickerStyle(.segmented)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .scrollContentBackground(.hidden)
        }
        .background(Color.beige200)
        .navigationTitle("IconButton")
        .navigationSubtitle("누르고 있으면 pressed 상태를 확인할 수 있어요")
    }
}

#Preview {
    NavigationStack {
        ComponentIconButtonView()
    }
}
