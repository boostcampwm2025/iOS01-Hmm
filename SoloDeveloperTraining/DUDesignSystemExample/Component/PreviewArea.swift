//
//  PreviewArea.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct PreviewArea<Content: View>: View {

    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: TokenSpacing.sm) {
            Text("Preview")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.previewLabel)
                .padding(.horizontal, TokenSpacing.md)

            content
        }
        .padding(.vertical, TokenSpacing.md)
        .background(Color.previewBackground)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.sm))
        .padding(.horizontal, TokenSpacing.md)
        .padding(.top, TokenSpacing.md)
        .padding(.bottom, TokenSpacing.sm)
    }
}

// MARK: - Example App 전용 컬러 (DUDesignSystem 토큰 미사용)

private extension Color {
    /// 예시 앱 프리뷰 영역 배경 — 쿨 그레이 계열로 디자인 시스템 베이지/오렌지 계열과 충돌 없음
    static let previewBackground = Color(red: 226/255, green: 232/255, blue: 240/255)
    /// 프리뷰 영역 레이블
    static let previewLabel = Color(red: 148/255, green: 163/255, blue: 184/255)
}
