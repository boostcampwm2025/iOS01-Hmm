//
//  LevelUpEffectManager.swift
//  SoloDeveloperTraining
//

import SwiftUI
import UIKit

@MainActor
final class LevelUpEffectManager {
    static let shared = LevelUpEffectManager()
    private init() {}

    private var levelUpWindow: UIWindow?

    func show(
        previousCareerTitle: String,
        currentCareerTitle: String,
        onDismiss: @escaping () -> Void
    ) {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive })
        else { return }

        dismiss()

        let window = UIWindow(windowScene: windowScene)
        window.windowLevel = .normal + 1
        window.backgroundColor = .clear

        let view = LevelUpEffectView(
            onDismiss: { [weak self] in
                self?.dismiss()
                onDismiss()
            },
            previousCareerTitle: previousCareerTitle,
            currentCareerTitle: currentCareerTitle
        )
        let hostingController = UIHostingController(rootView: view)
        hostingController.view.backgroundColor = .clear
        window.rootViewController = hostingController
        window.alpha = 0
        window.isHidden = false
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
            window.alpha = 1
        }
        levelUpWindow = window
    }

    func dismiss() {
        let windowToHide = levelUpWindow
        levelUpWindow = nil
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
            windowToHide?.alpha = 0
        } completion: { _ in
            windowToHide?.isHidden = true
        }
    }
}
