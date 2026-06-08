//
//  ComponentPopupView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentPopupView: View {

    @State private var selectedType: Int = 0

    private let typeLabels = ["Notice", "Confirm", "Reward"]

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
                    default:
                        Popup(type: .reward(
                            title: "팝업 타이틀",
                            body: "팝업 내용 내용 내용 내용 내용 내용 내용 내용 내용 내용\n내용 내용",
                            rewardLeadingText: "직득한 다이아 : ",
                            rewardIcon: .diamond,
                            rewardTrailingText: "20",
                            buttonText: "닫기",
                            action: {}
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
