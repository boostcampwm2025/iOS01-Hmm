//
//  Toast.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/7/26.
//

import SwiftUI
import UIKit

// MARK: - Content View

private struct ToastContentView: View {
    let message: String

    var body: some View {
        ItemLabel(text: message, font: .body2, color: .white300)
            .frame(maxWidth: .infinity)
            .padding(.vertical, TokenSpacing.mm)
            .background(
                LinearGradient(
                    stops: [
                        .init(color: Color.black300.opacity(0.2), location: 0),
                        .init(color: Color.black300.opacity(0.7), location: 0.5),
                        .init(color: Color.black300.opacity(0.2), location: 1)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
    }
}

// MARK: - Toast Manager
@MainActor
public final class ToastManager {
    public static let shared = ToastManager()
    private init() {}

    /// 탭바 상단 기준 앵커. 앱 시작 후 탭바가 레이아웃되면 한 번 세팅.
    public static var anchorY: CGFloat = 0

    private var activeController: UIHostingController<ToastContentView>?
    private var dismissWorkItem: DispatchWorkItem?

    @MainActor
    public func show(_ message: String) {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive })?
            .keyWindow
        else { return }

        // 기존 토스트 즉시 제거
        dismissWorkItem?.cancel()
        dismissWorkItem = nil
        if let previous = activeController {
            previous.view.removeFromSuperview()
            activeController = nil
        }

        let hostingController = UIHostingController(rootView: ToastContentView(message: message))
        activeController = hostingController

        let contentView = hostingController.view!
        contentView.backgroundColor = .clear
        contentView.isUserInteractionEnabled = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.alpha = 0

        window.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: window.topAnchor, constant: ToastManager.anchorY)
        ])
        window.layoutIfNeeded()

        UIView.animate(withDuration: 0.3) {
            contentView.alpha = 1
        }

        let workItem = DispatchWorkItem { [weak self, weak hostingController] in
            guard let self, let hostingController else { return }
            UIView.animate(withDuration: 0.3) {
                hostingController.view.alpha = 0
            } completion: { _ in
                hostingController.view.removeFromSuperview()
                if self.activeController === hostingController {
                    self.activeController = nil
                }
            }
        }
        dismissWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: workItem)
    }
}
