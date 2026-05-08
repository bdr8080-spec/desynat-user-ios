//
//  CatalogTableViewCell.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit
import SDWebImage

class CatalogTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainContentView: CustomView!
    @IBOutlet weak var rightImageView: CustomImageView!
    @IBOutlet weak var leftImageView: CustomImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configData(data: CategoriesDataModel) {
        if AppLanguageManager.shared.currentLanguage == .ar {
            titleLabel.text = data.nameAr
            
        }else{
            titleLabel.text = data.name
            //descriptionLabel.text = data.description
        }
        descriptionLabel.text = data.description
        if let imageUrlString = data.image,
           let url = URL(string: imageUrlString) {
            leftImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            leftImageView.sd_imageIndicator?.startAnimatingIndicator()
            leftImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
            
            rightImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            rightImageView.sd_imageIndicator?.startAnimatingIndicator()
            rightImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            leftImageView.image = UIImage(named: "")
            rightImageView.image = UIImage(named: "")
        }
        mainContentView.backgroundColor = UIColor(hexString: data.colorCode ?? "")
    }
    
}
