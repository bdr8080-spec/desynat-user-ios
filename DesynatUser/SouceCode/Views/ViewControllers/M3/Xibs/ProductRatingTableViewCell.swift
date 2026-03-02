//
//  ProductRatingTableViewCell.swift
//  DesynatUser
//
//  Created by fluper on 18/11/25.
//

import UIKit
import SDWebImage
import Cosmos

class ProductRatingTableViewCell: UITableViewCell {
  
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var ratingView: CosmosView!
  @IBOutlet weak var reviewLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var userProfileImageView: CustomImageView!
  @IBOutlet weak var productImageCollectionView: UICollectionView! {
    didSet {
      productImageCollectionView.registerCellFromNib(cellID: "ProductDetailImageCollectionViewCell")
    }
  }
  override func awakeFromNib() {
    super.awakeFromNib()
    productImageCollectionView.delegate = self
    productImageCollectionView.dataSource = self
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func configData(data: Review?) {
    if let imageUrlString = data?.userDetails?.profileImage,
       let url = URL(string: imageUrlString) {
      userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
      userProfileImageView.sd_imageIndicator?.startAnimatingIndicator()
      userProfileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
    } else {
      userProfileImageView.image = UIImage(named: "")
    }
    usernameLabel.text = data?.userDetails?.fullName
    reviewLabel.text = data?.productReview
    let rating = Double(data?.productRating ?? "") ?? 0
    ratingView.rating = rating
    dateLabel.text = formatISODate(data?.createdAt ?? "")
  }
  
  func formatISODate(_ isoString: String) -> String? {
      let isoFormatter = ISO8601DateFormatter()
      isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
      isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)

      guard let date = isoFormatter.date(from: isoString) else {
          return nil
      }

      let outputFormatter = DateFormatter()
      outputFormatter.dateFormat = "dd MMM yyyy"
      outputFormatter.locale = Locale(identifier: "en_US_POSIX")

      return outputFormatter.string(from: date)
  }

  
}

// MARK: - COLLECTION VIEW METHODS
extension ProductRatingTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailImageCollectionViewCell", for: indexPath) as! ProductDetailImageCollectionViewCell
    cell.mainImageView.layer.cornerRadius = 8
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (productImageCollectionView.frame.width - 40) / 3
    let height: CGFloat = 115
    return CGSize(width: width, height: height)
  }
}
