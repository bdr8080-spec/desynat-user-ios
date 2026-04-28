//
//  GiftCardsListTableViewCell.swift
//  DesynatUser
//
//  Created by fluper on 03/12/25.
//

import UIKit
import SDWebImage

class GiftCardsListTableViewCell: UITableViewCell {
  
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var cardTypeLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var mainImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configData(data: GiftCardsListDataModel?){
    if let imageUrlString = data?.giftDetails?.image,
       let url = URL(string: imageUrlString) {
      mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
      mainImageView.sd_imageIndicator?.startAnimatingIndicator()
      mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
    }
    
    nameLabel.text = data?.receiverName
    cardTypeLabel.text = data?.giftDetails?.nameEnglish
      priceLabel.text = CommonUtils.formatPriceStringInput(data?.amount)
    dateLabel.text = formatDate(data?.createdAt ?? "")
  }
  
  private func formatDate(_ isoString: String) -> String {
      let isoFormatter = ISO8601DateFormatter()
      isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
      guard let date = isoFormatter.date(from: isoString) else {
          return "Invalid date"
      }
      let formatter = DateFormatter()
      formatter.locale = Locale(identifier: "en_US_POSIX")
      formatter.dateFormat = "dd MMM yy, h:mm a"
      return formatter.string(from: date).lowercased()
  }
  
}
