//
//  ComponentRunningCharacterView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 6/22/26.
//

import SwiftUI
import DUDesignSystem

struct ComponentRunningCharacterView: View {

    @State private var isFacingLeft: Bool = false
    @State private var isGamePaused: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            PreviewArea {
                RunningCharacter(isFacingLeft: isFacingLeft, isGamePaused: isGamePaused)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            List {
                Section("상태") {
                    Toggle("왼쪽 보기", isOn: $isFacingLeft)
                    Toggle("일시정지", isOn: $isGamePaused)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .scrollContentBackground(.hidden)
        }
        .background(Color.beige200)
        .navigationTitle("RunningCharacter")
    }
}

#Preview {
    NavigationStack {
        ComponentRunningCharacterView()
    }
}
