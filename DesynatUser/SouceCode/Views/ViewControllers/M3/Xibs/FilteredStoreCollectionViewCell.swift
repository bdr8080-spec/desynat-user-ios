//
//  FilteredStoreCollectionViewCell.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit
import SDWebImage
import Cosmos

class FilteredStoreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var likeButtonOutlet: UIButton!
    @IBOutlet weak var iscountPriceLabel: UILabel!
    @IBOutlet weak var actualPriceLabel: CustomLabelFont!
    @IBOutlet weak var finalPriceLabel: UILabel!
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var wishlistButtonTapped: (() -> Void)?
    var shareButtonTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        wishlistButtonTapped?()
    }
    
    @IBAction func shareDidTapped(_ sender: Any) {
        shareButtonTapped?()
    }
    
    func configData(data: ProductList?) {
        
        if AppLanguageManager.shared.currentLanguage == .ar {
            titleLabel.text = data?.productNameAr
        }else{
            titleLabel.text = data?.productNameEn
        }
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
        
        CommonUtils.updateDiscountPercentageLabel(iscountPriceLabel, actualAmountLabel: actualPriceLabel,discountType: data?.productVariants?.first?.discountType,discountValue: data?.productVariants?.first?.discountValue)
        
        if data?.wishlist == 1 {
            likeButtonOutlet.setImage(UIImage(named: "selectedHeartImage"), for: .normal)
        } else {
            likeButtonOutlet.setImage(UIImage(named: "besSellLike"), for: .normal)
        }
        ratingView.rating = data?.productAvgRating ?? 0
    }
    
    func configDataForFavouites(data: FavoruitesDataModel?) {
//        titleLabel.text = data?.productNameEn
        if AppLanguageManager.shared.currentLanguage == .ar {
            titleLabel.text = data?.productNameAr
        }else{
            titleLabel.text = data?.productNameEn
        }
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
        CommonUtils.updateDiscountPercentageLabel(iscountPriceLabel, actualAmountLabel: actualPriceLabel,discountType: data?.productVariants?.first?.discountType,discountValue: data?.productVariants?.first?.discountValue)
        likeButtonOutlet.setImage(UIImage(named: "selectedHeartImage"), for: .normal)
        ratingView.rating = data?.productAvgRating ?? 0
    }
    
    
    func configBestSellingData(data: BestSellingProductsDataModel?) {
        
        if AppLanguageManager.shared.currentLanguage == .ar {
            titleLabel.text = data?.productNameAr
        }else{
            titleLabel.text = data?.productNameEn
        }
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
        
        CommonUtils.updateDiscountPercentageLabel(iscountPriceLabel, actualAmountLabel: actualPriceLabel,discountType: data?.productVariants?.first?.discountType,discountValue: data?.productVariants?.first?.discountValue)
        
        if data?.wishlist == 1 {
            likeButtonOutlet.setImage(UIImage(named: "selectedHeartImage"), for: .normal)
        } else {
            likeButtonOutlet.setImage(UIImage(named: "besSellLike"), for: .normal)
        }
        ratingView.rating = data?.productAvgRating ?? 0
    }
    
    func configTopRatedData(data: TopRatedDataModel?) {
        
        if AppLanguageManager.shared.currentLanguage == .ar {
            titleLabel.text = data?.productNameAr
        }else{
            titleLabel.text = data?.productNameEn
        }
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
        
        CommonUtils.updateDiscountPercentageLabel(iscountPriceLabel, actualAmountLabel: actualPriceLabel,discountType: data?.productVariants?.first?.discountType,discountValue: data?.productVariants?.first?.discountValue)
        
        if data?.wishlist == 1 {
            likeButtonOutlet.setImage(UIImage(named: "selectedHeartImage"), for: .normal)
        } else {
            likeButtonOutlet.setImage(UIImage(named: "besSellLike"), for: .normal)
        }
        ratingView.rating = data?.productAvgRating ?? 0
    }
}
