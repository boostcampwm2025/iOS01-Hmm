//
//  PriceButton.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/14/26.
//

import SwiftUI

private enum Constant {
    enum Layout {
        static let cornerRadius: CGFloat = 5
        static let buttonHeight: CGFloat = 38
        static let contentSpacing: CGFloat = 3
        static let horizontalPadding: CGFloat = 8
    }

    enum Shadow {
        static let offsetX: CGFloat = 2
        static let offsetY: CGFloat = 3
    }

    enum Icon {
        static let coinSize = CGSize(width: 15, height: 15)
        static let lockSize = CGSize(width: 18, height: 18)
    }

    enum Overlay {
        static let disabledOpacity: Double = 0.4
    }
}

struct PriceButton: View {

    @State private var isPressed: Bool = false
    let cost: Cost
    let state: ItemState
    let axis: Axis
    let width: CGFloat?
    let action: () -> Void

    init(
        cost: Cost,
        state: ItemState,
        axis: Axis,
        width: CGFloat? = nil,
        action: @escaping () -> Void
    ) {
        self.cost = cost
        self.state = state
        self.axis = axis
        self.width = width
        self.action = action
    }

    private var isDisabled: Bool {
        state != .available
    }

    var body: some View {
        buttonContent
            .overlay {
                if isDisabled {
                    disabledOverlay
                }
            }
            .animation(.none, value: isDisabled)
            .background(
                RoundedRectangle(cornerRadius: Constant.Layout.cornerRadius)
                    .foregroundStyle(isDisabled ? .gray400 : .black)
                    .offset(
                        x: Constant.Shadow.offsetX,
                        y: Constant.Shadow.offsetY
                    )
            )
            .animation(.none, value: isDisabled)
            .contentShape(Rectangle())
            .onTapGesture {
                guard !isDisabled else { return }
                action()
            }
            .simultaneousGesture(
                isDisabled ? nil : DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        isPressed = true
                    }
                    .onEnded { _ in
                        isPressed = false
                    }
            )
            .animation(.easeInOut(duration: 0.1), value: isPressed)
    }

    @ViewBuilder
    var buttonContent: some View {
        Group {
            if axis == .horizontal {
                HStack(spacing: Constant.Layout.contentSpacing) {
                    contentViews
                }
            } else {
                VStack(spacing: Constant.Layout.contentSpacing) {
                    contentViews
                }
            }
        }
        .frame(width: width ?? .none, height: Constant.Layout.buttonHeight)
        .padding(.horizontal, Constant.Layout.horizontalPadding)
        .background(.orange500)
        .clipShape(RoundedRectangle(cornerRadius: Constant.Layout.cornerRadius))
        .offset(
            x: isPressed ? Constant.Shadow.offsetX : 0,
            y: isPressed ? Constant.Shadow.offsetY : 0
        )
        .animation(.none, value: cost)
        .animation(.none, value: state)
    }

    @ViewBuilder
    var contentViews: some View {
        HStack {
            if cost.gold > 0 {
                CurrencyLabel(
                    axis: .horizontal,
                    icon: .gold,
                    textStyle: .caption,
                    value: cost.gold
                )
                .foregroundStyle(.white)
            }
            if cost.diamond > 0 {
                CurrencyLabel(
                    axis: .horizontal,
                    icon: .diamond,
                    textStyle: .caption,
                    value: cost.diamond
                )
                .foregroundStyle(.white)
            }
        }
    }

    var disabledOverlay: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constant.Layout.cornerRadius)
                .foregroundStyle(Color.gray200.opacity(Constant.Overlay.disabledOpacity))

            if state == .locked {
                Image(.iconLock)
                    .resizable()
                    .frame(
                        width: Constant.Icon.lockSize.width,
                        height: Constant.Icon.lockSize.height
                    )
            }
        }
    }
}

#Preview {
    VStack(alignment: .center, spacing: 20) {
        PriceButton(
            cost: .init(gold: 1_000_000),
            state: .available,
            axis: .horizontal
        ) {}
        PriceButton(
            cost: .init(gold: 100_000, diamond: 50),
            state: .available,
            axis: .vertical
        ) {}
        PriceButton(
            cost: .init(gold: 1_000_000_000),
            state: .locked,
            axis: .horizontal
        ) {}
        PriceButton(
            cost: .init(diamond: 1_000),
            state: .insufficient,
            axis: .vertical
        ) {}
    }
}
