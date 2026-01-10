//
//  OrderForChatTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper on 05/01/26.
//

import UIKit

class OrderForChatTableViewCell: UITableViewCell {

  var onViewRequestTap :(() -> Void)?
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  @IBAction func viewRequestDidTapped(_ sender: Any) {
    onViewRequestTap?()
  }
  
}
