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
    static let contentVerticalSpacing: CGFloat = 11

    enum Padding {
        static let titleTop: CGFloat = 20
        static let contentBottom: CGFloat = 20
    }
}

struct PopupConfiguration {
    let title: String
    let maxHeight: CGFloat?
    let content: AnyView

    init(
        title: String,
        maxHeight: CGFloat? = nil,
        @ViewBuilder content: () -> some View
    ) {
        self.title = title
        self.maxHeight = maxHeight
        self.content = AnyView(content())
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
        VStack(spacing: Constant.contentVerticalSpacing) {
            Text(title)
                .textStyle(.title3)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, Constant.Padding.titleTop)

            contentView
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

#Preview {
    VStack(spacing: 30) {
        // ViewBuilder를 통한 클로저 방식
        Popup(title: "튜토리얼") {
            VStack(alignment: .leading, spacing: 10) {
                Text("당신은 취직에 실패한 개발자. 이대로 물러설 수는 없다. 나의 꿈은 1인 개발자로 성공하기 ~! 내 이름은!!")
                    .textStyle(.body)
                    .foregroundColor(.black)

                TextField("닉네임", text: .constant(""))
                    .textFieldStyle(.roundedBorder)

                HStack(spacing: 10) {
                    Spacer()
                    MediumButton(title: "바로 시작", isFilled: false) {
                        print("바로 시작")
                    }

                    MediumButton(title: "튜토리얼", isFilled: true) {
                        print("튜토리얼")
                    }
                    Spacer()
                }
            }
        }

        // View 인스턴스를 직접 전달하는 방식
        let customContentView = VStack(alignment: .leading, spacing: 10) {
            Text("팝업 내용 내용 내용 내용 내용 내용 내용 내용 내용 내용 내용")
                .textStyle(.body)
                .foregroundColor(.black)

            HStack(spacing: 10) {
                Spacer()
                MediumButton(title: "취소", isFilled: false) {
                    print("취소")
                }

                MediumButton(title: "확인", isFilled: true) {
                    print("확인")
                }
                Spacer()
            }
        }
        Popup(title: "팝업 타이틀", contentView: customContentView)

        // 간단한 텍스트만 있는 팝업
        Popup(title: "알림") {
            Text("간단한 메시지 팝업입니다.")
                .textStyle(.body)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
