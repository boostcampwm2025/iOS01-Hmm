//  LevelUpEffectView.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/24/26.
//

import SwiftUI
import DUDesignSystem

private enum Constant {
    static let gifAspectRatio: CGFloat = 1500.0 / 400.0
    static let titleBoxHeight: CGFloat = 24
    static let barWidth: CGFloat = 9
    static let barHeight: CGFloat = 36
    static let barOverlap: CGFloat = 3
}

struct LevelUpEffectView: View {

    private enum Phase {
        case start, loop
    }

    @Binding var isPresented: Bool
    let previousCareerTitle: String
    let currentCareerTitle: String

    @State private var phase: Phase = .start
    @State private var showTitleBox: Bool = false
    @State private var showGIF: Bool = false
    @State private var gradientOpacity: CGFloat = 0
    @State private var titleText: String = ""

    var body: some View {
        ZStack {
            Color.black300EventDim
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }

            VStack(spacing: TokenSpacing.xs) {
                GIFView(
                    gifName: phase == .start
                    ? "levelUpStart"
                    : "levelUpRepeat",
                    onFinished: phase == .start ? {
                        phase = .loop
                        switchToLoopAnimation()
                    } : nil
                )
                .frame(maxWidth: .infinity)

                careerTitleBox
            }
            .onAppear { startAnimation() }
            .onDisappear { phase = .start }
        }
    }
}

// MARK: - sub views
private extension LevelUpEffectView {
    var borderLine: some View {
        Rectangle()
            .fill(Color.gray700)
            .frame(height: 1)
    }

    var sidebarOverlay: some View {
        HStack {
            Image.duImage("bar")
                .resizable()
                .frame(width: Constant.barWidth, height: Constant.barHeight)
            Spacer()
            Image.duImage("bar")
                .resizable()
                .frame(width: Constant.barWidth, height: Constant.barHeight)
        }
    }

    var careerTitleBox: some View {
        ZStack {
            ItemLabel(text: titleText, font: .caption, color: .white300)
                .frame(height: Constant.titleBoxHeight)
                .frame(maxWidth: .infinity)
                .background(titleBoxBackground)
                .overlay(alignment: .top) { borderLine }
                .overlay(alignment: .bottom) { borderLine }
                .padding(.horizontal, Constant.barOverlap)

            sidebarOverlay
        }
        .opacity(showTitleBox ? 1 : 0)
        .padding(.horizontal, TokenGrid.marginPopUp)
    }

    var titleBoxBackground: some View {
        ZStack {
            Color.orange500

            LinearGradient(
                stops: [
                    .init(color: .accentYellow, location: 0),
                    .init(color: .lightOrange, location: 0.6)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .opacity(gradientOpacity)
        }
    }
}

// MARK: - helpers
private extension LevelUpEffectView {
    func startAnimation() {
        guard phase == .start else { return }

        showTitleBox = false
        showGIF = false
        gradientOpacity = 0
        titleText = previousCareerTitle

        showTitleBox = true
        showGIF = true
    }

    func switchToLoopAnimation() {
        guard phase == .loop else { return }

        gradientOpacity = 1
        titleText = currentCareerTitle
    }
}

#Preview {
    @Previewable @State var isPresented: Bool = true
    LevelUpEffectView(
        isPresented: $isPresented,
        previousCareerTitle: "이전 개발자",
        currentCareerTitle: "이후 개발자"
    )
}
