//
//  ComponentToastView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentToastView: View {

    @State private var message: String = "토스트 안내 메시지입니다."
    @State private var showToast = false
    @State private var anchorY: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Controls
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

                Section {
                    Button("토스트 표시") {
                        showToast = true
                    }
                    .background(GeometryReader { geo in
                        Color.clear.onAppear {
                            anchorY = geo.frame(in: .global).minY
                        }
                    })
                }
            }
            .scrollContentBackground(.hidden)
        }
        .background(Color.beige200)
        .navigationTitle("Toast")
        .duToast(isShowing: $showToast, message: message, anchorY: anchorY)
    }
}

#Preview {
    NavigationStack {
        ComponentToastView()
    }
}
