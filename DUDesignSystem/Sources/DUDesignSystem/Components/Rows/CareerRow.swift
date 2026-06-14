//
//  CareerRow.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/8/26.
//

import SwiftUI

public struct CareerRow: View {

    public enum CareerRowState {
        case achieved
        case current
        case upcoming
    }

    public var imageName: String
    public var title: String
    public var description: String
    public var state: CareerRowState

    public init(
        imageName: String,
        title: String,
        description: String,
        state: CareerRowState
    ) {
        self.imageName = imageName
        self.title = title
        self.description = description
        self.state = state
    }

    private var textOpacity: Double {
        switch state {
        case .achieved:  return TokenOpacity.opacity20
        case .current:   return TokenOpacity.opacity100
        case .upcoming:  return TokenOpacity.opacity80
        }
    }

    public var body: some View {
        HStack(alignment: .center, spacing: TokenSpacing.sm) {
            Image(imageName, bundle: .module)
                .resizable()
                .scaledToFill()
                .frame(width: 44, height: 44)
                .clipped()

            VStack(alignment: .leading, spacing: TokenSpacing.xs) {
                HStack(alignment: .top) {
                    ItemLabel(text: title, font: .subheadline, color: .black300)
                    Spacer()
                    if state == .achieved {
                        ItemLabel(text: "완료", font: .label, color: .black300)
                    }
                }
                ItemLabel(text: description, font: .label, color: .black300)
            }
            .opacity(textOpacity)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    VStack(spacing: TokenSpacing.sm) {
        CareerRow(imageName: "", title: "백수", description: "아직 아무것도 시작하지 않았지만, 시간은 가장 많다", state: .achieved)
        CareerRow(imageName: "", title: "백수", description: "아직 아무것도 시작하지 않았지만, 시간은 가장 많다", state: .current)
        CareerRow(imageName: "", title: "백수", description: "아직 아무것도 시작하지 않았지만, 시간은 가장 많다", state: .upcoming)
    }
    .padding(TokenSpacing.md)
    .background(Color.beige200)
}
