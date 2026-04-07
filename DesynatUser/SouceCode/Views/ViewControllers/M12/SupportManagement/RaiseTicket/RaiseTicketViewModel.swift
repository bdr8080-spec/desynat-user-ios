//
//  RaiseTicketViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 07/04/26.
//

import Foundation

class RaiseTicketViewModel {
    
    private var hostVC: RaiseTicketViewController
    
    init(hostVC: RaiseTicketViewController) {
        self.hostVC = hostVC
    }
    
    func validFields() -> Bool {
        var errorMessage: AlertConstant = .none
        
        if hostVC.selectedTicketType == -1 {
            errorMessage = .SelectTicketType
        }
        
        let titleName = String.getString(hostVC.titleTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if titleName.isEmpty {
                errorMessage = .entertitle
            }
        }
        
        let description = String.getString(hostVC.descriptionTextView.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if description.isEmpty {
                errorMessage = .enterdescription
            }
        }
        
        if hostVC.selectedImageUrl.isEmpty {
            errorMessage = .Selectattachment
        }
        
        if errorMessage != .none {
            hostVC.showAlert(msg: errorMessage.rawValue)
        }
        
        hostVC.view.endEditing(true)
        return errorMessage == .none
    }
    
    func uploadDocument(file: Any, isImage: Bool, completion: @escaping(String) -> Void) {
        let param:MultipartUpload = MultipartUpload(fileName: "image", file: file, mimeType: isImage ? .image : .pdf)
        WebService.sharedInstance.uploadFileForPdfImageVideoGif(withParams: param) { url, msg, code in
            completion(url)
        }
    }
    
    func addAttachment() {
        
    }
}
