//
//  MultiTouchView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-23.
//

import SwiftUI
import UIKit

struct MultiTouchView: UIViewRepresentable {
    let onTap: (CGPoint) -> Void

    func makeUIView(context: Context) -> MultiTouchUIView {
        let view = MultiTouchUIView()
        view.onTap = onTap
        return view
    }

    func updateUIView(_ uiView: MultiTouchUIView, context: Context) {
        uiView.onTap = onTap
    }
}

final class MultiTouchUIView: UIView {
    var onTap: ((CGPoint) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        isMultipleTouchEnabled = true
        isUserInteractionEnabled = true
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) { nil }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        // 모든 터치에 대해 처리
        for touch in touches {
            let location = touch.location(in: self)
            let safeAreaBottom = safeAreaInsets.bottom
            let maxY = bounds.height - safeAreaBottom

            if location.y <= maxY {
                onTap?(location)
            }
        }
    }
}
