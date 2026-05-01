//
//  PromoCodeListViewModel.swift
//  DesynatUser
//
//  Created by fluper on 08/12/25.
//

import Foundation

class PromoCodeListViewModel {
  
  private var hostVC: PromoCodeListViewController
  var promocodeList: [GetPromoCodeListDataModel] = []
  var searchText: String = ""
  
  init(hostVC: PromoCodeListViewController) {
    self.hostVC = hostVC
  }
  
  func getAllPromocodeList(){
    var param: [String: Any] = ["delivery_address": hostVC.deliveryAddress]
//    if !searchText.isEmpty {
//      param["search"] = searchText
//    }
    WebService.sharedInstance.getAllPromocodeListApi(param: param) { list in
      self.promocodeList = list
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        self.hostVC.tableview.reloadData()
        self.hostVC.noDataFoundLabel.isHidden = !promocodeList.isEmpty
      }
    }
  }
  
  func applyPromocodeFroSearch() {
      let param: [String: Any] = [
        "search": hostVC.SearchTF.text?.trimmed() ?? "",
          "amount": hostVC.totalAmount
      ]
      WebService.sharedInstance.applyPromocodeApi(param: param) { response in
          DispatchQueue.main.async { [weak self] in
              guard let self else { return }
            let promocodeId = self.hostVC.selectedPromocode?.id ?? 0
            self.hostVC.onPromoSelected?(response, promocodeId)
              CommonUtils.showToast(message: "Promocode applied successfully".localiz())
              self.hostVC.navigationController?.popViewController(animated: true)
          }
      }
  }
  
  func applyPromocode() {
      let param: [String: Any] = [
          "promo_id": hostVC.selectedPromocode?.id ?? 0,
          "amount": hostVC.totalAmount
      ]
      WebService.sharedInstance.applyPromocodeApi(param: param) { response in
          DispatchQueue.main.async { [weak self] in
              guard let self else { return }
//              if let selectedPromo = self.hostVC.selectedPromocode {
//                  self.hostVC.onPromoSelected?(selectedPromo)
//              }
            let promocodeId = self.hostVC.selectedPromocode?.id ?? 0
            self.hostVC.onPromoSelected?(response, promocodeId)
              CommonUtils.showToast(message: "Promocode applied successfully".localiz())
              self.hostVC.navigationController?.popViewController(animated: true)
          }
      }
  }
}
