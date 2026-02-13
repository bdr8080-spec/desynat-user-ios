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
    
    private var selectedCardIndex = 0
    
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
        let vc = ChangePassowrdViewController.instantiate(fromAppStoryboard: .Profile)
        vc.comingReason = .fromAffiliatedUser
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func addAnotherAccountDidTapped(_ sender: Any) {
        let nextVC = AddAccountViewController.instantiate(fromAppStoryboard: .AffiliateUser)
        nextVC.comingForEdit = false
        self.navigationController?.pushViewController(nextVC, animated: true)
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
        cell.editButtonAction = { [weak self] in
            let nextVC = AddAccountViewController.instantiate(fromAppStoryboard: .AffiliateUser)
            nextVC.comingForEdit = true
            self?.navigationController?.pushViewController(nextVC, animated: true)
        }
        cell.deleteButtonAction = { [weak self] in
            self?.showConfirmationAlert(msg: "Are you sure you want to delete this account?"){ [weak self] in
                guard let self = self else { return }
                // CALL API HERE
            }
        }
        if selectedCardIndex == indexPath.row {
            cell.mainImageView.image = .radioSelected
        } else {
            cell.mainImageView.image = .unselcetdRadioHome
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCardIndex = indexPath.row
        bankAccountTableView.reloadData()
    }
    
}

enum ProfileTab {
    case personal
    case address
    case bank
}
