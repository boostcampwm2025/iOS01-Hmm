//
//  PopupManager.swift
//  DUDesignSystem
//
//  Created by 김성훈 on 7/3/26.
//

import SwiftUI

// MARK: - Popup Manager

@MainActor
public final class PopupManager {
    public static let shared = PopupManager()
    private init() {}

    private var activeController: UIHostingController<AnyView>?
    private var activeBgView: UIView?
    private var activeTapHandler: PopupTapHandler?

    @MainActor
    public func show<Popup: View>(
        backgroundColor: Color = .black300PopUpDimStatusBar,
        onBackgroundTap: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Popup
    ) {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive })?
            .keyWindow
        else { return }

        dismiss()

        let bgView = UIView()
        bgView.backgroundColor = UIColor(backgroundColor)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.alpha = 0
        activeBgView = bgView

        if let onBackgroundTap {
            let handler = PopupTapHandler(action: onBackgroundTap)
            activeTapHandler = handler
            let tap = UITapGestureRecognizer(target: handler, action: #selector(PopupTapHandler.handleTap))
            bgView.addGestureRecognizer(tap)
        }

        window.addSubview(bgView)
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: window.topAnchor),
            bgView.bottomAnchor.constraint(equalTo: window.bottomAnchor),
            bgView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: window.trailingAnchor)
        ])

        let hostingController = UIHostingController(rootView: AnyView(content()))
        activeController = hostingController

        let contentView = hostingController.view!
        contentView.backgroundColor = .clear
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.alpha = 0

        window.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: window.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: window.centerYAnchor),
            contentView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: window.trailingAnchor)
        ])
        window.layoutIfNeeded()

        UIView.animate(withDuration: TokenAnimation.fadeInSlow.timeInterval) {
            bgView.alpha = 1
            contentView.alpha = 1
        }
    }

    @MainActor
    public func dismiss() {
        guard let controller = activeController else { return }
        let contentView = controller.view
        let bgView = activeBgView

        UIView.animate(withDuration: TokenAnimation.fadeInSlow.timeInterval) {
            contentView?.alpha = 0
            bgView?.alpha = 0
        } completion: { _ in
            contentView?.removeFromSuperview()
            bgView?.removeFromSuperview()
        }
        activeController = nil
        activeBgView = nil
        activeTapHandler = nil
    }
}

private final class PopupTapHandler: NSObject {
    private let action: () -> Void
    init(action: @escaping () -> Void) { self.action = action }

    @objc func handleTap() { action() }
}
