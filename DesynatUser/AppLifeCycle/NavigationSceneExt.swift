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
    
    public func navigateToUserHomeVc(selectedIndex: Int = 0) {
        let vc = TabBarVC.instantiate(fromAppStoryboard: .Home)
        vc.initialTabIndex = selectedIndex   // set tab here
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

    // Logout current user and navigate to loginVc
    func logoutUser() {
        kSharedUserDefaults.clearAllData(except: [.deviceToken,.userLocation,.selectedLanguage, .defaultLanguage, .language])
        Global.shared.user = nil
    }
    
    func logoutAfffiliatedUser() {
        kSharedUserDefaults.removeValue(for: .affiliatedAccessToken)
    }
    
    public func navigateToAffiliatedUserHomeVc(selectedIndex: Int = 0) {
        let vc = AffiliatedUserTabbarViewController.instantiate(fromAppStoryboard: .AffiliateUser)
        vc.initialTabIndex = selectedIndex
        navigateTo(vc: vc)
    }
    
    public func navigateToLoginAffiliatedVc() {
        navigateTo(vc: AffiliatedUserLoginViewController.instantiate(fromAppStoryboard: .AffiliateUser))
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
