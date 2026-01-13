//
//  OrderForChatTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper on 05/01/26.
//

import UIKit

class OrderForChatTableViewCell: UITableViewCell {

    @IBOutlet weak var viewRequestButtonOutlet: UIButton!
    @IBOutlet weak var sendRequestButtonOutlet: UIButton!
    
    var onViewRequestTap :(() -> Void)?
    var onSendRequestTap :(() -> Void)?
  
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
    
    
    @IBAction func sendRequestDidTapped(_ sender: Any) {
        onSendRequestTap?()
    }
    
}
