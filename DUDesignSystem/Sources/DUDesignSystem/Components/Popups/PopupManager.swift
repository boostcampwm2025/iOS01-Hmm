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
    private var alertWindow: UIWindow?

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

    @MainActor
    public func replace<Popup: View>(@ViewBuilder content: @escaping () -> Popup) {
        guard let controller = activeController else {
            show(content: content)
            return
        }
        controller.rootView = AnyView(content())
    }

    @MainActor
    public func showNoNetworkAlert() {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIViewController()
        window.windowLevel = .alert + 1
        window.makeKeyAndVisible()
        alertWindow = window

        let alert = UIAlertController(
            title: "네트워크 오류",
            message: "광고 시청 시 네트워크 연결이 필요합니다.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .cancel) { [weak self] _ in
            self?.alertWindow?.isHidden = true
            self?.alertWindow = nil
        })
        window.rootViewController?.present(alert, animated: true)
    }
}

private final class PopupTapHandler: NSObject {
    private let action: () -> Void
    init(action: @escaping () -> Void) { self.action = action }

    @objc func handleTap() { action() }
}
