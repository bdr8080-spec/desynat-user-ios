//
//  MyAffiliatedWithdrawalViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 25/02/26.
//

import UIKit

class MyAffiliatedWithdrawalViewController: UIViewController {
    
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
    
    private var requestType: WithdrawRequestType = .upcoming
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func upcomingDidTapped(_ sender: Any) {
        requestType = .upcoming
        upcomingButtonOutlet.setImage(.btnGradient, for: .normal)
        upcomingTitleLabel.textColor = .white
        completedTitleLabel.textColor = .black
        completedButtonOutlet.setImage(UIImage(named: ""), for: .normal)
        listTableView.reloadData()
    }
    
    @IBAction func completedDidTapped(_ sender: Any) {
        requestType = .completed
        upcomingButtonOutlet.setImage(UIImage(named: ""), for: .normal)
        upcomingTitleLabel.textColor = .black
        completedTitleLabel.textColor = .white
        completedButtonOutlet.setImage(.btnGradient, for: .normal)
        listTableView.reloadData()
    }
}

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
