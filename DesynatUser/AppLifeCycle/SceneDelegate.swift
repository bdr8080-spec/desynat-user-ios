//
//  SceneDelegate.swift
//  DemoProject
//
//  Created by Rakhi Kumari on 22/09/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let islogin = UserDefaults.standard.string(forKey:"isLogin")
        let isAppInstalled = UserDefaults.standard.string(forKey:"isAppInstall")
        let isAffiliatedUserLoggedIn = UserDefaults.standard.string(forKey:"affiliatedAccountIsLoggedIn")
        UserDefaults.standard.set("true", forKey: "hasShownFullscreenBanner")
        if islogin == "Yes" {
            if isAffiliatedUserLoggedIn == "true" {
                kSharedSceneDelegate.navigateToAffiliatedUserHomeVc()
            } else {
                kSharedSceneDelegate.navigateToUserHomeVc()
            }
        }else{
            if isAppInstalled == "true"{
                kSharedSceneDelegate.navigateToWelcomeScreen()
            }else if isAppInstalled == "false"{
                kSharedSceneDelegate.navigateToLoginVc()
            } else{
                kSharedSceneDelegate.navigateToSelectLanguage()
            }
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func scene(_ scene: UIScene,
               continue userActivity: NSUserActivity) {

        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL else { return }

        print("Universal link:", url)

        handleDeepLink(url)
    }
    
    func handleDeepLink(_ url: URL) {

        let path = url.path

        if path.contains("/user/product/detail-page/") {

            let components = path.split(separator: "/")
            if let productId = components.last {

                print("Product ID:", productId)

                // Navigate to product screen
                // push ProductViewController(productId)
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
}

//https:desynat.com/user/product/detail-page/75?ref=25
//applinks:desynat.com
