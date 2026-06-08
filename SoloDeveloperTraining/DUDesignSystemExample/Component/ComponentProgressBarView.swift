//
//  ComponentProgressBarView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentProgressBarView: View {

    @State private var selectedType: Int = 0
    @State private var progress: Double = 0.6

    private let typeLabels = ["Default", "Career", "Mission", "Time"]

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Preview Area
            PreviewArea {
                Group {
                    switch selectedType {
                    case 0:
                        ProgressBar(progress: progress)

                    case 1:
                        ProgressBar(progress: progress, type: .career(
                            currentText: "20,000",
                            currentSubText: "누적",
                            goalText: "20,000",
                            goalSubText: "개발자 지망생"
                        ))

                    case 2:
                        ProgressBar(progress: progress, type: .mission(current: Int(progress * 10), total: 10))

                    default:
                        ProgressBar(progress: progress, type: .time(
                            currentStep: 1,
                            totalStep: 3,
                            timeText: progress > 0 ? "남은 시간 \(Int(progress * 60))s" : "제한 시간 종료"
                        ))
                    }
                }
                .padding(.horizontal, TokenSpacing.lg)
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

                Section("진행도") {
                    Slider(value: $progress, in: 0...1)
                    Text("\(Int(progress * 100))%")
                        .foregroundStyle(Color.gray400)
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
        .navigationTitle("ProgressBar")
    }
}

#Preview {
    NavigationStack {
        ComponentProgressBarView()
    }
}
