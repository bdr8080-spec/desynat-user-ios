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
        if let userActivity = connectionOptions.userActivities.first {
            handleDeepLink(userActivity)
            return
        }
        setupNormalUserFlow()
    }
    
    private func setupNormalUserFlow() {
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
        } else {
            if isAppInstalled == "true" {
                kSharedSceneDelegate.navigateToWelcomeScreen()
            } else if isAppInstalled == "false" {
                kSharedSceneDelegate.navigateToLoginVc()
            } else {
                kSharedSceneDelegate.navigateToSelectLanguage()
            }
        }
    }
    
    // FIXED: Universal Links
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        handleDeepLink(userActivity)
    }
    
    // FIXED: Custom URL Scheme
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        handleDeepLink(url)
    }
    
    // FIXED: Go to Normal User Home OR Guest Flow (No forced login)
    private func forceNormalUserHomeFlow() {
        let isAffiliatedUserLoggedIn = UserDefaults.standard.string(forKey:"affiliatedAccountIsLoggedIn")
        
        if isAffiliatedUserLoggedIn == "true" {
//            print("Affiliated user detected - FORCE LOGGING OUT")
            logoutAffiliatedUserOnly()
        }
        
        // DON'T force isLogin = "Yes" - respect current auth state
        UserDefaults.standard.set("No", forKey: "affiliatedAccountIsLoggedIn")
        
        // CHECK CURRENT LOGIN STATE (Don't override)
        let islogin = UserDefaults.standard.string(forKey:"isLogin")
        
        if islogin == "Yes" {
            // Normal user logged in → Go to home
            kSharedSceneDelegate.navigateToUserHomeVc()
//            print("Normal user home set as back target")
        } else {
            // Guest user → Go to appropriate screen (Welcome/Login)
            if let isAppInstalled = UserDefaults.standard.string(forKey:"isAppInstall") {
                if isAppInstalled == "true" {
                    kSharedSceneDelegate.navigateToWelcomeScreen()
                } else {
                    kSharedSceneDelegate.navigateToLoginVc()
                }
            } else {
                kSharedSceneDelegate.navigateToSelectLanguage()
            }
//            print("Guest user flow set as back target")
        }
    }
    
    private func processDeepLink(_ url: URL) {
//        print("Deep link URL: \(url.absoluteString)")
        
        let pathComponents = url.pathComponents
//        print("Path components: \(pathComponents)")
        
        if let detailIndex = pathComponents.firstIndex(of: "detail-page"),
           detailIndex + 1 < pathComponents.count,
           let productId = Int(pathComponents[detailIndex + 1]) {
            
//            print("Product ID: \(productId)")
            
            // Set up proper back target FIRST
            forceNormalUserHomeFlow()
            
            // Navigate to product (Guest/Normal both work)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.navigateToProductDetail(productId: productId, refernceLink: url.absoluteString)
            }
            return
        }
        
        if let storeIndex = pathComponents.firstIndex(of: "store-details"),
           storeIndex + 1 < pathComponents.count,
           let storeId = Int(pathComponents[storeIndex + 1]) {
//            print("Store ID: \(storeId)")
            
            forceNormalUserHomeFlow()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.navigateToStoreDetails(storeId: storeId)
            }
            return
        }
            
    }
    
    // NEW: Logout affiliated WITHOUT navigation change
    private func logoutAffiliatedUserOnly() {
        kSharedSceneDelegate.logoutAfffiliatedUser()  // Your logout API call
        UserDefaults.standard.setValue("No", forKey:"affiliatedAccountIsLoggedIn")
//        print("Affiliated logout complete")
    }
    
    // Keep your existing logoutAPI for manual logout
    func logoutAPI() {
        kSharedSceneDelegate.logoutAfffiliatedUser()
        kSharedSceneDelegate.navigateToLoginAffiliatedVc()
        UserDefaults.standard.setValue("No", forKey:"affiliatedAccountIsLoggedIn")
    }
    
    
    // FIXED: Handle both Universal Link & Custom Scheme
    private func handleDeepLink(_ userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL else { return }
        processDeepLink(url)
    }
    
    private func handleDeepLink(_ url: URL) {
        processDeepLink(url)
    }
    
    // YOUR STORYBOARD NAVIGATION
    private func navigateToProductDetail(productId: Int, refernceLink: String) {
        let storyboard = UIStoryboard(name: "Catalog", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController else {
            return
        }
        
        vc.productId = productId
        vc.refernceLink = refernceLink
        DispatchQueue.main.async {
            if let nav = self.getRootNavigationController() {
                nav.pushViewController(vc, animated: true)
            } else {
                print("No navigation controller found")
            }
        }
    }
    
    private func navigateToStoreDetails(storeId: Int) {
        let storyboard = UIStoryboard(name: "Catalog", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "StoresDetailsViewController") as? StoresDetailsViewController else {
            return
        }
        vc.storeId = storeId
        DispatchQueue.main.async {
            if let nav = self.getRootNavigationController() {
                nav.pushViewController(vc, animated: true)
            } else {
                print("No navigation controller found")
            }
        }
    }
    
    private func getRootNavigationController() -> UINavigationController? {
        guard let window = self.window else { return nil }
        let rootVC = window.rootViewController
        
        // Handle navigation controller inside tab bar, etc.
        if let navVC = rootVC as? UINavigationController {
            return navVC
        }
        if let tabBar = rootVC as? UITabBarController,
           let selectedNav = tabBar.selectedViewController as? UINavigationController {
            return selectedNav
        }
        return rootVC?.children.first as? UINavigationController
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    
    func sceneDidBecomeActive(_ scene: UIScene) {}
    
    func sceneWillResignActive(_ scene: UIScene) {}
    
    func sceneWillEnterForeground(_ scene: UIScene) {}
    
}

//https://desynat.com/user/product/detail-page/75?ref=25 -> product link
//https://desynat.com/user/store-details/58 -> link getting after scanning QR
//applinks:desynat.com
