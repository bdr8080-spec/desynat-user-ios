//
//  BestSellingsCollectionViewCell.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit
import SDWebImage
import Cosmos

class BestSellingsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var shareButtonOutlet: UIButton!
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var likeButtonOutlet: UIButton!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var actualPriceLabel: CustomLabelFont!
    @IBOutlet weak var finalPriceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    
    var wishlistButtonTapped: (() -> Void)?
    var shareButtonTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        wishlistButtonTapped?()
    }
    
    @IBAction func shareButtonOutket(_ sender: Any) {
        shareButtonTapped?()
    }
    
    private func setupUI() {
        mainImageView.layer.cornerRadius = 8
        mainImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        mainImageView.clipsToBounds = true
        if AppLanguageManager.shared.currentLanguage == .ar {
                    self.transform = CGAffineTransform(scaleX: -1, y: 1)
                }
    }
    
    func configData(data: BestSellingProductsDataModel?) {
        if AppLanguageManager.shared.currentLanguage == .ar {
            titleLabel.text = "\(data?.productNameAr ?? "") (بواسطة \(data?.store?.storeName ?? ""))"
        }else{
            titleLabel.text = "\(data?.productNameEn ?? "") (by \(data?.store?.storeName ?? ""))"
        }
       
        ratingView.rating = data?.productAvgRating ?? 0
        lblRating.text = "(\(Double(data?.productAvgRating ?? 0)))"
       // print("rating =====",Double(data?.productAvgRating ?? 0))
        if let imageUrlString = data?.productVariants?.first?.variantImage?.first,
           let url = URL(string: imageUrlString) {
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_imageIndicator?.startAnimatingIndicator()
            mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            mainImageView.image = UIImage(named: "")
        }
        finalPriceLabel.text = CommonUtils.formatPriceStringInput(data?.productVariants?.first?.finalPrice, currency: "KD")//"\(data?.productVariants?.first?.finalPrice ?? "") KD"
        CommonUtils.setStrikethrough(label: actualPriceLabel, text: CommonUtils.formatPriceStringInput(data?.productVariants?.first?.actualPrice, currency: "KD"))
        
        CommonUtils.updateDiscountPercentageLabel(discountPriceLabel, actualAmountLabel: actualPriceLabel,discountType: data?.productVariants?.first?.discountType,discountValue: data?.productVariants?.first?.discountValue)
        
        if data?.wishlist == 1 {
            likeButtonOutlet.setImage(UIImage(named: "selectedHeartImage"), for: .normal)
        } else {
            likeButtonOutlet.setImage(UIImage(named: "besSellLike"), for: .normal)
        }
    }
    
    func configDataForTopRatedProducts(data: TopRatedDataModel?) {
        if AppLanguageManager.shared.currentLanguage == .ar {
            titleLabel.text = "\(data?.productNameAr ?? "") (بواسطة \(data?.store?.storeName ?? ""))"
        }else{
            titleLabel.text = "\(data?.productNameEn ?? "") (by \(data?.store?.storeName ?? ""))"
        }
        ratingView.rating = data?.productAvgRating ?? 0
        lblRating.text = String(format: "(%.1f)", data?.productAvgRating ?? 0.0)
        if let imageUrlString = data?.productVariants?.first?.variantImage?.first,
           let url = URL(string: imageUrlString) {
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_imageIndicator?.startAnimatingIndicator()
            mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            mainImageView.image = UIImage(named: "")
        }
        finalPriceLabel.text = CommonUtils.formatPriceStringInput(data?.productVariants?.first?.finalPrice, currency: "KD")
        CommonUtils.setStrikethrough(label: actualPriceLabel, text: CommonUtils.formatPriceStringInput(data?.productVariants?.first?.actualPrice, currency: "KD"))
        
        CommonUtils.updateDiscountPercentageLabel(discountPriceLabel, actualAmountLabel: actualPriceLabel,discountType: data?.productVariants?.first?.discountType,discountValue: data?.productVariants?.first?.discountValue)
        
        if data?.wishlist == 1 {
            likeButtonOutlet.setImage(UIImage(named: "selectedHeartImage"), for: .normal)
        } else {
            likeButtonOutlet.setImage(UIImage(named: "besSellLike"), for: .normal)
        }
    }
    
}
