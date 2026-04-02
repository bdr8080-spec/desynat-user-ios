//
//  LiveUsersCell.swift
//  DesynatUser
//
//  Created by Riya Mac on 01/04/26.
//

import UIKit

class LiveUsersCell: UITableViewCell {

    @IBOutlet weak var lblName: CustomLabelFont!
    @IBOutlet weak var btnJoinLive: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
