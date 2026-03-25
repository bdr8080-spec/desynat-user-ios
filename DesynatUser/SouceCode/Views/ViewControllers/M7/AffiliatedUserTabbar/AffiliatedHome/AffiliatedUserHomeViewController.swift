//
//  AffiliatedUserHomeViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 28/01/26.
//

import UIKit

class AffiliatedUserHomeViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var userProfileImageView: CustomImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var btnToday: UIButton!
    @IBOutlet weak var btnThisWeek: UIButton!
    @IBOutlet weak var btnThisMonth: UIButton!
    @IBOutlet weak var ntoificationcountView: CustomView!
    @IBOutlet weak var notificationCountLabel: UILabel!
    
    // MARK: - Property Decalaration
    private var dateButtons: [UIButton] { [btnToday, btnThisWeek, btnThisMonth]}
    private lazy var viewModel = AffiliatedUserHomeViewModel(hostVC: self)
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getCountOfNotificationRequest()
    }
    
    // MARK: - Button's Action
    @IBAction func btnSelectDate(_ sender: UIButton) {
        updateRadioSelection(for: dateButtons, selectedButton: sender)
    }
    
    @IBAction func bellDidTapepd(_ sender: Any) {
        let nextVC = AffiliateUserNotificationViewController.instantiate(fromAppStoryboard: .AffiliateUser)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func supportChatDidTapped(_ sender: Any) {
        let nextVC = AffilaiteSupportChatViewController.instantiate(fromAppStoryboard: .AffiliateUser)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK: Function's declaration
    private func updateRadioSelection(for buttons: [UIButton], selectedButton: UIButton) {
        for button in buttons {
            if button == selectedButton {
                button.setImage(UIImage(named: "radioHome"), for: .normal)
            } else {
                button.setImage(UIImage(named: "unselcetdRadioHome"), for: .normal)
            }
        }
    }
}
