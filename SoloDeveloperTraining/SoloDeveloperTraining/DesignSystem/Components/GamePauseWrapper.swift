//
//  GamePauseWrapper.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/27/26.
//

import SwiftUI

private enum Constant {
    static let height: CGFloat = 407
    static let opacity: Double = 0.75
    static let buttonSpacing: CGFloat = 50
}

struct GamePauseWrapper: View {
    var body: some View {
        Rectangle()
            .fill(.white)
            .frame(maxWidth: .infinity)
            .frame(height: Constant.height)
            .opacity(Constant.opacity)
            .overlay {
                HStack(spacing: Constant.buttonSpacing) {
                    Button(action: {
                        print("나가기")
                    }, label: {
                        Text("나가기")
                            .textStyle(.title2)
                            .foregroundStyle(.orange600)
                    })
                    Button(action: {
                        print("계속 하기")
                    }, label: {
                        Text("계속하기").textStyle(.title2)  .foregroundStyle(.orange600)
                    })
                }
            }
    }
}

#Preview {
    GamePauseWrapper()
}
