//
//  ComponentPopupView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentPopupView: View {

    @State private var selectedNotice: Int = 0
    @State private var selectedDiamond: Int = 0
    @State private var selectedStore: Int = 0

    private let noticeLabels = ["Notice", "Confirm", "Ad"]
    private let diamondLabels = ["Default", "Ad"]
    private let storeLabels = ["Default", "Ad", "AdDisabled"]

    var body: some View {
        ScrollView {
            VStack(spacing: TokenSpacing.lg) {

                // MARK: - NoticePopup
                VStack(alignment: .leading, spacing: TokenSpacing.sm) {
                    Text("NoticePopup")
                        .font(.headline)
                        .padding(.horizontal, TokenSpacing.lg)

                    Picker("타입", selection: $selectedNotice) {
                        ForEach(0..<noticeLabels.count, id: \.self) { index in
                            Text(noticeLabels[index]).tag(index)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, TokenSpacing.lg)

                    switch selectedNotice {
                    case 0:
                        NoticePopup(
                            type: .default(buttonText: "닫기", action: {}),
                            title: "타이틀",
                            text: "팝업 내용 내용\n내용 내용"
                        )
                    case 1:
                        NoticePopup(
                            type: .confirm(
                                cancelText: "취소",
                                confirmText: "확인",
                                cancelAction: {},
                                confirmAction: {}
                            ),
                            title: "타이틀",
                            text: "팝업 내용 내용\n내용 내용"
                        )
                    default:
                        NoticePopup(
                            type: .ad(
                                cancelText: "취소",
                                adText: "2배 얻기",
                                cancelAction: {},
                                adAction: {}
                            ),
                            title: "타이틀",
                            text: "팝업 내용 내용\n내용 내용"
                        )
                    }
                }

                // MARK: - DiamondPopup
                VStack(alignment: .leading, spacing: TokenSpacing.sm) {
                    Text("DiamondPopup")
                        .font(.headline)
                        .padding(.horizontal, TokenSpacing.lg)

                    Picker("타입", selection: $selectedDiamond) {
                        ForEach(0..<diamondLabels.count, id: \.self) { index in
                            Text(diamondLabels[index]).tag(index)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, TokenSpacing.lg)

                    switch selectedDiamond {
                    case 0:
                        DiamondPopup(
                            type: .default(buttonText: "닫기", action: {}),
                            title: "타이틀",
                            text: "팝업 내용 내용\n내용 내용",
                            diamond: 5
                        )
                    default:
                        DiamondPopup(
                            type: .ad(
                                cancelText: "취소",
                                adText: "2배 얻기",
                                cancelAction: {},
                                adAction: {}
                            ),
                            title: "타이틀",
                            text: "팝업 내용 내용\n내용 내용",
                            diamond: 5
                        )
                    }
                }

                // MARK: - StorePopup
                VStack(alignment: .leading, spacing: TokenSpacing.sm) {
                    Text("StorePopup")
                        .font(.headline)
                        .padding(.horizontal, TokenSpacing.lg)

                    Picker("타입", selection: $selectedStore) {
                        ForEach(0..<storeLabels.count, id: \.self) { index in
                            Text(storeLabels[index]).tag(index)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, TokenSpacing.lg)

                    switch selectedStore {
                    case 0:
                        StorePopup(
                            type: .default(
                                cancelText: "취소",
                                confirmText: "구매",
                                cancelAction: {},
                                confirmAction: {}
                            ),
                            title: "아이템구매",
                            itemName: "[₩2,000,000]을",
                            price: "가격"
                        )
                    case 1:
                        StorePopup(
                            type: .ad(
                                successRate: 70,
                                adState: .default,
                                cancelText: "취소",
                                adText: "확률 UP",
                                confirmText: "구매",
                                cancelAction: {},
                                adAction: {},
                                confirmAction: {}
                            ),
                            title: "아이템구매",
                            itemName: "[₩2,000,000]을",
                            price: "가격"
                        )
                    default:
                        StorePopup(
                            type: .ad(
                                successRate: 100,
                                adState: .disabled,
                                cancelText: "취소",
                                adText: "확률 UP",
                                confirmText: "구매",
                                cancelAction: {},
                                adAction: {},
                                confirmAction: {}
                            ),
                            title: "아이템구매",
                            itemName: "[₩2,000,000]을",
                            price: "가격"
                        )
                    }
                }
            }
            .padding(.vertical, TokenSpacing.lg)
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
