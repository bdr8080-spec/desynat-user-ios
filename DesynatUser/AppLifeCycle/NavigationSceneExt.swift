////
////  NavigationSceneExt.swift
////  ChorApp
////
////  Created by Developer on 18/12/23.
////
//
import Foundation
import UIKit                 
import DropDown

extension SceneDelegate {
    
    public func navigateToLoginVc() {
      
        navigateTo(vc: LoginViewController.instantiate(fromAppStoryboard: .Main))
    }
    
    // Navigate to Home Vc
    public func navigateToUserHomeVc() {
        let vc = TabBarVC.instantiate(fromAppStoryboard: .Home)
        navigateTo(vc: vc)
      
    }
    
    public func navigateToWelcomeScreen() {
        let vc = WelcomeScreenViewController.instantiate(fromAppStoryboard: .Main)
        navigateTo(vc: vc)
    }
    
    public func navigateToSelectLanguage() {
        let vc = SelectLanguageViewController.instantiate(fromAppStoryboard:.Main)
        navigateTo(vc: vc)
    }

//    /// Logout current user and navigate to loginVc
    func logoutUser() {
//        let roleName = Global.shared.user?.role?.name?.lowercased()
//        Global.shared.user = nil
//        kSharedUserDefaults.clearAllData(except: [.deviceToken,.selectedLanguage,.defaultLanguage,.language, .userId])
//        UserDefaults.standard.set("no", forKey: "login")
//        switch roleName{
//            case "landlord":
//            navigateToLandLordLoginVc()
//        case "agent":
//            navigateToAgentLoginVc()
//        default:
//            self.navigateToGuestLoginVc()
//        }
        
    }
//    
//    ///Pass custom vc to make it root controller
    public func navigateTo(vc:UIViewController) {
        let nc = UINavigationController(rootViewController: vc)
        nc.isNavigationBarHidden = true
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController = nc
        sceneDelegate.window!.makeKeyAndVisible()
    }
    
    
}
