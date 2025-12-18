//
//  ApplyDesignResourceView.swift
//  Prototype
//
//  Created by sunjae on 12/17/25.
//

import SwiftUI
import WebKit
import Lottie

struct ApplyDesignResourceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Description").font(.title).bold()
                Text(
                    "로고나 캐릭터에 필요한 gif, lottie 등 다양한 형태의 디자인 리소스를 가능한 방법으로 적용하고 확인합니다."
                )
                .padding(.bottom, 16)
                Logo()
                Character2D()
                Control2DCharacter()
            }.padding()
        }
    }
}

struct GIFView: UIViewRepresentable {

    enum RenderType {
        case webView // 웹뷰 방식
        case imageSource // 이미지 소스 변환 및 재생 방식
    }

    let gifName: String
    let renderType: RenderType

    func makeUIView(context: Context) -> UIView {
        switch renderType {
        case .webView:
            return makeWebView()
        case .imageSource:
            return makeImageView()
        }
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

private extension GIFView {
    func makeWebView() -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        webView.backgroundColor = .clear

        if let path = Bundle.main.path(forResource: gifName, ofType: "gif") {
            let url = URL(fileURLWithPath: path)
            let data = try? Data(contentsOf: url)

            webView.load(
                data ?? Data(),
                mimeType: "image/gif",
                characterEncodingName: "UTF-8",
                baseURL: url
            )
        }
        return webView
    }

    func makeImageView() -> UIView {
        let container = UIView()
        container.backgroundColor = .clear

        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        // GIF 세팅
        guard
            let url = Bundle.main.url(forResource: gifName, withExtension: "gif"),
            let data = try? Data(contentsOf: url),
            let source = CGImageSourceCreateWithData(data as CFData, nil)
        else { return container }

        let frameCount = CGImageSourceGetCount(source)
        var images: [UIImage] = []

        for index in 0..<frameCount {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, index, nil) {
                images.append(UIImage(cgImage: cgImage))
            }
        }

        imageView.animationImages = images
        imageView.animationDuration = Double(frameCount) * 0.1
        imageView.animationRepeatCount = 0
        imageView.startAnimating()

        return container
    }
}


struct Logo: View {

    enum Option: String, CaseIterable {
        case webViewGIF = "GIF - WebView"
        case imageSourceGIF = "GIF - ImageSource"
        case lottie = "Lottie"
    }

    @State private var selectedLogo: Option = .webViewGIF

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("로고")
                .font(.title)
                .bold()

            Picker("로고 선택", selection: $selectedLogo) {
                ForEach(Option.allCases, id: \.self) { type in
                    Text(type.rawValue)
                }
            }
            .pickerStyle(.segmented)
            Group {
                switch selectedLogo {
                case .webViewGIF:
                    GIFView(gifName: "logogif", renderType: .webView)
                        .frame(width: 200, height: 200)
                case .imageSourceGIF:
                    GIFView(gifName: "logogif", renderType: .imageSource)
                        .frame(width: 200, height: 200)
                case .lottie:
                    LottieView(animation: .named("logolottie"))
                        .playing(loopMode: .playOnce).frame(width: 200, height: 200) // 재생 모드 설정 가능
                }
            }.frame(maxWidth: .infinity)
        }
    }
}

struct Character2D: View {

    enum Option: String, CaseIterable {
        case gif = "GIF"
        case lottie = "Lottie"
    }

    @State private var selectedLogo: Option = .gif

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("캐릭터")
                .font(.title)
                .bold()

            Picker("로고 선택", selection: $selectedLogo) {
                ForEach(Option.allCases, id: \.self) { type in
                    Text(type.rawValue)
                }
            }
            .pickerStyle(.segmented)
            Group {
                switch selectedLogo {
                case .gif:
                    GIFView(gifName: "logogif", renderType: .webView)
                        .frame(width: 200, height: 200)
                case .lottie:
                    LottieView(animation: .named("logolottie"))
                        .playing(loopMode: .playOnce).frame(width: 200, height: 200) // 재생 모드 설정 가능
                }
            }.frame(maxWidth: .infinity)
        }
    }
}

struct Control2DCharacter: View {

    enum LogoType: String, CaseIterable {
        case gif = "GIF"
        case lottie = "Lottie"
    }

    @State private var selectedLogo: LogoType = .gif

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("캐릭터 조작")
                .font(.title)
                .bold()

            Picker("로고 선택", selection: $selectedLogo) {
                ForEach(LogoType.allCases, id: \.self) { type in
                    Text(type.rawValue)
                }
            }
            .pickerStyle(.segmented)
            Group {
                switch selectedLogo {
                case .gif:
                    GIFView(gifName: "logogif", renderType: .webView)
                        .frame(width: 200, height: 200)
                case .lottie:
                    LottieView(animation: .named("logolottie"))
                        .playing(loopMode: .playOnce).frame(width: 200, height: 200) // 재생 모드 설정 가능

                }
            }.frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ApplyDesignResourceView()
}
