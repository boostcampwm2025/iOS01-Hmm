//
//  DefaultSegmentControl.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/13/26.
//

import SwiftUI

private enum Constant {
    static let segmentSpacing: CGFloat = 0
    static let segmentHeight: CGFloat = 40
    static let segmentPadding: CGFloat = 4
    static let lineWidth: CGFloat = 2

    enum Color {
        static let selectedBackground = AppColors.orange500
        static let unselectedBackground = AppColors.gray100
        static let selectedText = SwiftUI.Color.white
        static let unselectedText = AppColors.gray500
        static let border = SwiftUI.Color.black
    }
}

struct DefaultSegmentControl: View {
    /// 선택된 세그먼트 인덱스
    @Binding var selection: Int

    let segments: [String]

    var body: some View {
        HStack(spacing: Constant.segmentSpacing) {
            ForEach(0..<segments.count, id: \.self) { index in
                SegmentButton(
                    title: segments[index],
                    isSelected: index == selection,
                    action: { selection = index }
                )
            }
        }
        .padding(Constant.segmentPadding)
        .background(
            Rectangle()
                .fill(Constant.Color.unselectedBackground)
                .shadow(color: .black, radius: 0, x: 2, y: 3)
        )
        .overlay {
            Rectangle()
                .stroke(Constant.Color.border, lineWidth: Constant.lineWidth)
                .animation(.none, value: selection)
        }
    }
}

// MARK: - SubView
private struct SegmentButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .textStyle(.subheadline)
                .foregroundStyle(textColor)
                .frame(maxWidth: .infinity)
                .frame(height: Constant.segmentHeight)
                .background(backgroundColor)
                .animation(.none, value: isSelected)
        }
        .buttonStyle(.plain)
    }

    var backgroundColor: SwiftUI.Color {
        isSelected ? Constant.Color.selectedBackground : Constant.Color.unselectedBackground
    }

    var textColor: SwiftUI.Color {
        isSelected ? Constant.Color.selectedText : Constant.Color.unselectedText
    }
}

#Preview {
    @Previewable @State var selection2 = 0
    @Previewable @State var selection3 = 0
    @Previewable @State var selection4 = 0

    VStack(spacing: 40) {
        VStack(spacing: 10) {
            Text("2개 세그먼트")
                .textStyle(.title)
            DefaultSegmentControl(
                selection: $selection2,
                segments: ["아이템", "부동산"]
            )
            Text("선택된 인덱스: \(selection2)")
                .textStyle(.body)
        }

        VStack(spacing: 10) {
            Text("3개 세그먼트")
                .textStyle(.title)
            DefaultSegmentControl(
                selection: $selection3,
                segments: ["옵션 1", "옵션 2", "옵션 3"]
            )
            Text("선택된 인덱스: \(selection3)")
                .textStyle(.body)
        }

        VStack(spacing: 10) {
            Text("4개 세그먼트")
                .textStyle(.title)
            DefaultSegmentControl(
                selection: $selection4,
                segments: ["첫번째", "두번째", "세번째", "네번째"]
            )
            Text("선택된 인덱스: \(selection4)")
                .textStyle(.body)
        }
    }
    .padding()
}
