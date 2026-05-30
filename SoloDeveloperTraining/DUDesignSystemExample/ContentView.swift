//
//  ContentView.swift
//  DUDesignSystemExample
//
//  Created by SeoJunYoung on 5/30/26.
//

import SwiftUI
import DUDesignSystem

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: TokenSpacing.lg) {
                    VStack(alignment: .leading, spacing: TokenSpacing.xs) {
                        Text("DUDesignSystem")
                            .duFont(.largeTitle)
                            .foregroundStyle(Color.gray700)
                        Text("개발자 키우기 디자인 시스템")
                            .duFont(.body)
                            .foregroundStyle(Color.gray400)
                    }
                    .padding(.horizontal, TokenSpacing.md)

                    NavigationLink(destination: TokenListView()) {
                        HStack(spacing: TokenSpacing.sm) {
                            Image(systemName: "swatchpalette")
                                .font(.title2)
                                .foregroundStyle(Color.orange300)
                                .frame(width: 44, height: 44)
                                .background(Color.orange100)
                                .clipShape(RoundedRectangle(cornerRadius: TokenRadius.sm))

                            VStack(alignment: .leading, spacing: TokenSpacing.xx) {
                                Text("Token")
                                    .duFont(.headline)
                                    .foregroundStyle(Color.gray700)
                                Text("Color, Typography, Spacing 등 디자인 토큰")
                                    .duFont(.caption)
                                    .foregroundStyle(Color.gray400)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(Color.gray300)
                        }
                        .padding(TokenSpacing.md)
                        .background(Color.beige50)
                        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.md))
                        .tokenShadow(TokenShadow.small)
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
