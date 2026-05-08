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
    

    func configureCell(comingReason: ComingReasonAtChangeCurrency,
                       country: GetAllUserCountryModel? = nil
    ) {
        switch comingReason {
            
        case .comingFromCurrency:
            titleLabel.text = country?.currencyCode
            flagEmojiLabel.isHidden = true
        case .comingFromCountry:
            if AppLanguageManager.shared.currentLanguage == .ar {
                titleLabel.text = country?.nameAr
            }else{
                titleLabel.text = country?.name
            }
            
            flagEmojiLabel.isHidden = false
            flagEmojiLabel.text = country?.flag1
        }
    }
    
    
}
