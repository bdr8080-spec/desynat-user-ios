//
//  ChangeCurrencyTableViewCell.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 24/03/26.
//

import UIKit

class ChangeCurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var flagEmojiLabel: UILabel!
    @IBOutlet weak var mainView: CustomView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: CustomLabelFont!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configData(comingReason: ComingReasonAtChangeCurrency) {
        switch comingReason {
        case .comingFromCurrency:
            flagEmojiLabel.isHidden = true
        case .comingFromCountry:
            flagEmojiLabel.isHidden = false
        }
    }
    
}
