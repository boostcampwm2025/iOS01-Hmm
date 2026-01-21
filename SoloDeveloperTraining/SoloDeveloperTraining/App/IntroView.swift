//
//  IntroView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-21.
//

import SwiftUI

struct IntroView: View {
    @State private var isBlinking = false

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image(.appLaunchScreen)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            }

            VStack {
                Spacer()

                Text("화면을 터치해 주세요")
                    .textStyle(.largeTitle)
                    .foregroundColor(.white)
                    .opacity(isBlinking ? 0.3 : 1.0)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isBlinking)
                    .padding(.bottom, 100)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            isBlinking = true
        }
    }
}

#Preview {
    IntroView()
}
