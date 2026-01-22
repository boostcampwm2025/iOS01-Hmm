//
//  CareerRow.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/15/26.
//

import SwiftUI

private enum Constant {
    static let imageSize: CGSize = .init(width: 49, height: 49)
    static let cornerRadius: CGFloat = 4
    static let borderWidth: CGFloat = 1
    static let profileOpacity: CGFloat = 0.6

    enum Spacing {
        static let horizontal: CGFloat = 8
        static let vertical: CGFloat = 6
    }
}

struct CareerRow: View {
    let career: Career
    let userCareer: Career

    var body: some View {
        HStack(alignment: .center, spacing: Constant.Spacing.horizontal) {
            // 프로필 이미지
            Image(displayImageName)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: Constant.cornerRadius))
                .frame(width: Constant.imageSize.width, height: Constant.imageSize.height)
                .overlay(
                    RoundedRectangle(cornerRadius: Constant.cornerRadius)
                        .stroke(borderColor, lineWidth: Constant.borderWidth)
                )
                .opacity(state == .locked ? Constant.profileOpacity : 1.0)

            // 우측 컨텐츠
            VStack(alignment: .leading, spacing: Constant.Spacing.vertical) {
                HStack(alignment: .bottom) {
                    Text(career.rawValue)
                        .foregroundStyle(textColor)
                        .textStyle(.subheadline)
                    Spacer()
                    if state == .completed {
                        Text("완료")
                            .foregroundStyle(.gray400)
                            .textStyle(.label)
                    }
                }
                Text(career.description)
                    .foregroundStyle(textColor)
                    .textStyle(.label)
            }
        }
    }
}

private extension CareerRow {
    /// 커리어 Row 상태
    enum CareerState {
        case completed
        case inProgress
        case locked
    }

    /// 현재 상태 계산
    var state: CareerState {
        let careerIndex = Career.allCases.firstIndex(of: career) ?? 0
        let userIndex = Career.allCases.firstIndex(of: userCareer) ?? 0

        if career == userCareer {
            return .inProgress
        } else if careerIndex < userIndex {
            return .completed
        } else {
            return .locked
        }
    }

    /// 테두리 색상
    var borderColor: Color {
        state == .inProgress ? AppColors.accentYellow : AppColors.gray200
    }

    /// 텍스트 색상
    var textColor: Color {
        state == .completed ? AppColors.gray400 : .black
    }

    /// 표시할 이미지
    var displayImageName: String {
        state == .locked ? "profile_locked" : career.imageName
    }
}

#Preview {
    VStack(spacing: 12) {
        // 완료된 직업
        CareerRow(
            career: .unemployed,
            userCareer: .aspiringDeveloper
        )

        // 현재 진행중인 직업
        CareerRow(
            career: .aspiringDeveloper,
            userCareer: .aspiringDeveloper
        )

        // 잠긴 직업
        CareerRow(
            career: .juniorDeveloper,
            userCareer: .aspiringDeveloper
        )
    }
    .padding(.horizontal)
}
