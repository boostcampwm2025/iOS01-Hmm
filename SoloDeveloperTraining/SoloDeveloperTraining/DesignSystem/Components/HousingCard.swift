//
//  HousingCard.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/15/26.
//

import SwiftUI

enum HousingCardState {
    case normal
    case selected
    case equipped
    case equippedSelected
}

private enum Constant {
    static let cardWidth: CGFloat = 225
    static let cornerRadius: CGFloat = 6
    static let lineWidth: CGFloat = 3

    enum Padding {
        static let horizontal: CGFloat = 16
        static let top: CGFloat = 16
        static let bottom: CGFloat = 15
        static let textSpacing: CGFloat = 4
        static let imageTop: CGFloat = 19
        static let buttonTop: CGFloat = 14
    }
}

struct HousingCard: View {
    let housing: Housing
    @Binding var state: HousingCardState
    let onButtonTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // 상단 텍스트 영역
            HStack {
                Text(housing.displayTitle)
                    .textStyle(.callout)

                Spacer()

                Text("₩\(housing.cost.gold.formatted)")
                    .textStyle(.caption2)
            }
            .padding(.horizontal, Constant.Padding.horizontal)
            .padding(.top, Constant.Padding.top)

            Text("초당 재화 획득량 \(housing.goldPerSecond)")
                .textStyle(.label)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, Constant.Padding.horizontal)
                .padding(.top, Constant.Padding.textSpacing)

            // 이미지 영역
            Image(housing.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: Constant.cardWidth)
                .frame(maxHeight: .infinity)
                .clipped()
                .padding(.top, Constant.Padding.imageTop)
                .padding(.bottom, Constant.Padding.buttonTop)

            // 버튼 영역
            LargeButton(
                title: buttonTitle,
                isEnabled: state != .equipped && state != .equippedSelected
            ) {
                onButtonTap()
            }
            .padding(.bottom, Constant.Padding.bottom)
        }
        .foregroundStyle(.black)
        .frame(maxHeight: .infinity)
        .frame(width: Constant.cardWidth)
        .background(AppColors.gray100)
        .cornerRadius(Constant.cornerRadius)
        .overlay {
            if state == .selected || state == .equippedSelected {
                RoundedRectangle(cornerRadius: Constant.cornerRadius)
                    .stroke(Color.black, lineWidth: Constant.lineWidth)
            }
        }
        .onTapGesture {
            toggleSelection()
        }
    }
}

// MARK: - Helper
private extension HousingCard {
    func toggleSelection() {
        switch state {
        case .normal:
            state = .selected
        case .selected:
            state = .normal
        case .equipped:
            state = .equippedSelected
        case .equippedSelected:
            state = .equipped
        }
    }

    var buttonTitle: String {
        switch state {
        case .normal, .selected:
            return "이사하기"
        case .equipped, .equippedSelected:
            return "장착중"
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var state1: HousingCardState = .normal
        @State private var state2: HousingCardState = .normal
        @State private var state3: HousingCardState = .normal

        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    HousingCard(housing: .street, state: $state1) {
                        state1 = .equipped
                    }
                    .frame(height: 300)

                    HousingCard(housing: .pentHouse, state: $state2) {
                        state2 = .equipped
                    }
                    .frame(height: 400)

                    HousingCard(housing: .villa, state: $state3) {
                        state3 = .equipped
                    }
                    .frame(height: 500)
                }
                .padding(.horizontal)
            }
        }
    }
    return PreviewWrapper()
}
