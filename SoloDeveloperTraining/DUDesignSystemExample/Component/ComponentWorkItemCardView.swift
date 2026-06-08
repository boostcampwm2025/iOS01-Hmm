//
//  ComponentWorkItemCardView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentWorkItemCardView: View {

    @State private var selectedState: WorkItemCard.WorkItemCardState = .default

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Preview Area
            PreviewArea {
                WorkItemCard(
                    title: "언어 맞추기",
                    imageName: "work_language",
                    state: selectedState,
                    onTap: {}
                )
                .frame(maxWidth: .infinity, alignment: .center)
            }

            // MARK: - Controls
            List {
                Section("상태") {
                    Picker("상태", selection: $selectedState) {
                        Text("Default").tag(WorkItemCard.WorkItemCardState.default)
                        Text("Selected").tag(WorkItemCard.WorkItemCardState.selected)
                        Text("Locked").tag(WorkItemCard.WorkItemCardState.locked)
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
        .navigationTitle("WorkItemCard")
    }
}

#Preview {
    NavigationStack {
        ComponentWorkItemCardView()
    }
}
