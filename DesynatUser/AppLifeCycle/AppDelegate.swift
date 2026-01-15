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
    MFSettings.shared.configure(token: "SK_KWT_vVZlnnAqu8jRByOWaRPNId4ShzEDNt256dvnjebuyzo52dXjAfRx2ixW5umjWSUx", country: .kuwait, environment: MFEnvironment.test
    )
    
    let them = MFTheme(navigationTintColor: .white, navigationBarTintColor: .lightGray, navigationTitle: "Payment", cancelButtonTitle: "Cancel")
    
    MFSettings.shared.setTheme(theme: them)
    
    return true
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
      print("Selected item: \(item) at index: \(index)")
      completion(index,item)
      
    }
  }
  
}




