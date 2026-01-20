//
//  MissionTestView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-08.
//

import SwiftUI

struct MissionTestView: View {
    // 시스템 객체들
    @State private var missionSystem: MissionSystem
    @State private var record: Record
    @State private var wallet: Wallet

    // UI 상태
    @State private var showAlert = false
    @State private var alertMessage = ""

    init() {
        // 팩토리를 사용하여 전체 미션 목록 생성
        let missions = MissionFactory.createAllMissions()

        _missionSystem = State(initialValue: MissionSystem(missions: missions))
        _record = State(initialValue: Record())
        _wallet = State(initialValue: Wallet())
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 상단: 재화 표시
                    walletSection

                    // 탭 카운터 섹션
                    tapCounterSection

                    // 미션 완료 알림
                    if missionSystem.hasCompletedMission {
                        completionBanner
                    }

                    // 미션 목록
                    missionsSection
                }
                .padding()
            }
            .navigationTitle("미션 시스템 테스트")
            .alert("알림", isPresented: $showAlert) {
                Button("확인", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }

    // MARK: - Wallet Section
    private var walletSection: some View {
        HStack(spacing: 30) {
            VStack {
                Image(systemName: "dollarsign.circle.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.yellow)
                Text("골드")
                    .font(.caption)
                Text("\(wallet.gold)")
                    .font(.title2)
                    .bold()
            }

            VStack {
                Image(systemName: "diamond.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.cyan)
                Text("다이아몬드")
                    .font(.caption)
                Text("\(wallet.diamond)")
                    .font(.title2)
                    .bold()
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.background)
                .shadow(color: .black.opacity(0.1), radius: 5)
        )
    }

    // MARK: - Tap Counter Section
    private var tapCounterSection: some View {
        VStack(spacing: 15) {
            Text("총 탭 횟수")
                .font(.headline)

            Text("\(record.totalTapCount)")
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(.blue)

            HStack(spacing: 15) {
                Button {
                    performTap()
                } label: {
                    Label("탭 +1", systemImage: "hand.tap.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }

                Button {
                    performTap(count: 10)
                } label: {
                    Label("탭 +10", systemImage: "hand.tap.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }
            }

            HStack(spacing: 15) {
                Button {
                    performTap(count: 100)
                } label: {
                    Label("탭 +100", systemImage: "bolt.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }

                Button {
                    performTap(count: 1000)
                } label: {
                    Label("탭 +1000", systemImage: "bolt.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }
            }

        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.background)
                .shadow(color: .black.opacity(0.1), radius: 5)
        )
    }

    // MARK: - Completion Banner
    private var completionBanner: some View {
        HStack {
            Image(systemName: "trophy.fill")
                .font(.title)
                .foregroundStyle(.yellow)

            Text("완료된 미션이 있습니다!")
                .font(.headline)

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.yellow.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.yellow, lineWidth: 2)
                )
        )
    }

    // MARK: - Missions Section
    private var missionsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("미션 목록")
                .font(.title2)
                .bold()

            ForEach(missionSystem.missions, id: \.id) { mission in
                MissionCardTest(
                    mission: mission,
                    onAcquire: {
                        acquireMission(mission)
                    }
                )
            }
        }
    }

    // MARK: - Actions
    private func performTap(count: Int = 1) {
        record.totalTapCount += count
        missionSystem.updateCompletedMissions(record: record)
    }

    private func acquireMission(_ mission: Mission) {
        guard mission.state == .claimable else {
            alertMessage = "수령할 수 없는 업적입니다"
            showAlert = true
            return
        }

        missionSystem.claimMissionReward(mission: mission, wallet: wallet)

        var message = "미션 '\(mission.title)' 보상을 수령했습니다!\n"
        if mission.reward.gold > 0 {
            message += "골드 +\(mission.reward.gold)\n"
        }
        if mission.reward.diamond > 0 {
            message += "다이아몬드 +\(mission.reward.diamond)"
        }

        alertMessage = message
        showAlert = true
    }
}

// MARK: - Mission Card
struct MissionCardTest: View {
    let mission: Mission
    let onAcquire: () -> Void

    private var stateColor: Color {
        switch mission.state {
        case .inProgress: return .gray
        case .claimable: return .green
        case .claimed: return .blue
        }
    }

    private var stateIcon: String {
        switch mission.state {
        case .inProgress: return "clock.fill"
        case .claimable: return "gift.fill"
        case .claimed: return "checkmark.circle.fill"
        }
    }

    private var stateText: String {
        switch mission.state {
        case .inProgress: return "진행 중"
        case .claimable: return "수령 가능"
        case .claimed: return "완료"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(mission.title)
                        .font(.headline)

                    Text(mission.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack {
                    Image(systemName: stateIcon)
                        .font(.title2)
                        .foregroundStyle(stateColor)

                    Text(stateText)
                        .font(.caption2)
                        .foregroundStyle(stateColor)
                }
            }

            // 진행도 바
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(mission.currentValue) / \(mission.targetValue)")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text("\(Int(mission.progress * 100))%")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                ProgressView(value: mission.progress)
                    .tint(stateColor)
            }

            // 보상 표시
            HStack {
                if mission.reward.gold > 0 {
                    Label("\(mission.reward.gold)", systemImage: "dollarsign.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.yellow)
                }

                if mission.reward.diamond > 0 {
                    Label("\(mission.reward.diamond)", systemImage: "diamond.fill")
                        .font(.caption)
                        .foregroundStyle(.cyan)
                }

                Spacer()

                if mission.state == .claimable {
                    Button {
                        onAcquire()
                    } label: {
                        Text("수령")
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.green)
                            .foregroundStyle(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.background)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(stateColor.opacity(0.3), lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.05), radius: 3)
        )
    }
}

// MARK: - Preview
#Preview {
    MissionTestView()
}
