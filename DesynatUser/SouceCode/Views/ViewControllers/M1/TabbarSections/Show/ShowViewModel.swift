//
//  ShowViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 03/04/26.
//

import Foundation

class ShowViewModel {
    
    private var hostVC: ShowViewController
    var AllLiveStraming: [LiveStramingDataModel]?
    init(hostVC: ShowViewController) {
        self.hostVC = hostVC
    }
    
    func getAllLiveStreamingRequest() {
        WebService.sharedInstance.getAllLiveStramingService { [weak self] response in
            guard let self = self else { return }
            
            // Store the response
            self.AllLiveStraming = response
            
            DispatchQueue.main.async {
                let currentRequests = self.AllLiveStraming
                let hasCurrentRequests = !(currentRequests?.isEmpty ?? true)
                self.hostVC.tvLiveUsers.reloadData()
                // Hide "No Data" label if data exists
                self.hostVC.dataFoundLable.isHidden = hasCurrentRequests
    
            }
        }
    }

    func generateLiveStramingTokenRequest(id: Int) {
        let param: [String:Any] = ["id": id, "role": 1]
        WebService.sharedInstance.generateLiveStramingTokenService(param: param) { [weak self] response in
            guard let self = self else { return }
            let nextVC = LiveStreamingViewController.instantiate(fromAppStoryboard: .Home)
            nextVC.isHost = false
            nextVC.token = response.token
            nextVC.uid = response.uid ?? UInt.random(in: 1...9999)
            nextVC.appID = response.appID ?? ""
            nextVC.channelName = response.channel ?? ""
            nextVC.modalPresentationStyle = .fullScreen
            self.hostVC.navigationController?.present(nextVC, animated: false)
        }
    }
    
}
