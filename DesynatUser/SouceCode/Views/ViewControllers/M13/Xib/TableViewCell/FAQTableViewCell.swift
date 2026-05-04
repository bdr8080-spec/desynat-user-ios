//
//  FAQTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 16/03/26.
//

import UIKit

class FAQTableViewCell: UITableViewCell {

    @IBOutlet weak var titleView: CustomView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var vectorImageView: UIImageView!
    @IBOutlet weak var descriptionView: CustomView!
    @IBOutlet weak var decsriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configData(data: FAQListDataModel?, index: Int) {
        let isArabic = AppLanguageManager.shared.currentLanguage == .ar
        if isArabic {
            titleLabel.text = "Q\(index + 1).\(data?.questionArabic ?? "")"
            decsriptionLabel.text = data?.answerArabic
        } else {
            titleLabel.text = "Q\(index + 1).\(data?.questionEnglish ?? "")"
            decsriptionLabel.text = data?.answerEnglish
        }
    }
    
}
