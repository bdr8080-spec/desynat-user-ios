//
//  NotificationListViewModel.swift
//  DesynatDriver
//
//  Created by fluper_mac3 on 19/03/26.
//

import Foundation

class NotificationListViewModel {
    
    private var hostVC: NotificationListViewController
    var notificationSentList: [NotificationsList] = []
    
    init(hostVC: NotificationListViewController) {
        self.hostVC = hostVC
    }
    
    func getMyNotificationsListRequest() {
        WebService.sharedInstance.getMyNotificationsListService() { [weak self] response in
            guard let self = self else { return }
            notificationSentList = response
            hostVC.listTableView.reloadData()
            self.hostVC.noDataFoundLabel.isHidden = !self.notificationSentList.isEmpty
        }
    }
    
    func markReadNotificationsRequest() {
        let param: [String:Any] = ["notification_id": [hostVC.selectedNotificationId]]
        WebService.sharedInstance.markReadNotificationsService(param: param) { [weak self] response in
            guard let self = self else { return }
            getMyNotificationsListRequest()
        }
    }
}
