//
//  BankAccountsTableViewCell.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 11/02/26.
//

import UIKit

class BankAccountsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    
    var editButtonAction: (() -> Void)?
    var deleteButtonAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editDidTapped(_ sender: Any) {
        editButtonAction?()
    }
    
    @IBAction func deleteDidTapped(_ sender: Any) {
        deleteButtonAction?()
    }
    
    func configData(data: BankDetail?) {
        titleLabel.text = maskAccountNumber(data?.accountNo ?? "")
        let isDefaultBankAccount = data?.defaultAccount ?? "0"
        if isDefaultBankAccount == "1" {
            mainImageView.image = .radioSelected
        } else {
            mainImageView.image = .radioUnselected
        }
    }
    
    func maskAccountNumber(_ accountNumber: String) -> String {
        
        // Ensure minimum length
        guard accountNumber.count > 8 else {
            return accountNumber
        }
        
        let firstFour = accountNumber.prefix(5)
        let lastFour = accountNumber.suffix(3)
        let maskedCount = accountNumber.count - 8
        let maskedPart = String(repeating: "X", count: maskedCount)
        
        return "\(firstFour)\(maskedPart)\(lastFour)"
    }
    
}
