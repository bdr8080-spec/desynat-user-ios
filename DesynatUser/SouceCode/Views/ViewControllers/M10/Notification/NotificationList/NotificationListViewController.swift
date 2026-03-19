//
//  NotificationListViewController.swift
//  DesynatDriver
//
//  Created by fluper_mac3 on 19/03/26.
//

import UIKit

class NotificationListViewController: UIViewController {

    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView!{
            didSet {
                listTableView.registerCellFromNib(cellID: "NotificationsListTableViewCell")
            }
        }
    private lazy var viewModel = NotificationListViewModel(hostVC: self)
    var selectedNotificationId = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getMyNotificationsListRequest()
    }

    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - TABLE VIEW METHODS
extension NotificationListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.notificationSentList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsListTableViewCell", for: indexPath) as! NotificationsListTableViewCell
        let data = viewModel.notificationSentList[indexPath.row]
        cell.configData(data: data)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.notificationSentList[indexPath.row].isRead == 0 {
            selectedNotificationId = viewModel.notificationSentList[indexPath.row].id ?? 0
            viewModel.markReadNotificationsRequest()
        }
    }
}
