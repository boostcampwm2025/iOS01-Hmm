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
        imageView.translatesAutoresizingMaskIntoConstraints = false

        loadGIF(into: imageView)

        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        loadGIF(into: uiView)
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIImageView, context: Context) -> CGSize? {
        guard let image = uiView.image else { return nil }
        guard image.size.width > 0 else { return nil }

        let width = proposal.width ?? UIScreen.main.bounds.width
        let height = width * image.size.height / image.size.width
        return CGSize(width: width, height: height)
    }

    private func loadGIF(into imageView: UIImageView) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard
                let url = DUGIF.bundle.url(forResource: gifName.replacingOccurrences(of: ".gif", with: ""), withExtension: "gif"),
                let animatedGIF = UIImage.animatedGIF(url: url)
            else {
                return
            }

            DispatchQueue.main.async {
                imageView.image = animatedGIF.image

                if onFinished != nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + animatedGIF.duration) {
                        self.onFinished?()
                    }
                }
            }
        }
    }
}
