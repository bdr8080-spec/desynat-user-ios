//
//  ItemPerformanceViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 24/02/26.
//

import Foundation
import SDWebImage

class ItemPerformanceViewModel {
    
    private var hostVC: ItemPerformanceViewController
    var productsDetailsData: AffiliatedUserMyProductsList?
    
    init(hostVC: ItemPerformanceViewController) {
        self.hostVC = hostVC
    }
    
    func getLatestSearchData() {
        let param: [String: Any] = ["id": hostVC.productId]
        WebService.sharedInstance.getMyProductsDetailsService(param: param) { data in
            DispatchQueue.main.async {
                self.productsDetailsData = data
                self.populateData()
            }
        }
    }
    
    private func populateData() {
        guard let data = productsDetailsData else { return }
        if let imageUrlString = data.product?.productVariants?.first?.variantImage?.first,
           let url = URL(string: imageUrlString) {
            hostVC.productImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            hostVC.productImageView.sd_imageIndicator?.startAnimatingIndicator()
            hostVC.productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            hostVC.productImageView.image = UIImage(named: "")
        }
        hostVC.productNameLabel.text = data.product?.productNameEn
        hostVC.finalPriceLabel.text = "\(data.product?.productVariants?.first?.finalPrice ?? "") KD"
        CommonUtils.setStrikethrough(label: hostVC.actualPriceLabel, text: "\(data.product?.productVariants?.first?.actualPrice ?? "") KD")
        
        CommonUtils.updateDiscountPercentageLabel(hostVC.discountPercenteLabel, actualAmountLabel: hostVC.actualPriceLabel, discountType: data.product?.productVariants?.first?.discountType,discountValue: data.product?.productVariants?.first?.discountValue)
        hostVC.commissionPercentageLabel.text = "\(data.product?.affiliatedCommission ?? "0")% Commission"
        hostVC.linkLabel.text = "Link - off \(data.affiliateProductLink?.link ?? "")"
        //        totalCountLabel.text = data.t
    }
    
    
}
