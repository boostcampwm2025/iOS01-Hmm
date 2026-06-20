//
//  UIImage+.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 6/21/26.
//

import UIKit

extension UIImage {
    static func animatedGIF(url: URL) -> UIImage? {
        guard let data = try? Data(contentsOf: url) else { return nil }

        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }

        let frameCount = CGImageSourceGetCount(source)
        guard frameCount > 0 else { return nil }

        var frames: [UIImage] = []
        frames.reserveCapacity(frameCount)
        var totalDuration: TimeInterval = 0

        for index in 0..<frameCount {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, index, nil) else { continue }
            frames.append(UIImage(cgImage: cgImage))
            totalDuration += frameDuration(source: source, index: index)
        }

        guard !frames.isEmpty else { return nil }

        if totalDuration <= 0 {
            totalDuration = 0.1 * Double(frameCount)
        }

        return UIImage.animatedImage(with: frames, duration: totalDuration)
    }

    private static func frameDuration(source: CGImageSource, index: Int) -> TimeInterval {
        let defaultDelay = 0.1

        guard
            let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [CFString: Any],
            let gifProperties = properties[kCGImagePropertyGIFDictionary] as? [CFString: Any]
        else {
            return defaultDelay
        }

        let unclamped = gifProperties[kCGImagePropertyGIFUnclampedDelayTime] as? Double
        let clamped = gifProperties[kCGImagePropertyGIFDelayTime] as? Double
        let delay = unclamped ?? clamped ?? defaultDelay

        return delay < 0.011 ? 0.1 : delay
    }
}
