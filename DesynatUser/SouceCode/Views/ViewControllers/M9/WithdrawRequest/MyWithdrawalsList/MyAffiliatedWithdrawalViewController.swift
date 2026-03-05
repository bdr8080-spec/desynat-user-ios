//
//  MyAffiliatedWithdrawalViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 25/02/26.
//

import UIKit

class MyAffiliatedWithdrawalViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var totalWithdrawalsLabel: CustomLabelFont!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var upcomingButtonOutlet: CustomButton!
    @IBOutlet weak var upcomingTitleLabel: UILabel!
    @IBOutlet weak var completedTitleLabel: UILabel!
    @IBOutlet weak var completedButtonOutlet: CustomButton!
    @IBOutlet weak var listTableView: UITableView! {
        didSet {
            listTableView.registerCellFromNib(cellID: "MyAffiliatedWithdrawalTableViewCell")
        }
    }
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Property Decalaration
    private var requestType: WithdrawRequestType = .upcoming
    private lazy var viewModel = MyAffiliatedWithdrawalViewModel(hostVC: self)
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func upcomingDidTapped(_ sender: Any) {
        upcomingButtonOutlet.setImage(.btnGradient, for: .normal)
        upcomingTitleLabel.textColor = .white
        completedTitleLabel.textColor = .black
        completedButtonOutlet.setImage(nil, for: .normal)
        listTableView.reloadData()
        requestType = .upcoming
        handleHeightOfTableView()
    }
    
    @IBAction func completedDidTapped(_ sender: Any) {
        upcomingButtonOutlet.setImage(nil, for: .normal)
        upcomingTitleLabel.textColor = .black
        completedTitleLabel.textColor = .white
        completedButtonOutlet.setImage(.btnGradient, for: .normal)
        listTableView.reloadData()
        requestType = .completed
        handleHeightOfTableView()
    }
    
    func handleHeightOfTableView() {
        DispatchQueue.main.async {
            self.tableViewHeightConstraint.constant = self.listTableView.contentSize.height
        }
    }
}

// MARK: - TABLE VIEW METHODS
extension MyAffiliatedWithdrawalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyAffiliatedWithdrawalTableViewCell", for: indexPath) as! MyAffiliatedWithdrawalTableViewCell
        cell.configData(requestType: requestType)
        return cell
    }
    
}

enum WithdrawRequestType {
    case upcoming
    case completed
}

