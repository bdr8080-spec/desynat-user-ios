//
//  CreditCardTableViewCell.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import UIKit

class CreditCardTableViewCell: UITableViewCell {

  @IBOutlet weak var selectedRadioImageView: UIImageView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
