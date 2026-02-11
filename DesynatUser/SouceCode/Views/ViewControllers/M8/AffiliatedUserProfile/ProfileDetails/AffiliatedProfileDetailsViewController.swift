//
//  AffiliatedProfileDetailsViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 11/02/26.
//

import UIKit

class AffiliatedProfileDetailsViewController: UIViewController {
    
    @IBOutlet weak var bankAccountView: UIView!
    @IBOutlet weak var addressScrollView: UIScrollView!
    @IBOutlet weak var personalInfoScrollView: UIScrollView!
    @IBOutlet weak var bankAcountButton: CustomButton!
    @IBOutlet weak var bankAccountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressButton: CustomButton!
    @IBOutlet weak var personalLabel: UILabel!
    @IBOutlet weak var personalButton: CustomButton!
    @IBOutlet weak var bankAccountTableView: UITableView! {
        didSet {
            bankAccountTableView.registerCellFromNib(cellID: "BankAccountsTableViewCell")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        selectTab(.personal)
        personalInfoScrollView.isHidden = false
        bankAccountView.isHidden = true
        addressScrollView.isHidden = true
        
    }
    
    @IBAction func personalDidTapped(_ sender: Any) {
        selectTab(.personal)
        personalInfoScrollView.isHidden = false
        bankAccountView.isHidden = true
        addressScrollView.isHidden = true
    }
    
    @IBAction func addressDidTapped(_ sender: Any) {
        selectTab(.address)
        addressScrollView.isHidden = false
        personalInfoScrollView.isHidden = true
        bankAccountView.isHidden = true
    }
    
    @IBAction func bankAccountDidTapped(_ sender: Any) {
        selectTab(.bank)
        bankAccountView.isHidden = false
        addressScrollView.isHidden = true
        personalInfoScrollView.isHidden = true
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changePasswordDidTapped(_ sender: Any) {
        
    }
    
    private func selectTab(_ tab: ProfileTab) {
        let buttons = [personalButton, addressButton, bankAcountButton]
        let labels = [personalLabel, addressLabel, bankAccountLabel]
        for button in buttons {
            button?.setImage(UIImage(named: ""), for: .normal)
            button?.layer.cornerRadius = 0
            button?.layer.maskedCorners = []
            button?.clipsToBounds = true
        }
        for label in labels {
            label?.textColor = .black
        }
        switch tab {
        case .personal:
            personalButton.setImage(UIImage(named: "topTabbar"), for: .normal)
            personalButton.layer.cornerRadius = 5
            personalButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            personalLabel.textColor = .white
        case .address:
            addressButton.setImage(UIImage(named: "topTabbar"), for: .normal)
            addressLabel.textColor = .white
        case .bank:
            bankAcountButton.setImage(UIImage(named: "topTabbar"), for: .normal)
            bankAcountButton.layer.cornerRadius = 5
            bankAcountButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            bankAccountLabel.textColor = .white
        }
    }
}

extension AffiliatedProfileDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BankAccountsTableViewCell", for: indexPath) as! BankAccountsTableViewCell
        return cell
    }
    
}

enum ProfileTab {
    case personal
    case address
    case bank
}
