//
//  Popup.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/16/26.
//

import SwiftUI

private enum Constant {
    static let cornerRadius: CGFloat = 8
    static let lineWidth: CGFloat = 2

    enum Padding {
        static let titleTop: CGFloat = 20
        static let contentTop: CGFloat = 10
        static let contentHorizontal: CGFloat = 20
        static let contentBottom: CGFloat = 20
    }
}

struct Popup<ContentView: View>: View {
    let title: String
    let contentView: ContentView

    // ViewBuilder를 통한 클로저 방식
    init(
        title: String,
        @ViewBuilder contentView: () -> ContentView
    ) {
        self.title = title
        self.contentView = contentView()
    }

    // View 인스턴스를 직접 전달하는 방식
    init(
        title: String,
        contentView: ContentView
    ) {
        self.title = title
        self.contentView = contentView
    }

    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .textStyle(.title3)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, Constant.Padding.titleTop)

            contentView
                .padding(.top, Constant.Padding.contentTop)
                .padding(.horizontal, Constant.Padding.contentHorizontal)
                .padding(.bottom, Constant.Padding.contentBottom)
        }
        .background(Color.white)
        .cornerRadius(Constant.cornerRadius)
        .overlay {
            RoundedRectangle(cornerRadius: Constant.cornerRadius)
                .stroke(Color.black, lineWidth: Constant.lineWidth)
        }
    }
}
