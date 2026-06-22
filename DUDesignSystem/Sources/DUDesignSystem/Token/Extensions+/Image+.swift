//
//  Image+.swift
//  DUDesignSystem
//
//  Created by 김성훈 on 6/22/26.
//

import SwiftUI

extension Image {
    public static func duImage(_ name: String) -> Image {
        Image(name, bundle: .module)
    }
}
