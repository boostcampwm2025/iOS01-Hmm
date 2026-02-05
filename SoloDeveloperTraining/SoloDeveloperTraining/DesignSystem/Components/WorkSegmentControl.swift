//
//  WorkSegmentControl.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/14/26.
//

import SwiftUI

private enum Constant {
    static let itemSpacing: CGFloat = 2
}

struct WorkSegmentControl: View {
    let items: [WorkItem]
    var onLockedTap: ((Career) -> Void)?
    @Binding var selectedIndex: Int

    var body: some View {
        HStack(spacing: Constant.itemSpacing) {
            ForEach(items.indices, id: \.self) { index in
                WorkItemButton(
                    title: items[index].title,
                    imageName: items[index].imageName,
                    buttonState: .constant(buttonState(for: index)),
                    onTap: {
                        handleTap(at: index)
                    }
                )
                .overlay {
                    if items[index].isDisabled {
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture {
                                handleLockedTap(at: index)
                            }
                    }
                }
            }
        }
    }
}

private extension WorkSegmentControl {
    func handleTap(at index: Int) {
        guard !items[index].isDisabled else { return }
        selectedIndex = index
    }

    func handleLockedTap(at index: Int) {
        guard let requiredCareer = items[index].requiredCareer else { return }
        onLockedTap?(requiredCareer)
    }

    func buttonState(for index: Int) -> WorkItemButton.ButtonState {
        if items[index].isDisabled {
            return .disabled
        } else if selectedIndex == index {
            return .focused
        } else {
            return .normal
        }
    }
}

struct WorkItem {
    let title: String
    let imageName: String
    let isDisabled: Bool
    let requiredCareer: Career?

    init(
        title: String,
        imageName: String,
        isDisabled: Bool = false,
        requiredCareer: Career? = nil
    ) {
        self.title = title
        self.imageName = imageName
        self.isDisabled = isDisabled
        self.requiredCareer = requiredCareer
    }
}

#Preview {
    @Previewable @State var selectedIndex: Int = 0

    VStack(spacing: 20) {
        Text("Selected Index: \(selectedIndex)")
            .textStyle(.headline)

        WorkSegmentControl(
            items: [
                WorkItem(
                    title: "테스트",
                    imageName: GameType.tap.imageName
                ),
                WorkItem(
                    title: "테스트",
                    imageName: GameType.tap.imageName
                ),
                WorkItem(
                    title: "테스트",
                    imageName: GameType.tap.imageName,
                    isDisabled: true
                ),
                WorkItem(
                    title: "테스트",
                    imageName: GameType.tap.imageName,
                    isDisabled: false
                )
            ],
            selectedIndex: $selectedIndex
        )
    }
    .padding()
}
