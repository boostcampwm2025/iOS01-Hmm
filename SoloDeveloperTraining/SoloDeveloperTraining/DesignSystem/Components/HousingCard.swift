//
//  HousingCard.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/15/26.
//

import SwiftUI

private enum Constant {
    static let cardWidth: CGFloat = 225
    static let cornerRadius: CGFloat = 6
    static let lineWidth: CGFloat = 3

    enum Padding {
        static let horizontal: CGFloat = 16
        static let top: CGFloat = 16
        static let bottom: CGFloat = 15
        static let textSpacing: CGFloat = 4
        static let titleSpacing: CGFloat = 15
        static let imageTop: CGFloat = 19
        static let buttonTop: CGFloat = 14
    }
}

struct HousingCard: View {
    let housing: Housing
    let state: ItemState
    let isSelected: Bool
    let onTap: () -> Void
    let onButtonTap: () -> Void

    var body: some View {
        HousingCardContent(
            housing: housing,
            buttonTitle: state == .locked ? "장착중" : "이사하기",
            isButtonEnabled: state == .available,
            onButtonTap: onButtonTap
        )
        .contentShape(RoundedRectangle(cornerRadius: Constant.cornerRadius))
        .overlay {
            if isSelected {
                RoundedRectangle(cornerRadius: Constant.cornerRadius)
                    .stroke(Color.black, lineWidth: Constant.lineWidth)
            }
        }
        .onTapGesture { onTap() }
    }
}

private struct HousingCardContent: View {
    let housing: Housing
    let buttonTitle: String
    let isButtonEnabled: Bool
    let onButtonTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                // 상단 텍스트 영역
                HStack(spacing: Constant.Padding.titleSpacing) {
                    Text(housing.displayTitle)
                        .textStyle(.callout)

                    Text("₩\(housing.cost.gold.formatted)")
                        .textStyle(.caption2)
                        .frame(maxWidth: .infinity, alignment: .leading)
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
            }
            .contentShape(Rectangle())

            // 버튼 영역
            LargeButton(
                title: buttonTitle,
                isEnabled: isButtonEnabled
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
    }
}

#Preview {
    @Previewable @State var isSelected = false
    @Previewable @State var state: ItemState = .available

    HousingCard(
        housing: .init(tier: .villa),
        state: state,
        isSelected: isSelected,
        onTap: {
            isSelected.toggle()
        },
        onButtonTap: {
            state = .locked
        }
    )
    .frame(height: 500)
}
