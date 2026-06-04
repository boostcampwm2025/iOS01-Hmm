//
//  ContentView.swift
//  DUDesignSystemExample
//
//  Created by SeoJunYoung on 5/30/26.
//

import SwiftUI
import DUDesignSystem

struct ContentView: View {

    @ViewBuilder
    private func sectionRow(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: TokenSpacing.sm) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(Color.orange300)
                .frame(width: 44, height: 44)
                .background(Color.beige100)
                .clipShape(RoundedRectangle(cornerRadius: TokenRadius.sm))

            VStack(alignment: .leading, spacing: TokenSpacing.xx) {
                Text(title)
                    .duFont(.headline)
                    .foregroundStyle(Color.gray700)
                Text(description)
                    .duFont(.caption)
                    .foregroundStyle(Color.gray400)
                    .multilineTextAlignment(.leading)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(Color.gray400)
        }
        .padding(TokenSpacing.md)
        .background(Color.beige50)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.md))
        .tokenShadow(TokenShadow.dim)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: TokenSpacing.lg) {
                    VStack(alignment: .leading, spacing: TokenSpacing.xs) {
                        Text("DUDesignSystem")
                            .duFont(.title1)
                            .foregroundStyle(Color.gray700)
                        Text("개발자 키우기 디자인 시스템")
                            .duFont(.body)
                            .foregroundStyle(Color.gray400)
                    }
                    .padding(.horizontal, TokenSpacing.md)

                    VStack(spacing: TokenSpacing.sm) {
                        NavigationLink(destination: TokenListView()) {
                            sectionRow(
                                icon: "swatchpalette",
                                title: "Token",
                                description: "Color, Typography, Spacing 등 디자인 토큰"
                            )
                        }
                        NavigationLink(destination: ComponentListView()) {
                            sectionRow(
                                icon: "square.on.square",
                                title: "Component",
                                description: "Icon 등 재사용 가능한 UI 컴포넌트"
                            )
                        }
                    }
                    .padding(.horizontal, TokenSpacing.md)
                }
                .padding(.vertical, TokenSpacing.md)
            }
            .background(Color.beige200)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
