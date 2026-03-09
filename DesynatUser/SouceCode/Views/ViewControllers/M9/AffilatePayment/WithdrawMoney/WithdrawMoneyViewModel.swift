//
//  WithdrawMoneyViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 02/03/26.
//

import Foundation

class WithdrawMoneyViewModel {
    
    private var hostVC: WithdrawMoneyViewController!
    var affiliatedUserBankAccount: [BankDetail]?
    
    init(hostVC: WithdrawMoneyViewController!) {
        self.hostVC = hostVC
    }
    
    func getUserBankAccountApi(){
        WebService.sharedInstance.getAffiliatedProfileService() { response in
            kSharedUserDefaults.saveModelFor(key: .affiliatedUserDeatils, value: response)
            self.affiliatedUserBankAccount = response.bankDetails
            self.hostVC.selectedAccountId = response.bankDetails?
                        .first(where: { $0.defaultAccount == "1" })?
                        .id ?? 0
            self.hostVC.accountListTableView.reloadData()
        }
    }
    
    func makeDefaultBankAccountAffilaitedUserApi(id: Int){
        let param: [String: Any] = ["id": id]
        WebService.sharedInstance.makeDefaultBankAccountAffilaitedUserService(param: param) { response in
            self.getUserBankAccountApi()
        }
    }
    
    func affiliateSubmitWithdrawRequest() {
        let param: [String:Any]  = ["amount": hostVC.amountTF.text?.trimmed() ?? "",
                                    "bankdetails_id": hostVC.selectedAccountId]
        WebService.sharedInstance.affiliateSubmitWithdrawRequestService(withParams: param) { data in
            DispatchQueue.main.async {
                let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                vc.comingReason = .amountAddedIntoWalletForAffiliatedUser
                vc.callBackDismiss = {
                    self.hostVC.navigationController?.popViewController(animated: true)
                }
                self.hostVC.navigationController?.present(vc, animated: true)
            }
        }
    }
    
}
