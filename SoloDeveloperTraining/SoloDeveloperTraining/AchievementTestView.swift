//
//  AchievementTestView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-08.
//

import SwiftUI

struct AchievementTestView: View {
    // 시스템 객체들
    @State private var achievementSystem: AchievementSystem
    @State private var record: Record
    @State private var wallet: Wallet

    // UI 상태
    @State private var showAlert = false
    @State private var alertMessage = ""

    init() {
        // 테스트용 업적들 생성
        let achievements = [
            Achievement(
                id: 1,
                title: "첫 걸음",
                description: "탭 10회 달성",
                targetValue: 10,
                updateCondition: { $0.totalTapCount },
                completeCondition: { $0.totalTapCount >= 10 },
                reward: Cost(gold: 50)
            ),
            Achievement(
                id: 2,
                title: "초보 탭퍼",
                description: "탭 100회 달성",
                targetValue: 100,
                updateCondition: { $0.totalTapCount },
                completeCondition: { $0.totalTapCount >= 100 },
                reward: Cost(gold: 100, diamond: 1)
            ),
            Achievement(
                id: 3,
                title: "중급 탭퍼",
                description: "탭 1000회 달성",
                targetValue: 1000,
                updateCondition: { $0.totalTapCount },
                completeCondition: { $0.totalTapCount >= 1000 },
                reward: Cost(gold: 500, diamond: 5)
            ),
            Achievement(
                id: 10001,
                title: "신의 손가락",
                description: "탭 100000회 달성",
                targetValue: 100000,
                updateCondition: { $0.totalTapCount },
                completeCondition: { $0.totalTapCount >= 100000 },
                reward: Cost(diamond: 30)
            )
        ]

        _achievementSystem = State(initialValue: AchievementSystem(allAchievements: achievements))
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

                    // 업적 완료 알림
                    if achievementSystem.hasCompletedAchievement {
                        completionBanner
                    }

                    // 업적 목록
                    achievementsSection
                }
                .padding()
            }
            .navigationTitle("업적 시스템 테스트")
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

            Button {
                resetAll()
            } label: {
                Label("리셋", systemImage: "arrow.counterclockwise")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
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

            Text("완료된 업적이 있습니다!")
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

    // MARK: - Achievements Section
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("업적 목록")
                .font(.title2)
                .bold()

            ForEach(achievementSystem.allAchievements, id: \.id) { achievement in
                AchievementCard(
                    achievement: achievement,
                    onClaim: {
                        claimAchievement(achievement)
                    }
                )
            }
        }
    }

    // MARK: - Actions
    private func performTap(count: Int = 1) {
        record.totalTapCount += count
        achievementSystem.updateCompletedAchievements(record: record)
    }

    private func claimAchievement(_ achievement: Achievement) {
        guard achievement.state == .unclaimed else {
            alertMessage = "수령할 수 없는 업적입니다"
            showAlert = true
            return
        }

        achievementSystem.claimAchievement(achievement: achievement, wallet: wallet)

        var message = "업적 '\(achievement.title)' 보상을 수령했습니다!\n"
        if achievement.reward.gold > 0 {
            message += "골드 +\(achievement.reward.gold)\n"
        }
        if achievement.reward.diamond > 0 {
            message += "다이아몬드 +\(achievement.reward.diamond)"
        }

        alertMessage = message
        showAlert = true
    }

    private func resetAll() {
        record = Record()
        wallet = Wallet()

        // 업적들도 리셋
        for achievement in achievementSystem.allAchievements {
            achievement.state = .inProgress
            achievement.currentValue = 0
        }
        achievementSystem.checkHasCompletedAchievement()

        alertMessage = "모든 데이터가 초기화되었습니다"
        showAlert = true
    }
}

// MARK: - Achievement Card
struct AchievementCard: View {
    let achievement: Achievement
    let onClaim: () -> Void

    private var stateColor: Color {
        switch achievement.state {
        case .inProgress: return .gray
        case .unclaimed: return .green
        case .claimed: return .blue
        }
    }

    private var stateIcon: String {
        switch achievement.state {
        case .inProgress: return "clock.fill"
        case .unclaimed: return "gift.fill"
        case .claimed: return "checkmark.circle.fill"
        }
    }

    private var stateText: String {
        switch achievement.state {
        case .inProgress: return "진행 중"
        case .unclaimed: return "수령 가능"
        case .claimed: return "완료"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(achievement.title)
                        .font(.headline)

                    Text(achievement.description)
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
                    Text("\(achievement.currentValue) / \(achievement.targetValue)")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text("\(Int(achievement.progress * 100))%")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                ProgressView(value: achievement.progress)
                    .tint(stateColor)
            }

            // 보상 표시
            HStack {
                if achievement.reward.gold > 0 {
                    Label("\(achievement.reward.gold)", systemImage: "dollarsign.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.yellow)
                }

                if achievement.reward.diamond > 0 {
                    Label("\(achievement.reward.diamond)", systemImage: "diamond.fill")
                        .font(.caption)
                        .foregroundStyle(.cyan)
                }

                Spacer()

                if achievement.state == .unclaimed {
                    Button {
                        onClaim()
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
    AchievementTestView()
}
