//
//  ComponentStatusBarView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentStatusBarView: View {

    @State private var careerProgress: Double = 0.4
    @State private var gold: String = "20,000"
    @State private var diamond: String = "20"

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Preview Area
            PreviewArea {
                StatusBar(
                    imageName: "icon_coffee",
                    careerNickname: "개발자 지망생 소피아",
                    careerProgress: careerProgress,
                    gold: gold,
                    diamond: diamond
                )
                .frame(maxWidth: .infinity)
            }

            // MARK: - Controls
            List {
                Section("커리어 진행도") {
                    Slider(value: $careerProgress, in: 0...1)
                    Text("\(Int(careerProgress * 100))%")
                        .foregroundStyle(Color.gray400)
                }

                Section("재화") {
                    HStack {
                        Text("골드")
                        TextField("골드", text: $gold)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("다이아")
                        TextField("다이아", text: $diamond)
                            .multilineTextAlignment(.trailing)
                    }
                }

                Section {
                    Text("상태 변경이나 유효성 검사는 비즈니스 로직이므로 예시 앱에는 반영되지 않아요.")
                        .font(.caption)
                        .foregroundStyle(Color.gray400)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .background(Color.beige200)
        .navigationTitle("StatusBar")
    }
}

#Preview {
    NavigationStack {
        ComponentStatusBarView()
    }
}
