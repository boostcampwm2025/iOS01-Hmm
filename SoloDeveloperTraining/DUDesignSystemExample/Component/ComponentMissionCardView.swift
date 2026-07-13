//
//  ComponentMissionCardView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentMissionCardView: View {

    @State private var selectedState: Int = 0
    @State private var selectedTrophy: MissionCard.MissionTrophyType = .gold
    @State private var current: Int = 0
    @State private var total: Int = 10000

    private let stateLabels = ["Default", "InProgress", "Claimable", "Claimed"]

    private var cardState: MissionCard.MissionCardState {
        switch selectedState {
        case 0: return .default(current: current, total: total)
        case 1: return .inProgress(current: current, total: total)
        case 2: return .claimable
        default: return .claimed
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Preview Area
            PreviewArea {
                MissionCard(
                    title: "탭따구리",
                    goldRewardText: "10,000",
                    diamondRewardText: "20",
                    trophy: selectedTrophy,
                    condition: "탭 10,000회 달성",
                    state: cardState,
                    action: {}
                )
                .frame(maxWidth: .infinity, alignment: .center)
            }

            // MARK: - Controls
            List {
                Section("상태") {
                    Picker("상태", selection: $selectedState) {
                        ForEach(0..<stateLabels.count, id: \.self) { index in
                            Text(stateLabels[index]).tag(index)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

                Section("트로피") {
                    Picker("트로피", selection: $selectedTrophy) {
                        Text("Gold").tag(MissionCard.MissionTrophyType.gold)
                        Text("Silver").tag(MissionCard.MissionTrophyType.silver)
                        Text("Bronze").tag(MissionCard.MissionTrophyType.bronze)
                        Text("Special").tag(MissionCard.MissionTrophyType.special)
                    }
                    .pickerStyle(.segmented)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

                if selectedState < 2 {
                    Section("진행도") {
                        Stepper("현재: \(current)", value: $current, in: 0...total, step: 100)
                        Stepper("전체: \(total)", value: $total, in: 1...99999, step: 1000)
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
        .navigationTitle("MissionCard")
    }
}

#Preview {
    NavigationStack {
        ComponentMissionCardView()
    }
}
