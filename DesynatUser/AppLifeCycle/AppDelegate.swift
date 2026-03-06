//
//  AppDelegate.swift
//  DemoProject
//
//  Created by Rakhi Kumari on 22/09/25.
//

import UIKit
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import DropDown
import MFSDK
import FirebaseCore
import Branch

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var forOpenFilePickerView = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LocationManager.sharedInstance.startUpdatingLocation()
        Thread.sleep(forTimeInterval: 5.0)
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.isEnabled = true
        GMSServices.provideAPIKey("AIzaSyBlCfJlRuxElolt6l-4erdJPR9ySUB8Jwk")    // Our google map API
        GMSPlacesClient.provideAPIKey("AIzaSyAekJV3oxQlPy_OWHCxPYfFw5CnrD-Wzkg")
        FirebaseApp.configure()
        MFSettings.shared.configure(token: "SK_KWT_vVZlnnAqu8jRByOWaRPNId4ShzEDNt256dvnjebuyzo52dXjAfRx2ixW5umjWSUx", country: .kuwait, environment: MFEnvironment.test)
        let them = MFTheme(navigationTintColor: .white, navigationBarTintColor: .lightGray, navigationTitle: "Payment", cancelButtonTitle: "Cancel")
        MFSettings.shared.setTheme(theme: them)
        // BRANCH IO FOR PRODUCT LINK NAVIGATION
        Branch.getInstance().initSession(launchOptions: launchOptions) { params, error in
            // Debug / show content in alert
            self.showShareAlert(withText: "\(params ?? [:])")
            
            if let productId = params?["product_id"] as? String {
                let productLink = "https://desynat.com/user/product/detail-page/\(productId)"
                
                // Show product link alert
                self.showShareAlert(withText: productLink)
                
                // Navigate to product screen
                self.openProduct(productId)
            }
        }
        return true
    }
    
    func showShareAlert(withText text: String) {
        // Get the top-most view controller
        guard let topVC = topViewController() else { return }
        
        // Create alert
        let alert = UIAlertController(title: "Debug / Share", message: text, preferredStyle: .alert)
        
        // Add Share button
        let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
            let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = topVC.view // for iPad
            topVC.present(activityVC, animated: true, completion: nil)
        }
        
        // Add Copy button (optional, handy for debugging)
        let copyAction = UIAlertAction(title: "Copy", style: .default) { _ in
            UIPasteboard.general.string = text
        }
        
        // Add Cancel button
        let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        
        alert.addAction(shareAction)
        alert.addAction(copyAction)
        alert.addAction(cancelAction)
        
        // Present alert
        topVC.present(alert, animated: true, completion: nil)
    }
    
    func topViewController(base: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return topViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    
    func openProduct(_ id: String) {

        let storyboard = UIStoryboard(name: "Catalog", bundle: nil)

        if let vc = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController {

            vc.productId = Int(id)

            let nav = UIApplication.shared.windows.first?.rootViewController as? UINavigationController
            nav?.pushViewController(vc, animated: true)
        }
        
//        let nextVC = ProductDetailViewController.instantiate(fromAppStoryboard: .Catalog)
//        nextVC.productId = viewModel.productDetails?[indexPath.row].id
//        //      nextVC.storeName = pageTitleLabel.text?.trimmed()
//        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
//    func application(_ application: UIApplication,
//                     continue userActivity: NSUserActivity,
//                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//        return Branch.getInstance().continue(userActivity)
//    }
    
    func application(_ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL else { return false }

        handleDeepLink(url)

        return true
    }
    
    func handleDeepLink(_ url: URL) {

        let pathComponents = url.pathComponents

        if pathComponents.contains("product"),
           let productId = pathComponents.last {

            openProduct(productId)
        }
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func dropDown(dataSource:[String] , anchorView:UIView , completion: @escaping (  _ index: Int ,  _ item: String) -> ()) -> Void {
        let dropDown = DropDown()
        dropDown.anchorView = anchorView
        dropDown.dataSource = dataSource
        dropDown.backgroundColor = UIColor.white
        dropDown.textColor = .black
        dropDown.direction = .bottom
        dropDown.selectionBackgroundColor = UIColor.white
        dropDown.selectedTextColor = .black
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dismissMode = .automatic
        dropDown.show()
        dropDown.selectionAction = {(index: Int, item: String) in
            completion(index,item)
        }
    }
        
}

//com.app.DesynatUser
