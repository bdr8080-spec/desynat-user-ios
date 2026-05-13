//
//  SavedCardTableViewCell.swift
//  DesynatUser
//
//  Created by  shailendra singh on 17/04/26.
//

import UIKit
import SDWebImage

class SavedCardTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var selectedRadioImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    
    weak var delegate: HandleCardInteraction?
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func deleteDidTapped(_ sender: Any) {
        delegate?.deleteDidTapped(indexPath: indexPath)
    }
    
    @IBAction func radioDidTapped(_ sender: Any) {
        delegate?.makeItDefault(indexPath: indexPath)
    }
    
    func configData(data: SavedCardsDataModel?) {
        cardNumberLabel.text = maskedCardNumber(data?.cardNumber ?? "")
        titleLabel.text = AppLanguageManager.shared.currentLanguage == .ar ? data?.cardTypeAr : data?.cardType ?? ""
        if let imageUrlString = data?.cardImage,
           let url = URL(string: imageUrlString) {
          mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
          mainImageView.sd_imageIndicator?.startAnimatingIndicator()
            mainImageView.sd_setImage(with: url, placeholderImage: .creditCard)
        } else {
            mainImageView.image = .creditCard
        }
        let defaultAddress = data?.isFuture ?? 0
        if defaultAddress == 1 {
            selectedRadioImage.image = .radioSelected
        } else {
            selectedRadioImage.image = .radioUnselected
        }
    }
    
    func maskedCardNumber(_ cardNumber: String) -> String {
        let cleanNumber = cardNumber.replacingOccurrences(of: " ", with: "")
        
        guard cleanNumber.count > 4 else {
            return cleanNumber
        }
        
        let lastFour = String(cleanNumber.suffix(4))
        let maskedPart = String(repeating: "*", count: cleanNumber.count - 4)
        
        return maskedPart + lastFour
    }
    
}

protocol HandleCardInteraction: AnyObject {
    func deleteDidTapped(indexPath: IndexPath)
    func makeItDefault(indexPath: IndexPath)
}
