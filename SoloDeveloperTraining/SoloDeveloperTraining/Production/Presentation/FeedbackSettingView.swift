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

    enum ImageName {
        static let soundActive: String = "speaker.circle.fill"
        static let soundInactive: String = "speaker.slash.circle.fill"
        static let hapticActive: String = "antenna.radiowaves.left.and.right.circle.fill"
        static let hapticInactive: String = "antenna.radiowaves.left.and.right.slash.circle.fill"
    }
}

struct FeedbackSettingView: View {
    var body: some View {
        HStack(spacing: Constant.horizontalSpacing) {
            // 사운드 버튼
            Button {
                SoundService.shared.toggle()
            } label: {
                Image(
                    systemName: SoundService.shared.isEnabled ? Constant.ImageName.soundActive : Constant.ImageName.soundInactive
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
                    systemName: HapticService.shared.isEnabled ? Constant.ImageName.hapticActive : Constant.ImageName.hapticInactive
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
