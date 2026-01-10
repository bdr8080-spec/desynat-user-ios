//
//  FullScreenBannerViewModel.swift
//  DesynatUser
//
//  Created by fluper on 10/01/26.
//

import Foundation

class FullScreenBannerViewModel {
  
  private var hostVC: FullScreenBannerViewController
  var fullScreenBannersList: [FullscreenBannersList]?
  
  init(hostVC: FullScreenBannerViewController) {
    self.hostVC = hostVC
  }
  
  func getAllFullscreenBannersList(){
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        self.hostVC.pageControl.numberOfPages = fullScreenBannersList?.count ?? 0
        self.hostVC.startAutoScroll()
        self.hostVC.bannerCollectionView.reloadData()
      }
  }
}
