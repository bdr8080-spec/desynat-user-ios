//
//  CMSViewModel.swift
//  DesynatUser
//
//  Created by  shailendra singh on 17/04/26.
//

import Foundation
class CMSViewModel {
    private var hostVC: CMSViewController
    var cmsDetailsData: CMSTermsConditionDataModel?
    let isArabic = AppLanguageManager.shared.currentLanguage == .ar
    
    init(hostVC: CMSViewController) {
        self.hostVC = hostVC
    }
    
    func getReturnPolicyRequest() {
        let param: [String: Any] = ["type": hostVC.selectedUserType]
        WebService.shared.getReturnPolicyService(parameter: param) { [weak self] response in
            guard let self = self else { return }
            cmsDetailsData = response
            if isArabic {
                CommonUtils.loadHTMLContent(response.contentArabic ?? "N/A", webView: hostVC.mainContentView)
            } else {
                CommonUtils.loadHTMLContent(response.contentEnglish ?? "N/A", webView: hostVC.mainContentView)
            }
        }
    }
    
    func getAboutUsRequest() {
        let param: [String: Any] = ["type": hostVC.selectedUserType]
        WebService.shared.getAboutUsPolicyService(parameter: param) { [weak self] response in
            guard let self = self else { return }
            cmsDetailsData = response
            if isArabic {
                CommonUtils.loadHTMLContent(response.contentArabic ?? "N/A", webView: hostVC.mainContentView)
            } else {
                CommonUtils.loadHTMLContent(response.contentEnglish ?? "N/A", webView: hostVC.mainContentView)
            }
        }
    }
    
    func getCancellationPolicyRequest() {
        let param: [String: Any] = ["type": hostVC.selectedUserType]
        WebService.shared.getCancellationPolicyService(parameter: param) { [weak self] response in
            guard let self = self else { return }
            cmsDetailsData = response
            if isArabic {
                CommonUtils.loadHTMLContent(response.contentArabic ?? "N/A", webView: hostVC.mainContentView)
            } else {
                CommonUtils.loadHTMLContent(response.contentEnglish ?? "N/A", webView: hostVC.mainContentView)
            }
        }
    }
    
    func getExchangePolicyRequest() {
        let param: [String: Any] = ["type": hostVC.selectedUserType]
        WebService.shared.getExchangePolicyService(parameter: param) { [weak self] response in
            guard let self = self else { return }
            cmsDetailsData = response
            if isArabic {
                CommonUtils.loadHTMLContent(response.contentArabic ?? "N/A", webView: hostVC.mainContentView)
            } else {
                CommonUtils.loadHTMLContent(response.contentEnglish ?? "N/A", webView: hostVC.mainContentView)
            }
        }
    }
    func getTermsAndConditionRequest() {
        let param: [String: Any] = ["type": hostVC.selectedUserType]
        WebService.shared.getTermsConditionService(parameter: param) { [weak self] response in
            guard let self = self else { return }
            cmsDetailsData = response
            if isArabic {
                CommonUtils.loadHTMLContent(response.contentArabic ?? "N/A", webView: hostVC.mainContentView)
            } else {
                CommonUtils.loadHTMLContent(response.contentEnglish ?? "N/A", webView: hostVC.mainContentView)
            }
        }
    }
}
