//
//  WorkItemCard.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/8/26.
//

import SwiftUI

public struct WorkItemCard: View {

    public enum WorkItemCardState {
        case `default`
        case selected
        case locked
    }

    public var title: String
    public var imageName: String
    public var state: WorkItemCardState
    public var onTap: () -> Void

    public init(
        title: String,
        imageName: String,
        state: WorkItemCardState = .default,
        onTap: @escaping () -> Void
    ) {
        self.title = title
        self.imageName = imageName
        self.state = state
        self.onTap = onTap
    }

    public var body: some View {
        ZStack(alignment: .top) {
            Color.beige100

            VStack(spacing: 0) {
                ItemLabel(text: title, icon: nil, size: .medium, color: .black)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, TokenSpacing.md)

                GeometryReader { geo in
                    ZStack {
                        Image(imageName, bundle: .module)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()
                            .opacity(state == .locked ? TokenOpacity.opacity40 : TokenOpacity.opacity100)

                        if state == .locked {
                            DUIcon(.lock, size: .size24)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: TokenRadius.ss))
                }
                .padding(.top, TokenSpacing.md)
                .padding(.horizontal, TokenSpacing.sm)
                .padding(.bottom, TokenSpacing.sm)
            }
        }
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.sm))
        .overlay(
            Group {
                if state == .selected {
                    RoundedRectangle(cornerRadius: TokenRadius.sm)
                        .stroke(Color.gray700, lineWidth: 2)
                }
            }
        )
        .onTapGesture {
            if state != .locked { onTap() }
        }
    }
}

#Preview {
    WorkItemCard(
        title: "언어 맞추기",
        imageName: "work_language",
        state: .selected,
        onTap: {}
    )
    .frame(width: 100, height: 202)
    .padding(TokenSpacing.md)
    .background(Color.beige200)
}
