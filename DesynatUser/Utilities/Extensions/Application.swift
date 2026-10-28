//
//  Application.swift
//  ChorApp
//
//  Created by Developer on 07/12/23.
//
import UIKit

extension UIApplication {

    func topViewController() -> UIViewController? {

        // Ensure all UIKit access happens on the main thread.
        if !Thread.isMainThread {
            return DispatchQueue.main.sync {
                self.topViewController()
            }
        }

        var topController: UIViewController?

        if #available(iOS 13.0, *) {
            for scene in connectedScenes {
                guard let windowScene = scene as? UIWindowScene,
                      windowScene.activationState == .foregroundActive else {
                    continue
                }

                if let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                    topController = window.rootViewController
                    break
                }
            }
        } else {
            topController = keyWindow?.rootViewController
        }

        while let presented = topController?.presentedViewController {
            topController = presented
        }

        if let navigationController = topController as? UINavigationController {
            return navigationController.visibleViewController
        }

        if let tabBarController = topController as? UITabBarController {
            return tabBarController.selectedViewController
        }

        return topController
    }
}
