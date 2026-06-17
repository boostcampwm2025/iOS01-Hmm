//
//  LevelUpEffectView.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/24/26.
//

import SwiftUI

struct LevelUpEffectView: View {
    @Binding var isPresented: Bool
    let career: Career?

    var body: some View {
        ZStack {
            // 배경 디밍
            Color.black.opacity(0.8)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        isPresented = false
                    }
                }

            // 컨텐츠
            VStack(spacing: 20) {
                Text("LEVEL UP! (터치하면 넘어갑니다)")
                    .font(.largeTitle)
                    .foregroundColor(.yellow)
                if let career = career {
                    VStack(spacing: 10) {
                        Text(career.rawValue)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}
