import SwiftUI
import UIKit
import DUDesignSystem
import ImageIO

struct GIFView: UIViewRepresentable {
    let gifName: String
    var onFinished: (() -> Void)?

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit

        if let duration = loadGIF(into: imageView) {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                onFinished?()
            }
        }

        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {}

    // SwiftUI 상위 뷰에서 지정한 사이즈 적용
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIImageView, context: Context) -> CGSize? {
        guard let image = uiView.image else { return nil }

        let imageSize = image.size
        guard imageSize.width > 0 else { return nil }

        let width = proposal.width ?? UIScreen.main.bounds.width
        let height = width * imageSize.height / imageSize.width
        return CGSize(width: width, height: height)
    }

    private func loadGIF(into imageView: UIImageView) -> TimeInterval? {
        guard
            let url = DUGIF.bundle.url(
                forResource: gifName.replacingOccurrences(of: ".gif", with: ""),
                withExtension: "gif"
            ),
            let animatedGIF = UIImage.animatedGIF(url: url)
        else {
            imageView.image = nil
            return nil
        }

        imageView.image = animatedGIF.image
        return animatedGIF.duration
    }
}
