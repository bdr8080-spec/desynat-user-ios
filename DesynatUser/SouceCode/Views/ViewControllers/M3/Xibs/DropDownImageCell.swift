//
//  DropDownImageCell.swift
//  DesynatUser
//
//  Created by fluper on 27/11/25.
//

import UIKit
import DropDown

class DropDownImageCell: DropDownCell {

  @IBOutlet weak var iconImageView: UIImageView!
     @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
          super.awakeFromNib()
          iconImageView.contentMode = .scaleAspectFit
      }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
