//
//  SwiftUIView.swift
//  DUDesignSystem
//
//  Created by sunjae on 6/12/26.
//

import SwiftUI

public struct EventButton: View {
    public enum EventButtonType {
        case next
        case choice
        case reselect
        case ending
    }

    public let type: EventButtonType
    public let firstChoice: String?
    public let secondChoice: String?

    public init(
        type: EventButtonType,
        firstChoice: String? = nil,
        secondChoice: String? = nil
    ) {
        self.type = type
        self.firstChoice = firstChoice
        self.secondChoice = secondChoice
    }

    private var nextButtonView: some View {
        VStack(spacing: TokenSpacing.md) {
            TextButton(text: "", type: .primary, action: {}).hidden()
            TextButton(text: "다음으로", type: .primary, action: {})
        }
    }

    private var choiceButtonView: some View {
        VStack(spacing: TokenSpacing.md) {
            if let firstChoice, let secondChoice {
                QuizButton(text: firstChoice, action: {})
                QuizButton(text: secondChoice, action: {})
            }
        }
    }

    private var reselectButtonView: some View {
        VStack(spacing: TokenSpacing.md) {
            TextButton(text: "다시 선택", type: .primary, action: {})
            TextButton(text: "완료", type: .priority, action: {})
        }
    }

    private var endingButtonView: some View {
        VStack(spacing: TokenSpacing.md) {
            HStack(spacing: TokenSpacing.sm) {
                TextButton(text: "저장하기", type: .primary, action: {})
                TextButton(text: "공유하기", type: .primary, action: {})
            }
            TextButton(text: "환생하기", type: .priority, action: {})
        }
    }

    public var body: some View {
        Group {
            switch type {
            case .next:
                nextButtonView
            case .choice:
                choiceButtonView
            case .reselect:
                reselectButtonView
            case .ending:
                endingButtonView
            }
        }.padding(.horizontal, TokenSpacing.lg)
    }
}

#Preview {
    VStack(spacing: 40) {
        EventButton(type: .next)
        EventButton(type: .choice, firstChoice: "1번째", secondChoice: "2번째")
        EventButton(type: .reselect)
        EventButton(type: .ending)
    }
}

