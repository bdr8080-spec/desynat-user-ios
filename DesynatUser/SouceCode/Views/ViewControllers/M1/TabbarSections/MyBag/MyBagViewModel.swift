//
//  MyBagViewModel.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 26/11/25.
//

import Foundation
import UIKit

class MyBagViewModel: NSObject {
    
    private var hostVC: MyBagViewController
    var bagDetails: MyCartDetailsDataModel?
    var normalOrders: [CartItemList] = []
    var customOrders: [CartItemList] = []
    
    init(hostVC: MyBagViewController) {
        self.hostVC = hostVC
    }
    
    func getBagDetailsApi(){
        WebService.sharedInstance.gteBagDetails { [self] list in
            DispatchQueue.main.async {
                self.bagDetails = list
                self.filterCartData()
                self.hostVC.condifData(data: list)
                self.hostVC.noDataFoundLabel.isHidden = !(self.bagDetails?.cartData?.isEmpty ?? true)
                self.hostVC.bagDetailsView.isHidden = self.bagDetails?.cartData?.isEmpty ?? true
                self.hostVC.totoalAmountPriceView.isHidden = self.bagDetails?.cartData?.isEmpty ?? true
            }
        }
    }
    
    func removeCustomOrderFromCartSerivice(id: Int){
        let param: [String:Any] = ["id": id]
        WebService.sharedInstance.removeCustomOrderFromCartSerivice(param: param) { [self] list in
            DispatchQueue.main.async {
                self.getBagDetailsApi()
                self.hostVC.isAnyItemRemovedFromCart = true
            }
        }
    }
    
    func filterCartData() {
        let cartData = bagDetails?.cartData ?? []
        normalOrders = cartData.filter { $0.orderType == "1" }
        customOrders = cartData.filter { $0.orderType == "2" }
        self.hostVC.bagTableView.isHidden = normalOrders.isEmpty
        self.hostVC.cutomOrderTableView.isHidden = customOrders.isEmpty
        self.hostVC.customOrderTitleLabel.isHidden = customOrders.isEmpty

        self.hostVC.bagTableView.reloadData()
        self.hostVC.cutomOrderTableView.reloadData()
    }

    
    func handleIncrementDecrement(cartID: Int, type: String, index: Int) {
        let param: [String: Any] = [
            "cart_id": "\(cartID)",
            "type": type]
        WebService.sharedInstance.incrementDecrement(param: param) { [weak self] list in
            guard let self = self else { return }
            if type == "increment" {
                self.bagDetails?.cartData?[index].quantity += 1
            } else {
                let current = self.bagDetails?.cartData?[index].quantity ?? 1
                if current > 1 {
                    self.bagDetails?.cartData?[index].quantity -= 1
                    
                }
                if current == 1 {
                    NotificationCenter.default.post(name: NSNotification.Name("ItemRemovedFromBag"), object: nil)
                }
            }
            DispatchQueue.main.async {
                self.hostVC.bagTableView.reloadData()
                self.getBagDetailsApi()
            }
        }
    }
    
    func placeOrderApi() {
        let finalPriceText = hostVC.finalPriceLabel.text?.replacingOccurrences(of: " KD", with: "") ?? "0.0"
        let finalPrice = Double(finalPriceText) ?? 0.0
        var param: [String: Any] = [
            "delivery_address": hostVC.deliveryId,
            "total_mrp": bagDetails?.totalMrp ?? 0,
            "discount_mrp": bagDetails?.discountOnMrp ?? 0,
            "promocode_status": hostVC.isPromoCodeApplied ? "yes" : "no",
            "shipping_fees": bagDetails?.shippingFees ?? 0,
            "tax": bagDetails?.tax ?? 0,
            "total_amount": finalPrice]
        if hostVC.isPromoCodeApplied {
            param["promocode_id"] = hostVC.slecetedPromocodeID ?? 0
            param["promocode_value"] = hostVC.selectedPromoCode?.applyDiscountValue
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let nextVC = PlaceOrderPaymentMethodsViewController.instantiate(fromAppStoryboard: .MyBag)
            nextVC.param = param
            nextVC.totalAmountToPay = finalPrice
            self.hostVC.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}

