//
//  ApplyDesignResourceView.swift
//  Prototype
//
//  Created by sunjae on 12/17/25.
//

import SwiftUI
import WebKit
import Lottie
import SpriteKit
import RealityKit
import Combine

struct ApplyDesignResourceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Description").font(.title2)
                Text(
                    "로고나 캐릭터에 필요한 gif, lottie 등 다양한 형태의 디자인 리소스를 가능한 방법으로 적용하고 확인합니다."
                )
                Divider()
                .padding(.bottom, 16)
                VStack(spacing: 16) {
                    Logo()
                    Character2D()
                    Character3D()
                }
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

final class CharacterScene: SKScene {

    private let character = SKSpriteNode(imageNamed: "character_idle")
    private var isJumping = false

    override func didMove(to view: SKView) {
        backgroundColor = .clear
        size = view.bounds.size
        scaleMode = .resizeFill

        character.position = CGPoint(x: size.width / 2, y: size.height / 2)
        character.size = CGSize(width: 200, height: 200)
        addChild(character)

        idleAnimation()
    }

    // 기본 상태 (눈 깜빡이며 숨 쉬기)
    func idleAnimation() {
        character.removeAction(forKey: "idle")

        let inhaleTexture = SKAction.run {
            self.character.texture = SKTexture(imageNamed: "character_idle")
        }

        let exhaleTexture = SKAction.run {
            self.character.texture = SKTexture(imageNamed: "character_close")
        }

        let scaleUp = SKAction.scale(to: 1.05, duration: 0.6)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.2)

        let inhale = SKAction.sequence([inhaleTexture, scaleUp])
        let exhale = SKAction.sequence([exhaleTexture, scaleDown])

        let breathing = SKAction.sequence([inhale, exhale])

        character.run(.repeatForever(breathing), withKey: "idle")
    }

    // 특정 상황: 터치하면 점프하며 웃기
    func smileAnimation() {
        character.removeAllActions()

        self.character.texture = SKTexture(imageNamed: "character_smile" )

        let jump = SKAction.moveBy(x: 0, y: 12, duration: 0.15)
        let down = SKAction.moveBy(x: 0, y: -12, duration: 0.15)
        let keepSmile = SKAction.wait(forDuration: 0.15)
        let bounce = SKAction.sequence([jump, down, keepSmile])

        character.run(.repeat(bounce, count: 1)) {
            self.isJumping = false
            self.idleAnimation()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isJumping { return }
        self.isJumping = true
        smileAnimation()
    }
}

struct SpriteCharacterView: View {
    var body: some View {
        VStack {
            Text("* 터치하면 점프합니다.")
            SpriteView(
                scene: CharacterScene(),
                options: [.allowsTransparency]
            )
            .frame(width: 200, height: 200)
        }
    }
}

struct RealityControlView: View {
    @StateObject private var viewModel = Character3DViewModel()

    var body: some View {
        RealityCharacterView(viewModel: viewModel)
            .frame(width: 200, height: 200)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        viewModel.dragOffset = value.translation
                    }
            )
    }
}

final class Character3DViewModel: ObservableObject {
    @Published var dragOffset: CGSize = .zero
}

struct RealityCharacterView: UIViewRepresentable {
    @ObservedObject var viewModel: Character3DViewModel

    func makeUIView(context: Context) -> ARView {
        let view = ARView(frame: .zero)
        view.environment.background = .color(.clear)

        let character = try! Entity.load(named: "sample_character_3D")
        character.generateCollisionShapes(recursive: true)

        // 사이즈 자동 맞춤
        let bounds = character.visualBounds(relativeTo: nil)
        let size = bounds.extents
        let maxDimension = max(size.x, size.y, size.z)
        let targetSize: Float = 0.4
        let scale = targetSize / maxDimension
        character.scale = SIMD3<Float>(repeating: scale)

        let anchor = AnchorEntity(world: .zero)
        anchor.addChild(character)
        view.scene.addAnchor(anchor)

        context.coordinator.character = character

        return view
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        guard let character = context.coordinator.character else { return }
        let offset = viewModel.dragOffset
        character.position.x = Float(offset.width) * 0.001
        character.position.y = Float(-offset.height) * 0.001
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator {
        var character: Entity?
        var viewModel: Character3DViewModel?
    }
}

// MARK: - 로고
struct Logo: View {

    enum Option: String, CaseIterable {
        case webViewGIF = "GIF - WebView"
        case imageSourceGIF = "GIF - ImageSource"
        case lottie = "Lottie"
    }

    @State private var selectedOption: Option = .webViewGIF

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("로고")
                .font(.title)
                .bold()

            Picker("방법 선택", selection: $selectedOption) {
                ForEach(Option.allCases, id: \.self) { type in
                    Text(type.rawValue)
                }
            }
            .pickerStyle(.segmented)
            Group {
                switch selectedOption {
                case .webViewGIF:
                    GIFView(gifName: "logo_gif", renderType: .webView)
                        .frame(width: 200, height: 200)
                case .imageSourceGIF:
                    GIFView(gifName: "logo_gif", renderType: .imageSource)
                        .frame(width: 200, height: 200)
                case .lottie:
                    LottieView(animation: .named("logo_lottie"))
                        .playing(loopMode: .playOnce).frame(width: 200, height: 200) // 재생 모드 설정 가능
                }
            }.frame(maxWidth: .infinity)
                .background(Color.white)
        }
    }
}

// MARK: - 2D캐릭터 표시 및 제어
struct Character2D: View {

    enum Option: String, CaseIterable {
        case gif = "GIF"
        case lottie = "Lottie"
        case spriteKit = "SpriteKit"
    }

    @State private var selectedOption: Option = .gif

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("2D캐릭터")
                .font(.title)
                .bold()

            Picker("방법 선택", selection: $selectedOption) {
                ForEach(Option.allCases, id: \.self) { type in
                    Text(type.rawValue)
                }
            }
            .pickerStyle(.segmented)
            Group {
                switch selectedOption {
                case .gif:
                    GIFView(gifName: "character_blink_gif", renderType: .webView)
                        .frame(width: 200, height: 200)
                case .lottie:
                    LottieView(animation: .named("character_smile_lottie"))
                        .playing(loopMode: .loop).frame(width: 200, height: 200) // 재생 모드 설정 가능
                case .spriteKit:
                    SpriteCharacterView()
                }
            }.frame(maxWidth: .infinity)
        }
    }
}

// MARK: - 3D캐릭터 표시 및 제어
struct Character3D: View {

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("3D캐릭터")
                .font(.title)
                .bold()
            Text("* 드래그 시 이동합니다.")
            RealityControlView()
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ApplyDesignResourceView()
}
