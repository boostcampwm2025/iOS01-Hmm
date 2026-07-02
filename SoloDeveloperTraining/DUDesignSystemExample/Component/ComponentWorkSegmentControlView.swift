//
//  ComponentWorkSegmentControlView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentWorkSegmentControlView: View {

    @State private var selectedIndex: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Preview Area
            PreviewArea {
                WorkSegmentControl(
                    items: [
                        .init(title: "언어 맞추기", imageName: "workLanguage"),
                        .init(title: "스택 맞추기", imageName: "workStack"),
                        .init(title: "탭 하기", imageName: "workTap"),
                        .init(title: "피하기", imageName: "workDodge", isLocked: true)
                    ],
                    selectedIndex: $selectedIndex
                )
            }

            // MARK: - Controls
            List {
                Section("선택된 인덱스") {
                    Text("selectedIndex: \(selectedIndex)")
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
        .navigationTitle("WorkSegmentControl")
    }
}

#Preview {
    NavigationStack {
        ComponentWorkSegmentControlView()
    }
}
