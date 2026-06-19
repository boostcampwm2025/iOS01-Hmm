//
//  Image+.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/19/26.
//

import SwiftUI

extension Image {
    public static func duImage(_ name: String) -> Image {
        Image(name, bundle: .module)
    }
}
