//
//  SettingsViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 24/03/26.
//

import Foundation

class SettingsViewModel {
    
    private var hostVC: SettingsViewController
    
    init(hostVC: SettingsViewController) {
        self.hostVC = hostVC
    }
    
    func updatePushNotificationSettingRequest() {
        WebService.sharedInstance.updatePushNotificationSettingService() { [weak self] response in
            guard let self = self else { return }
            self.hostVC.isPushNotification = (response.notification == 0) ? false : true
            self.hostVC.updatePushNotificationUI()
        }
    }
    
    func updateInAppNotificationSettingRequest() {
        WebService.sharedInstance.updateInAppNotificationSettingService() { [weak self] response in
            guard let self = self else { return }
            self.hostVC.isAppNotification = (response.appNotification == 0) ? false : true
            self.hostVC.updateAppNotificationUI()
        }
    }
    func getProfile() {
        WebService.sharedInstance.getProfileService { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.hostVC.isPushNotification = (response.notification == 0) ? false : true
                self.hostVC.isAppNotification = (response.appNotification == 0) ? false : true
                self.hostVC.updatePushNotificationUI()
                self.hostVC.updateAppNotificationUI()
            }
        }
    }
    
    //Affiliate User
    func affiliateUserPushNotificationSettingRequest() {
        WebService.sharedInstance.affiliateUserPushNotificationSettingService() { [weak self] response in
            guard let self = self else { return }
            self.hostVC.isPushNotification = (response.notification == 0) ? false : true
            self.hostVC.updatePushNotificationUI()
        }
    }
    
    func affiliateUserInAppNotificationSettingRequest() {
        WebService.sharedInstance.affiliateUserInAppNotificationSettingService() { [weak self] response in
            guard let self = self else { return }
            self.hostVC.isAppNotification = (response.appNotification == 0) ? false : true
            self.hostVC.updateAppNotificationUI()
        }
    }
    
    func affiliateUserGetProfile() {
        WebService.sharedInstance.getAffiliatedProfileService { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.hostVC.isPushNotification = (response.notification == 0) ? false : true
                self.hostVC.isAppNotification = (response.appNotification == 0) ? false : true
                self.hostVC.updatePushNotificationUI()
                self.hostVC.updateAppNotificationUI()
            }
        }
    }
    
}

