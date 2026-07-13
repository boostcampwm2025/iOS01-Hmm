//
//  ComponentStoryCardView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentStoryCardView: View {

    enum ViewMode: String, CaseIterable {
        case levelUp = "Level Up"
        case ending = "Ending"
        case endingDownload = "Ending(download)"
    }

    @State private var viewMode: ViewMode = .levelUp
    @State private var title: String = "유니콘 에이스"
    @State private var careerName: String = "노트북 보유자"
    @State private var description: String = "당근마켓에서 15만원짜리 중고 노트북을 샀다. 팬 소리가 비행기 이륙 수준이지만 괜찮다. 난 이제 개발자다."

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TokenSpacing.lg) {
                PreviewArea {
                    StoryCard(
                        type: storyCardType,
                        text: description,
                        imageName: viewMode == .levelUp ? "normalDeveloper1" : "geniusHacker"
                    )
                }

                Group {
                    // MARK: - Controls
                    Section("모드") {
                        Picker("모드", selection: $viewMode) {
                            ForEach(ViewMode.allCases, id: \.self) { mode in
                                Text(mode.rawValue).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    if viewMode == .ending {
                        Section("타이틀") {
                            HStack {
                                TextField("타이틀 입력", text: $title)
                                    .background(.white)
                                if !title.isEmpty {
                                    Button { title = "" } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(Color.gray400)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    Section("설명") {
                        HStack {
                            TextField("설명 입력", text: $description)
                                .background(.white)
                            if !description.isEmpty {
                                Button { description = "" } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(Color.gray400)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.beige200)
        .navigationTitle("StoryCard")
    }

    private var storyCardType: StoryCard.StoryCardType {
        switch viewMode {
        case .levelUp:
            return .levelUp
        case .ending:
            return .ending(title: title)
        case .endingDownload:
            return .endingDownload(title: title)
        }
    }
}

#Preview {
    NavigationStack {
        ComponentStoryCardView()
    }
}
