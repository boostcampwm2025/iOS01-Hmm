//
//  PhotoLibraryService.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 6/14/26.
//

import UIKit
import Photos

enum PhotoLibraryService {
    private static func requestPhotoPermission(
        completion: @escaping (Bool) -> Void
    ) {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            DispatchQueue.main.async {
                completion(status == .authorized || status == .limited)
            }
        }
    }

    static func saveImageToPhotoLibrary(
        _ image: UIImage,
        completion: @escaping (Bool) -> Void
    ) {
        requestPhotoPermission { granted in
            guard granted else {
                completion(false)
                return
            }

            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            } completionHandler: { success, _ in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        }
    }
}
