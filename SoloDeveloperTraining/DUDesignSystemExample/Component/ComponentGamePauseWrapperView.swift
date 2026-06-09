//
//  ComponentGamePauseWrapperView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentGamePauseWrapperView: View {

    @State private var isPaused: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            PreviewArea {
                VStack(spacing: TokenSpacing.md) {
                    Text("게임 화면")
                        .duFont(.headline)
                        .foregroundStyle(Color.gray400)

                    TextButton(text: "일시정지", type: .primary, size: .medium) {
                        isPaused = true
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .gamePauseWrapper(
                pauseBinding: $isPaused,
                onLeave: { isPaused = false },
                onResume: { isPaused = false }
            )

            List {
                Section {
                    Text("상태 변경이나 유효성 검사는 비즈니스 로직이므로 예시 앱에는 반영되지 않아요.")
                        .font(.caption)
                        .foregroundStyle(Color.gray400)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .background(Color.beige200)
        .navigationTitle("GamePauseWrapper")
    }
}

#Preview {
    NavigationStack {
        ComponentGamePauseWrapperView()
    }
}
