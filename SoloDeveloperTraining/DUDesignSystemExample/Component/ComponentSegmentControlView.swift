//
//  ComponentSegmentControlView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentSegmentControlView: View {

    @State private var selectedIndex: Int = 0
    @State private var leading: String = "아이템"
    @State private var trailing: String = "부동산"

    var body: some View {
        VStack(spacing: TokenSpacing.lg) {
            SegmentControl(leading: leading, trailing: trailing, selectedIndex: $selectedIndex)
                .padding(.horizontal, TokenGrid.paddingSide)

            VStack(alignment: .leading, spacing: TokenSpacing.sm) {
                Text("선택된 탭: \(selectedIndex == 0 ? leading : trailing)")
                    .duFont(.caption)
                    .foregroundStyle(Color.gray400)

                Picker("선택", selection: $selectedIndex) {
                    Text(leading).tag(0)
                    Text(trailing).tag(1)
                }
                .pickerStyle(.segmented)
            }
            .padding(.horizontal, TokenGrid.paddingSide)

            VStack(spacing: TokenSpacing.xs) {
                HStack {
                    Text("앞")
                        .duFont(.caption)
                        .foregroundStyle(Color.gray400)
                        .frame(width: 24)
                    TextField("앞 텍스트", text: $leading)
                        .textFieldStyle(.roundedBorder)
                }
                HStack {
                    Text("뒤")
                        .duFont(.caption)
                        .foregroundStyle(Color.gray400)
                        .frame(width: 24)
                    TextField("뒤 텍스트", text: $trailing)
                        .textFieldStyle(.roundedBorder)
                }
            }
            .padding(.horizontal, TokenGrid.paddingSide)

            Spacer()
        }
        .padding(.top, TokenSpacing.lg)
        .background(Color.beige200)
        .navigationTitle("SegmentControl")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        ComponentSegmentControlView()
    }
}
