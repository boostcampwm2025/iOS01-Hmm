//
//  PhotoLibraryService.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 6/14/26.
//

import UIKit
import Photos

enum PhotoLibraryService {
    static var authorizationStatus: PHAuthorizationStatus {
        PHPhotoLibrary.authorizationStatus(for: .addOnly)
    }

    static func requestPhotoPermission(
        completion: @escaping (Bool) -> Void
    ) {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            DispatchQueue.main.async {
                completion(
                    status == .authorized ||
                    status == .limited
                )
            }
        }
    }

    static func saveImageToPhotoLibrary(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(
            image,
            nil,
            nil,
            nil
        )
    }
}


