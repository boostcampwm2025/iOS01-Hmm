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
    @State private var isTitleBoxVisible = false
    @State private var gradientOpacity: CGFloat = 0

    private var careerTitle: String {
        phase == .start ? previousCareerTitle : currentCareerTitle
    }

    var body: some View {
        if isPresented {
            ZStack {
                Color.black300EventDim
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                        }
                    }

                VStack(spacing: TokenSpacing.xs) {
                    GIFView(
                        gifName: phase == .start
                        ? "levelUpStart"
                        : "levelUpRepeat",
                        onFinished: phase == .start ? { phase = .loop } : nil
                    )
                    .frame(maxWidth: .infinity)

                    careerTitleBox
                }
                .onAppear { startAnimation() }
                .onDisappear { phase = .start }
                .onChange(of: phase) { switchToLoopAnimation() }
            }
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
            Image(.bar)
                .resizable()
                .frame(width: Constant.barWidth, height: Constant.barHeight)
            Spacer()
            Image(.bar)
                .resizable()
                .frame(width: Constant.barWidth, height: Constant.barHeight)
        }
    }

    var careerTitleBox: some View {
        ZStack {
            ItemLabel(text: careerTitle, font: .caption, color: .white300)
                .frame(height: Constant.titleBoxHeight)
                .frame(maxWidth: .infinity)
                .background(titleBoxBackground)
                .overlay(alignment: .top) { borderLine }
                .overlay(alignment: .bottom) { borderLine }
                .padding(.horizontal, Constant.barOverlap)

            sidebarOverlay
        }
        .opacity(isTitleBoxVisible ? 1 : 0)
        .padding(.horizontal, TokenGrid.marginPopUp)
    }

    var titleBoxBackground: some View {
        ZStack {
            Color.orange500

            LinearGradient(
                stops: [
                    .init(color: .accentYellow, location: 0),
                    .init(color: .accentYellow, location: 0.4),
                    .init(color: .lightOrange, location: 1)
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

        isTitleBoxVisible = false
        gradientOpacity = 0

        withAnimation(.easeIn(duration: 0.3)) {
            isTitleBoxVisible = true
        }
    }

    func switchToLoopAnimation() {
        guard phase == .loop else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeOut(duration: 0.3)) {
                gradientOpacity = 1
            }
        }
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
