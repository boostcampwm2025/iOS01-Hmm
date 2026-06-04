//
//  ComponentListView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentListView: View {

    private let items: [(String, String, AnyView)] = [
        ("Icon", "square.on.square", AnyView(ComponentIconView())),
        ("ItemLabel", "tag", AnyView(ComponentDefaultLabelView())),
        ("EffectLabel", "plus.forwardslash.minus", AnyView(ComponentEffectLabelView())),
        ("ItemButton", "hand.tap", AnyView(ComponentItemButtonView())),
        ("TextButton", "rectangle.and.hand.point.up.left", AnyView(ComponentTextButtonView())),
        ("TabbarItem", "menubar.rectangle", AnyView(ComponentTabbarItemView())),
        ("Tabbar", "dock.rectangle", AnyView(ComponentTabbarView())),
        ("SegmentControl", "rectangle.split.2x1", AnyView(ComponentSegmentControlView())),
        ("SmallButton", "smallcircle.filled.circle", AnyView(ComponentSmallButtonView())),
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
        .navigationTitle("Component")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        ComponentListView()
    }
}
