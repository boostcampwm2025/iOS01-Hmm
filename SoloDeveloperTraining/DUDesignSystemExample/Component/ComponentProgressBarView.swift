//
//  ComponentProgressBarView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentProgressBarView: View {

    @State private var progress: Double = 0.6

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Preview Area
            PreviewArea {
                ProgressBar(progress: progress)
            }

            // MARK: - Controls
            List {
                Section("진행도") {
                    Slider(value: $progress, in: 0...1)
                    Text("\(Int(progress * 100))%")
                        .foregroundStyle(Color.gray400)
                }

                Section {
                    Text("상태 변경이나 유효성 검사는 비즈니스 로직이므로 예시 앱에는 반영되지 않아요.")
                        .font(.caption)
                        .foregroundStyle(Color.gray400)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .background(Color.beige200)
        .navigationTitle("ProgressBar")
    }
}

#Preview {
    NavigationStack {
        ComponentProgressBarView()
    }
}
