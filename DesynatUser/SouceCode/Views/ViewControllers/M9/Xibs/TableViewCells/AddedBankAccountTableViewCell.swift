//
//  AddedBankAccountTableViewCell.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 02/03/26.
//

import UIKit

class AddedBankAccountTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
