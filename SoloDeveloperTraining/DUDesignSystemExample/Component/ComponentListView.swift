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
        ("QuizButton", "questionmark.circle", AnyView(ComponentQuizButtonView())),
        ("InputField", "text.cursor", AnyView(ComponentInputFieldView())),
        ("Toast", "text.bubble", AnyView(ComponentToastView())),
        ("Popup", "rectangle.on.rectangle", AnyView(ComponentPopupView())),
        ("ProgressBar", "chart.bar", AnyView(ComponentProgressBarView())),
        ("GameToolBar", "gamecontroller", AnyView(ComponentGameToolBarView())),
        ("StatusBar", "person.crop.rectangle", AnyView(ComponentStatusBarView())),
        ("ItemRow", "list.bullet.rectangle", AnyView(ComponentItemRowView())),
        ("CareerRow", "person.crop.rectangle.stack", AnyView(ComponentCareerRowView())),
        ("MissionCard", "trophy", AnyView(ComponentMissionCardView())),
        ("HousingCard", "house", AnyView(ComponentHousingCardView())),
        ("WorkItemCard", "rectangle.fill", AnyView(ComponentWorkItemCardView())),
        ("WorkSegmentControl", "rectangle.grid.2x2", AnyView(ComponentWorkSegmentControlView())),
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
