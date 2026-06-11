//
//  ComponentPopupView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentPopupView: View {

    @State private var selectedType: Int = 0

    private let typeLabels = ["Notice", "Confirm", "Reward", "AdBonus", "AdReward", "AdConfirm"]

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Preview Area
            PreviewArea {
                Group {
                    switch selectedType {
                    case 0:
                        Popup(type: .notice(
                            title: "팝업 타이틀",
                            body: "팝업 내용 내용 \n내용 내용",
                            buttonText: "닫기",
                            action: {}
                        ))
                    case 1:
                        Popup(type: .confirm(
                            title: "팝업 타이틀",
                            body: "팝업 내용 내용 내용 내용 내용 내용 내용 내용 내용 내용\n내용 내용",
                            cancelText: "취소",
                            confirmText: "구매",
                            cancelAction: {},
                            confirmAction: {}
                        ))
                    case 2:
                        Popup(type: .reward(
                            title: "팝업 타이틀",
                            body: "팝업 내용 내용 내용 내용 내용 내용 내용 내용 내용 내용\n내용 내용",
                            rewardLeadingText: "획득한 다이아 :",
                            rewardIcon: .diamond,
                            rewardTrailingText: "20",
                            buttonText: "닫기",
                            action: {}
                        ))
                    case 3:
                        Popup(type: .adBonus(
                            title: "보너스",
                            body: "퀴즈 풀이를 완료했습니다!\n진정한 개발자에 한 걸음 더 가까워졌습니다.",
                            rewardLeadingText: "획득한 다이아 : ",
                            rewardIcon: .diamond,
                            rewardTrailingText: "5",
                            cancelText: "취소",
                            adIcon: .ad,
                            adText: "2배 얻기",
                            cancelAction: {},
                            adAction: {}
                        ))
                    case 4:
                        Popup(type: .adReward(
                            title: "타이틀",
                            body: "안녕하세요\n이곳은 팝업 내용을 적는 곳입니다",
                            cancelText: "취소",
                            adIcon: .ad,
                            adText: "2배 얻기",
                            cancelAction: {},
                            adAction: {}
                        ))
                    default:
                        Popup(type: .adConfirm(
                            title: "아이템구매",
                            body: "[₩2,000,000]을 사용하여\n구매하시겠습니까?",
                            subText: "(성공 확률: 70%)",
                            cancelText: "취소",
                            adIcon: .ad,
                            adText: "확률 UP",
                            confirmText: "구매",
                            cancelAction: {},
                            adAction: {},
                            confirmAction: {}
                        ))
                    }
                }
                .frame(maxWidth: .infinity)
            }

            // MARK: - Controls
            List {
                Section("타입") {
                    Picker("타입", selection: $selectedType) {
                        ForEach(0..<typeLabels.count, id: \.self) { index in
                            Text(typeLabels[index]).tag(index)
                        }
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
        .navigationTitle("Popup")
    }
}

#Preview {
    NavigationStack {
        ComponentPopupView()
    }
}
