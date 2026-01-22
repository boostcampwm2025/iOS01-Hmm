//
//  FeedbackSettingView.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/22/26.
//

import SwiftUI

private enum Constant {
    static let iconSize: CGFloat = 38
    static let horizontalSpacing: CGFloat = 12
    static let leadingPadding: CGFloat = iconSize + horizontalSpacing + 30
    static let bottomPadding: CGFloat = 15
}

struct FeedbackSettingView: View {
    var body: some View {
        HStack(spacing: Constant.horizontalSpacing) {
            // 사운드 버튼
            Button {} label: {
                Image(
                    systemName: true ? "speaker.circle.fill" : "speaker.slash.circle.fill"
                )
                    .resizable()
                    .frame(width: Constant.iconSize, height: Constant.iconSize)
                    .foregroundColor(.white)
            }

            // 햅틱 버튼
            Button {
                HapticService.shared.toggle()
            } label: {
                Image(
                    systemName: HapticService.shared.isEnabled ? "antenna.radiowaves.left.and.right.circle.fill" : "antenna.radiowaves.left.and.right.slash.circle.fill"
                )
                    .resizable()
                    .frame(width: Constant.iconSize, height: Constant.iconSize)
                    .foregroundColor(.white)
            }
        }
        .padding(.leading, Constant.leadingPadding)
        .padding(.bottom, Constant.bottomPadding)
    }
}
