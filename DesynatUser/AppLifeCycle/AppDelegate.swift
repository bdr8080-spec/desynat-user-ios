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
import UserNotifications
import SDWebImageSVGCoder
import FirebaseMessaging
import FBSDKCoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
    
    var forOpenFilePickerView = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        //ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        Thread.sleep(forTimeInterval: 5.0)
        LocationManager.sharedInstance.startUpdatingLocation()
        IQKeyboardManager.shared.enableAutoToolbar = true
        AppLanguageManager.shared.defaultLanguage = .en
        IQKeyboardManager.shared.isEnabled = true
        GMSServices.provideAPIKey("AIzaSyBlCfJlRuxElolt6l-4erdJPR9ySUB8Jwk")    // Our google map API
        GMSPlacesClient.provideAPIKey("AIzaSyB5LK7zzKS4q9ov0R4LFLgaRyPZdZsTKz4")
//        MFSettings.shared.configure(token: "SK_KWT_vVZlnnAqu8jRByOWaRPNId4ShzEDNt256dvnjebuyzo52dXjAfRx2ixW5umjWSUx", country: .kuwait, environment: MFEnvironment.test)
        MFSettings.shared.configure(token: "SK_KWT_Xn6nYzfdgF3Lz7TKhrGLhruKiBT5OgesD080ZIJohon0q0CEqCRrwdAsV0qICIsx", country: .kuwait, environment: .live)
        let them = MFTheme(navigationTintColor: .white, navigationBarTintColor: .lightGray, navigationTitle: "Payment", cancelButtonTitle: "Cancel")
        MFSettings.shared.setTheme(theme: them)
        UNUserNotificationCenter.current().delegate = self
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        Settings.shared.appID = "2050785725796089"
        Settings.shared.clientToken = "40955d10a2953936be4b9d4074906a02"
        Settings.shared.displayName = "Desynat"
        confrigNotification(application: application)
        let SVGCoder = SDImageSVGCoder.shared
        SDImageCodersManager.shared.addCoder(SVGCoder)
        UNUserNotificationCenter.current().setBadgeCount(0, withCompletionHandler: nil)
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
    
    func topViewController(base: UIViewController? = UIApplication.shared.connectedScenes
                                .compactMap { $0 as? UIWindowScene }
                                .flatMap { $0.windows }
                                .first { $0.isKeyWindow }?
                                .rootViewController) -> UIViewController? {

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
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
    
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

extension AppDelegate:UNUserNotificationCenterDelegate {
    
    func confrigNotification(application:UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            guard granted else { return }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()  // only once
            }
        }
    }
    
    private func registerForPushNotification(_ application: UIApplication) {
        let current = UNUserNotificationCenter.current()
        current.delegate = self
        current.requestAuthorization(options: [.alert, .badge, .sound]) { (flag, error) in
            if error == nil {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().setAPNSToken(deviceToken,type: .unknown)
        fetchFirebaseToken()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        kSharedUserDefaults.saveValue(Key: .deviceToken, value: fcmToken)
    }
    
    fileprivate func fetchFirebaseToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = token {
//                print("Remote instance ID token: \(result)")
                kSharedUserDefaults.saveModelFor(key: .deviceToken, value: token)
            }
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {}
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let payload = notification.request.content.userInfo
            
            // Convert payload to JSON text
            if let jsonText = payload.toPrettyString() {
//                showShareAlert(withText: jsonText)
            }
            
            if #available(iOS 14.0, *) {
                completionHandler([.banner, .badge, .sound])
            } else {
                completionHandler([.alert, .badge, .sound])
            }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let payload = response.notification.request.content.userInfo
            
            if let jsonText = payload.toPrettyString() {
//                showShareAlert(withText: jsonText)
            }

            // Later you use payload to navigate screens
            // handleDeepLinks(payload)

            completionHandler()
    }
    
}

extension Dictionary {
    func toPrettyString() -> String? {
        if JSONSerialization.isValidJSONObject(self),
           let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted),
           let text = String(data: data, encoding: .utf8) {
            return text
        }
        return nil
    }
}


//com.app.DesynatUser
