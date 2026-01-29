//
//  ContentView.swift
//  Prototype
//
//  Created by SeoJunYoung on 12/16/25.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    let gameSceme: SKScene = {
        let scene = StackGameScene()
        scene.scaleMode = .resizeFill
        return scene
    }()

    var body: some View {
        NavigationStack {
            List {
                NavigationLink("물리 엔진 검증") {
                    SpriteView(scene: gameSceme)
                        .ignoresSafeArea()
                }
                NavigationLink("자이로 센서 검증") {
                    MotionView()
                }
                NavigationLink("탭 이벤트 검증") {
                    VarifyTapEventCalculationView()
                }
                NavigationLink("디자인 리소스 적용 검증") {
                    ApplyDesignResourceView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
