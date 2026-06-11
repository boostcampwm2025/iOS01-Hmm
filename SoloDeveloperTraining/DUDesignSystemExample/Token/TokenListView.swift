//
//  TokenListView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct TokenListView: View {

    private let items: [(String, String, AnyView)] = [
        ("Color",      "paintpalette",          AnyView(TokenColorView())),
        ("Opacity",    "circle.lefthalf.filled", AnyView(TokenOpacityView())),
        ("Elevation",  "square.stack",           AnyView(TokenElevationView())),
        ("Typography", "textformat",             AnyView(TokenTypographyView())),
        ("Radius",     "rectangle.roundedtop",   AnyView(TokenRadiusView())),
        ("Spacing",    "arrow.left.and.right",   AnyView(TokenSpacingView())),
        ("Grid",       "square.grid.2x2",        AnyView(TokenGridView())),
    ]

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: TokenSpacing.sm) {
                ForEach(items, id: \.0) { name, icon, destination in
                    NavigationLink(destination: destination) {
                        VStack(spacing: TokenSpacing.sm) {
                            Image(systemName: icon)
                                .font(.title2)
                                .foregroundStyle(Color.orange300)
                                .frame(width: 48, height: 48)
                                .background(Color.beige100)
                                .clipShape(RoundedRectangle(cornerRadius: TokenRadius.sm))

                            Text(name)
                                .duFont(.body)
                                .foregroundStyle(Color.gray700)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, TokenSpacing.md)
                        .background(Color.beige50)
                        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.md))
                        .tokenShadow(TokenShadow.dim)
                    }
                }
            }
            .padding(TokenSpacing.md)
        }
        .background(Color.beige200)
        .navigationTitle("Token")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        TokenListView()
    }
}
