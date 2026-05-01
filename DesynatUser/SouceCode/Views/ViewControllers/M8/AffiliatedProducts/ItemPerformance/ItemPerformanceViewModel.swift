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
    var appliedFilter = WithdrawalFilterModel()
    
    init(hostVC: ItemPerformanceViewController) {
        self.hostVC = hostVC
    }
    
    func getProductDetailsData() {
        var param: [String: Any] = ["id": hostVC.productId]
        
        if let fromDate = appliedFilter.fromDate,
            let formattedToDate = formatDateString(fromDate) {
            param["start_date"] = formattedToDate
        }
        
        if let toDate = appliedFilter.toDate,
            let formattedToDate = formatDateString(toDate) {
            param["end_date"] = formattedToDate
        }
        
        WebService.sharedInstance.getMyProductsDetailsService(param: param) { data in
            DispatchQueue.main.async {
                self.productsDetailsData = data
                self.populateData()
            }
        }
    }
    
    func formatDateString(_ dateString: String,
                          from inputFormat: String = "dd/MM/yyyy",
                          to outputFormat: String = "yyyy-MM-dd") -> String? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
    
    func deleteAffiliatedProductData() {
        let param: [String: Any] = ["id": productsDetailsData?.id ?? 0]
        WebService.sharedInstance.deleteProductsDetailsService(param: param) { data in
            DispatchQueue.main.async {
                self.hostVC.onProductIsRemoved?()
                CommonUtils.showToast(message: "Product is removed successfully".localiz())
                self.hostVC.navigationController?.popViewController(animated: true)
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
        hostVC.finalPriceLabel.text = CommonUtils.formatPriceStringInput(data.product?.productVariants?.first?.finalPrice)
        CommonUtils.setStrikethrough(label: hostVC.actualPriceLabel, text: CommonUtils.formatPriceStringInput(data.product?.productVariants?.first?.actualPrice))
        
        CommonUtils.updateDiscountPercentageLabel(hostVC.discountPercenteLabel, actualAmountLabel: hostVC.actualPriceLabel, discountType: data.product?.productVariants?.first?.discountType,discountValue: data.product?.productVariants?.first?.discountValue)
        hostVC.commissionPercentageLabel.text = "\(data.product?.affiliatedCommission ?? "0")% \("Commission".localiz())"
        hostVC.linkLabel.text = "\("Link - off".localiz()) \(data.affiliateProductLink?.link ?? "")"
        hostVC.totalCountLabel.text = data.totalClicks?.description
        hostVC.totalOrdersLabel.text = data.totalOrders?.description
        hostVC.conversionRateLabel.text = "\(data.conversionRate ?? 0) %"
        hostVC.totalRevenueLabel.text = CommonUtils.formatPrice(data.totalRevenue)
        hostVC.myEarningLabel.text = CommonUtils.formatPrice(data.myEarning)
    }
    
    
}
