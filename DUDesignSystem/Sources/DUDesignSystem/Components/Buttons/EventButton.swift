//
//  SwiftUIView.swift
//  DUDesignSystem
//
//  Created by sunjae on 6/12/26.
//

import SwiftUI

public struct EventButton: View {

    public enum EventButtonType {
        case next(action: () -> Void)

        case choice(
            optionA: String,
            optionB: String,
            selected: String? = nil,
            onSelect: (String) -> Void
        )

        case reselect(
            onReselect: () -> Void,
            onComplete: () -> Void
        )

        case ending(
            onSave: () -> Void,
            onShare: () -> Void,
            onRebirth: () -> Void
        )
    }

    public let type: EventButtonType

    public init(type: EventButtonType) {
        self.type = type
    }

    public var body: some View {
        switch type {

        case .next(let action):
            nextButtonView(action: action)

        case let .choice(optionA, optionB, selected, onSelect):
            choiceButtonView(
                optionA: optionA,
                optionB: optionB,
                selected: selected,
                onSelect: onSelect
            )

        case let .reselect(onReselect, onComplete):
            reselectButtonView(
                onReselect: onReselect,
                onComplete: onComplete
            )

        case let .ending(onSave, onShare, onRebirth):
            endingButtonView(
                onSave: onSave,
                onShare: onShare,
                onRebirth: onRebirth
            )
        }
    }
}

private extension EventButton {
    func nextButtonView(
        action: @escaping () -> Void
    ) -> some View {
        VStack(spacing: TokenSpacing.md) {
            TextButton(text: "", type: .primary, action: {})
                .hidden()

            TextButton(
                text: "다음으로",
                type: .primary,
                action: action
            )
        }
    }

    func choiceButtonView(
        optionA: String,
        optionB: String,
        selected: String? = nil,
        onSelect: @escaping (String) -> Void
    ) -> some View {
        VStack(spacing: TokenSpacing.md) {
            QuizButton(
                text: optionA,
                state: selected == optionA ? .selected : .default
            ) {
                onSelect(optionA)
            }

            QuizButton(text: optionB,
                       state: selected == optionB ? .selected : .default) {
                onSelect(optionB)
            }
        }
    }

    func reselectButtonView(
        onReselect: @escaping () -> Void,
        onComplete: @escaping () -> Void
    ) -> some View {
        VStack(spacing: TokenSpacing.md) {
            IconButton(
                text: "다시 선택",
                icon: .ad,
                size: .large,
                action: onReselect
            )

            TextButton(
                text: "완료",
                type: .priority,
                action: onComplete
            )
        }
    }

    func endingButtonView(
        onSave: @escaping () -> Void,
        onShare: @escaping () -> Void,
        onRebirth: @escaping () -> Void
    ) -> some View {
        VStack(spacing: TokenSpacing.md) {
            HStack(spacing: TokenSpacing.sm) {
                IconButton(
                    text: "이미지 저장",
                    icon: .image,
                    size: .medium,
                    action: onSave
                )

                IconButton(
                    text: "공유하기",
                    icon: .share,
                    size: .medium,
                    action: onShare
                )
            }

            TextButton(
                text: "환생하기",
                type: .priority,
                action: onRebirth
            )
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        EventButton(type: .next(action: {}))
        EventButton(type: .choice(
            optionA: "1번째",
            optionB: "2번째",
            onSelect: { _ in }))
        EventButton(type: .reselect(onReselect: {}, onComplete: {}))
        EventButton(type: .ending(onSave: {}, onShare: {}, onRebirth: {}))
    }
}

