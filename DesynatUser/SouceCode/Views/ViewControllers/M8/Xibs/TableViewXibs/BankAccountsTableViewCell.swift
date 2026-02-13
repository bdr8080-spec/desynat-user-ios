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
    
}
