//
//  ComponentCareerRowView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentCareerRowView: View {

    @State private var selectedState: CareerRow.CareerRowState = .achieved

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Preview Area
            PreviewArea {
                CareerRow(
                    imageName: "",
                    title: "백수",
                    description: "아직 아무것도 시작하지 않았지만, 시간은 가장 많다",
                    state: selectedState
                )
                .frame(maxWidth: .infinity, alignment: .center)
            }

            // MARK: - Controls
            List {
                Section("상태") {
                    Picker("상태", selection: $selectedState) {
                        Text("Achieved").tag(CareerRow.CareerRowState.achieved)
                        Text("Current").tag(CareerRow.CareerRowState.current)
                        Text("Upcoming").tag(CareerRow.CareerRowState.upcoming)
                    }
                    .pickerStyle(.segmented)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

                Section {
                    Text("상태 변경이나 유효성 검사는 비즈니스 로직이므로 예시 앱에는 반영되지 않아요.")
                        .font(.caption)
                        .foregroundStyle(Color.gray400)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .background(Color.beige200)
        .navigationTitle("CareerRow")
    }
}

#Preview {
    NavigationStack {
        ComponentCareerRowView()
    }
}
