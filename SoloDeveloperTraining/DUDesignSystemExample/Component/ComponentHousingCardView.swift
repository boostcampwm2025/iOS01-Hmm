//
//  ComponentHousingCardView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentHousingCardView: View {

    @State private var title: String = "고시원"
    @State private var price: String = "₩10,000,000"
    @State private var rewardPerSecond: String = "10.04M"
    @State private var selectedState: HousingCard.HousingCardState = .default

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Preview Area
            PreviewArea {
                HousingCard(
                    title: title,
                    price: price,
                    rewardPerSecond: rewardPerSecond,
                    imageName: "housing_street",
                    state: selectedState,
                    onTap: { selectedState = .selected },
                    onButtonTap: { selectedState = .equipped }
                )
                .frame(maxWidth: .infinity, alignment: .center)
            }

            // MARK: - Controls
            List {
                Section("상태") {
                    Picker("상태", selection: $selectedState) {
                        Text("Default").tag(HousingCard.HousingCardState.default)
                        Text("Selected").tag(HousingCard.HousingCardState.selected)
                        Text("Equipped").tag(HousingCard.HousingCardState.equipped)
                        Text("Locked").tag(HousingCard.HousingCardState.locked)
                    }
                    .pickerStyle(.segmented)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

                Section("속성") {
                    HStack {
                        Text("타이틀")
                        TextField("타이틀", text: $title)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("가격")
                        TextField("가격", text: $price)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("초당 재화")
                        TextField("초당 재화", text: $rewardPerSecond)
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
        .navigationTitle("HousingCard")
    }
}

#Preview {
    NavigationStack {
        ComponentHousingCardView()
    }
}
