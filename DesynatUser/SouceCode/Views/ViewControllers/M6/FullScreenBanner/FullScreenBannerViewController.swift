//
//  FullScreenBannerViewController.swift
//  DesynatUser
//
//  Created by fluper on 10/01/26.
//

import UIKit
import SDWebImage

class FullScreenBannerViewController: UIViewController {
  
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var bannerCollectionView: UICollectionView! {
    didSet {
      bannerCollectionView.registerCellFromNib(cellID: "HomeBannerCollectionViewCell")
    }
  }
  
  lazy var viewModel = FullScreenBannerViewModel(hostVC: self)
  private var autoScrollTimer: Timer?
  private var currentIndex = 0
  private var hasCompletedOneCycle = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.getAllFullscreenBannersList()
  }
  
  @IBAction func skipDidTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
  
  @IBAction func pagecontrollDidTapped(_ sender: UIPageControl) {
    let page = sender.currentPage
    let indexPath = IndexPath(item: page, section: 0)
    bannerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
  }
  
  func startAutoScroll() {
    autoScrollTimer?.invalidate()
    autoScrollTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextPage), userInfo: nil, repeats: true)
  }
  
  func setupAfterDataLoad() {
    pageControl.numberOfPages = viewModel.fullScreenBannersList?.count ?? 0
    pageControl.currentPage = 0
    currentIndex = 0
    
    if pageControl.numberOfPages > 1 {
      startAutoScroll()
    }
  }
  
  @objc private func scrollToNextPage() {
    guard pageControl.numberOfPages > 0 else { return }
    
    if currentIndex == pageControl.numberOfPages - 1 {
      // Completed one full cycle
      autoScrollTimer?.invalidate()
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        self.dismiss(animated: true)
      }
      return
    }
    
    currentIndex += 1
    pageControl.currentPage = currentIndex
    
    let indexPath = IndexPath(item: currentIndex, section: 0)
    bannerCollectionView.scrollToItem(
      at: indexPath,
      at: .centeredHorizontally,
      animated: true
    )
  }
  
  deinit {
    autoScrollTimer?.invalidate()
  }
  
}

extension FullScreenBannerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.fullScreenBannersList?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCollectionViewCell", for: indexPath) as! HomeBannerCollectionViewCell
    let data = viewModel.fullScreenBannersList?[indexPath.row]
    if let imageUrlString = data?.image,
       let url = URL(string: imageUrlString) {
      cell.mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
      cell.mainImageView.sd_imageIndicator?.startAnimatingIndicator()
      cell.mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: bannerCollectionView.frame.width, height: bannerCollectionView.frame.height)
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    autoScrollTimer?.invalidate()
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    currentIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
    pageControl.currentPage = currentIndex
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    startAutoScroll()
  }
  
}
