//
//  DropDownImageCellTableViewCell.swift
//  DesynatUser
//
//  Created by fluper on 27/11/25.
//

import UIKit
import DropDown

class DropDownImageCellTableViewCell: DropDownCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var iconImageView: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
