//
//  MissionTestView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-08.
//

import SwiftUI

// swiftlint:disable type_body_length

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

                    // 언어 맞추기 섹션
                    languageGameSection

                    // 버그 피하기 섹션
                    bugDodgeSection

                    // 데이터 쌓기 섹션
                    stackingGameSection

                    // 소비 아이템 섹션
                    consumableSection

                    // 특수 달성 섹션
                    specialAchievementSection

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

    // MARK: - Language Game Section
    private var languageGameSection: some View {
        VStack(spacing: 15) {
            Text("언어 맞추기 게임")
                .font(.headline)

            HStack {
                VStack {
                    Text("정답 횟수")
                        .font(.caption)
                    Text("\(record.languageCorrectCount)")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.green)
                }

                Spacer()

                VStack {
                    Text("연속 정답")
                        .font(.caption)
                    Text("\(record.languageConsecutiveCorrect)")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.orange)
                }
            }
            .padding(.vertical, 5)

            HStack(spacing: 15) {
                Button {
                    performLanguageCorrect()
                } label: {
                    Label("정답", systemImage: "checkmark.circle.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }

                Button {
                    performLanguageIncorrect()
                } label: {
                    Label("오답 (리셋)", systemImage: "xmark.circle.fill")
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

    // MARK: - Bug Dodge Section
    private var bugDodgeSection: some View {
        VStack(spacing: 15) {
            Text("버그 피하기 게임")
                .font(.headline)

            HStack {
                VStack {
                    Text("골드 획득")
                        .font(.caption)
                    Text("\(record.goldHitCount)")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.yellow)
                }

                Spacer()

                VStack {
                    Text("연속 성공")
                        .font(.caption)
                    Text("\(record.dodgeConsecutiveSuccess)")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.cyan)
                }
            }
            .padding(.vertical, 5)

            HStack(spacing: 15) {
                Button {
                    performDodgeGoldHit()
                } label: {
                    Label("골드 획득 (성공)", systemImage: "checkmark.circle.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundStyle(.black)
                        .cornerRadius(10)
                }

                Button {
                    performDodgeGoldHit(count: 100)
                } label: {
                    Label("골드 +100", systemImage: "bolt.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }
            }

            HStack(spacing: 15) {
                Button {
                    performDodgeFail()
                } label: {
                    Label("버그 충돌 (실패)", systemImage: "xmark.circle.fill")
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

    // MARK: - Stacking Game Section
    private var stackingGameSection: some View {
        VStack(spacing: 15) {
            Text("데이터 쌓기 게임")
                .font(.headline)

            HStack {
                VStack {
                    Text("성공 횟수")
                        .font(.caption)
                    Text("\(record.stackingSuccessCount)")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.purple)
                }

                Spacer()

                VStack {
                    Text("연속 성공")
                        .font(.caption)
                    Text("\(record.stackConsecutiveSuccess)")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.indigo)
                }
            }
            .padding(.vertical, 5)

            HStack(spacing: 15) {
                Button {
                    performStackingSuccess()
                } label: {
                    Label("성공 +1", systemImage: "checkmark.circle.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }

                Button {
                    performStackingSuccess(count: 10)
                } label: {
                    Label("성공 +10", systemImage: "bolt.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.indigo)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }
            }

            HStack(spacing: 15) {
                Button {
                    performStackingFail()
                } label: {
                    Label("실패 (리셋)", systemImage: "xmark.circle.fill")
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

    // MARK: - Consumable Section
    private var consumableSection: some View {
        VStack(spacing: 15) {
            Text("소비 아이템")
                .font(.headline)

            HStack {
                VStack {
                    Text("커피")
                        .font(.caption)
                    Text("\(record.coffeeUseCount)")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.brown)
                }

                Spacer()

                VStack {
                    Text("박하스")
                        .font(.caption)
                    Text("\(record.energyDrinkUseCount)")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.mint)
                }
            }
            .padding(.vertical, 5)

            HStack(spacing: 15) {
                Button {
                    performCoffeeUse()
                } label: {
                    Label("커피 +1", systemImage: "cup.and.saucer.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brown)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }

                Button {
                    performCoffeeUse(count: 10)
                } label: {
                    Label("커피 +10", systemImage: "bolt.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brown.opacity(0.7))
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }
            }

            HStack(spacing: 15) {
                Button {
                    performEnergyDrinkUse()
                } label: {
                    Label("박하스 +1", systemImage: "bolt.circle.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.mint)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }

                Button {
                    performEnergyDrinkUse(count: 10)
                } label: {
                    Label("박하스 +10", systemImage: "bolt.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.mint.opacity(0.7))
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

    // MARK: - Special Achievement Section
    private var specialAchievementSection: some View {
        VStack(spacing: 15) {
            Text("특수 달성")
                .font(.headline)

            HStack {
                VStack {
                    Text("튜토리얼")
                        .font(.caption)
                    Text(record.tutorialCompleted ? "완료" : "미완료")
                        .font(.caption)
                        .bold()
                        .foregroundStyle(record.tutorialCompleted ? .green : .gray)
                }

                Spacer()

                VStack {
                    Text("하찮은 개발자")
                        .font(.caption)
                    Text(record.hasAchievedJuniorDeveloper ? "달성" : "미달성")
                        .font(.caption)
                        .bold()
                        .foregroundStyle(record.hasAchievedJuniorDeveloper ? .green : .gray)
                }
            }
            .padding(.vertical, 5)

            HStack(spacing: 15) {
                Button {
                    performTutorialComplete()
                } label: {
                    Label("튜토리얼 완료", systemImage: "graduationcap.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }
                .disabled(record.tutorialCompleted)

                Button {
                    performCareerAchieve()
                } label: {
                    Label("커리어 달성", systemImage: "star.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }
                .disabled(record.hasAchievedJuniorDeveloper)
            }

            HStack(spacing: 15) {
                Button {
                    addPlayTime(hours: 1)
                } label: {
                    Label("플레이타임 +1시간", systemImage: "clock.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.teal)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }

                Button {
                    addPlayTime(hours: 10)
                } label: {
                    Label("플레이타임 +10시간", systemImage: "clock.arrow.circlepath")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.teal.opacity(0.7))
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("총 플레이 시간")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(Int(record.totalPlayTime / 3600))시간")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.teal)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
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
        record.record(.tap(count: count))
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

    private func performLanguageCorrect() {
        record.record(.languageCorrect)
        missionSystem.updateCompletedMissions(record: record)
    }

    private func performLanguageIncorrect() {
        record.record(.languageIncorrect)
        missionSystem.updateCompletedMissions(record: record)
    }

    private func performDodgeGoldHit(count: Int = 1) {
        for _ in 0..<count {
            record.record(.dodgeGoldHit)
        }
        missionSystem.updateCompletedMissions(record: record)
    }

    private func performDodgeFail() {
        record.record(.dodgeFail)
        missionSystem.updateCompletedMissions(record: record)
    }

    private func performStackingSuccess(count: Int = 1) {
        for _ in 0..<count {
            record.record(.stackingSuccess)
        }
        missionSystem.updateCompletedMissions(record: record)
    }

    private func performStackingFail() {
        record.record(.stackingFail)
        missionSystem.updateCompletedMissions(record: record)
    }

    private func performCoffeeUse(count: Int = 1) {
        for _ in 0..<count {
            record.record(.coffeeUse)
        }
        missionSystem.updateCompletedMissions(record: record)
    }

    private func performEnergyDrinkUse(count: Int = 1) {
        for _ in 0..<count {
            record.record(.energyDrinkUse)
        }
        missionSystem.updateCompletedMissions(record: record)
    }

    private func performTutorialComplete() {
        record.record(.tutorialComplete)
        missionSystem.updateCompletedMissions(record: record)
    }

    private func performCareerAchieve() {
        record.record(.juniorDeveloperAchieve)
        missionSystem.updateCompletedMissions(record: record)
    }

    private func addPlayTime(hours: Int) {
        let seconds = TimeInterval(hours * 3600)
        record.record(.playTime(tapGame: seconds))
        missionSystem.updateCompletedMissions(record: record)
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
