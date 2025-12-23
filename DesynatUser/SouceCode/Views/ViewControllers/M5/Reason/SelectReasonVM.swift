//
//  SelectReasonVM.swift
//  DesynatUser
//
//  Created by fluper on 23/12/25.
//

import UIKit

class SelectReasonVM: NSObject {
    private var hostVC: SelectReasonVC
    
    init(hostVC: SelectReasonVC) {
        self.hostVC = hostVC
    }
 
    func uploadDocument(file: Any, isImage: Bool, completion: @escaping(String) -> Void) {
        let param: MultipartUpload = MultipartUpload(fileName: "image", file: file, mimeType: isImage ? .image : .pdf)
        WebService.sharedInstance.uploadFile(withParams: param) { url, msg, code in
            completion(url)
        }
    }
    
    private func selectedReasonText() -> String {
        let isOther = hostVC.selectedIndex == hostVC.rejectReasonData.count
        
        if isOther {
            return hostVC.txtReason.text ?? ""
        } else {
            return hostVC.rejectReasonData[hostVC.selectedIndex].reasonEnglish ?? ""
        }
    }

    func cancelOrder(completion: @escaping () -> Void) {
        let params: [String: Any] = [
            "order_id": hostVC.orderId ?? ""
        ]
        WebService.sharedInstance.cancelOrder(param: params) { data in
            completion()
        }
    }
    
    func returnExOrder(type: SelectScreenType, completion: @escaping () -> Void) {
        let apiType: String
        switch type {
        case .returnPro:
            apiType = "1"
        case .exchangePro:
            apiType = "2"
        default:
            return
        }
        
        let reasonText = selectedReasonText()
        
        let params: [String: Any] = [
            "order_id": hostVC.orderId ?? "",
            "orderdetails_id": hostVC.orderDetailId ?? "",
            "type": apiType,  // 1 return 2 Exchange
            
            //return
            "return_reason": type == .returnPro ? reasonText : "", // use when type is return
            "return_image": type == .returnPro ? self.hostVC.selectedProfileImageUrl : "",  // use when type is return
            
            //exchange
            "exchange_reason": type == .exchangePro ? reasonText : "", // use when type is Exchange
            "new_size": type == .exchangePro ? hostVC.sizeArr[hostVC.selectedIndex1] : ""
        ]
        
        WebService.sharedInstance.orderReturnEx(param: params) { data in
            completion()
        }
    }
    
    func rejectReason() {
        let type: String
        switch hostVC.screenType {
        case .exchangePro:
            type = "1"
        
        case .returnPro:
            type = "2"
        
        case .cancelOrder, .customCancel:
            type = "3"
        
        default:
            type = "3"
        }
        
        let params: [String: Any] = [
            "type": type
        ]
        
        WebService.sharedInstance.rejectReason(param: params) { data in
            self.hostVC.rejectReasonData = data
            self.hostVC.reasonTableView.reloadData()
        }
    }
}
