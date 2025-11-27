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
  
  func dropDownWithImage(
      items: [DropDownItem],
      anchorView: UIView,
      completion: @escaping (_ index: Int, _ item: DropDownItem) -> ()
  ) {
      let dropDown = DropDown()
      dropDown.anchorView = anchorView
      dropDown.dataSource = items.map { $0.title }   // titles only
      dropDown.backgroundColor = .white
      dropDown.textColor = .black
      dropDown.direction = .bottom
      dropDown.selectionBackgroundColor = .white
      dropDown.selectedTextColor = .black
      dropDown.bottomOffset = CGPoint(x: 0, y: dropDown.anchorView?.plainView.bounds.height ?? 0)
      dropDown.dismissMode = .automatic
      
      dropDown.cellNib = UINib(nibName: "DropDownImageCell", bundle: nil)

    dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) in
        guard let cell = cell as? DropDownImageCellTableViewCell else { return }
        
        // Set the inherited label DropDown uses
        cell.optionLabel.text = item
        
        // Set your custom image
        if let url = URL(string: items[index].imageUrl ?? "") {
            cell.iconImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            cell.iconImageView.image = UIImage(named: "placeholder")
        }
    }
      
      dropDown.show()
      
      dropDown.selectionAction = { index, _ in
          completion(index, items[index])
      }
  }

    
}




