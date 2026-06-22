//
//  ComponentDropItemView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 6/22/26.
//

import SwiftUI
import DUDesignSystem

struct ComponentDropItemView: View {

    @State private var selectedType: DropItem.DropItemType = .smallGold

    var body: some View {
        VStack(spacing: 0) {
            PreviewArea {
                DropItem(type: selectedType)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            List {
                Section("타입") {
                    Picker("타입", selection: $selectedType) {
                        Text("Small Gold").tag(DropItem.DropItemType.smallGold)
                        Text("Large Gold").tag(DropItem.DropItemType.largeGold)
                        Text("Bug").tag(DropItem.DropItemType.bug)
                    }
                    .pickerStyle(.segmented)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .scrollContentBackground(.hidden)
        }
        .background(Color.beige200)
        .navigationTitle("DropItem")
    }
}

#Preview {
    NavigationStack {
        ComponentDropItemView()
    }
}
