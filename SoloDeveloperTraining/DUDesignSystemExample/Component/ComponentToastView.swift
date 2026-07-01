//
//  ComponentToastView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentToastView: View {

    @State private var message: String = "토스트 안내 메시지입니다."

    var body: some View {
        VStack(spacing: 0) {
            List {
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

                Section("앵커") {
                    Button("기본 (탭바 상단)") {
                        ToastManager.shared.show(message)
                    }
                    .background(GeometryReader { geo in
                        Color.clear.onAppear {
                            ToastManager.defaultAnchorY = geo.frame(in: .global).minY
                        }
                    })
                    Button("중앙") {
                        ToastManager.shared.show(message, anchor: .center)
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
        .background(Color.beige200)
        .navigationTitle("Toast")
    }
}

#Preview {
    NavigationStack {
        ComponentToastView()
    }
}
