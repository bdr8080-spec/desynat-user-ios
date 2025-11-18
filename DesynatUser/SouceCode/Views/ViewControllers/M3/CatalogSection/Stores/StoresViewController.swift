//
//  StoresViewController.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit

class StoresViewController: UIViewController {
    
    @IBOutlet weak var storesCollectionViewHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var bannerPageController: UIPageControl!
    @IBOutlet weak var bannerCollectionView: UICollectionView! {
        didSet {
            bannerCollectionView.registerCellFromNib(cellID: "HomeBannerCollectionViewCell")
        }
    }
    @IBOutlet weak var storesCollectionView: UICollectionView! {
        didSet {
            storesCollectionView.registerCellFromNib(cellID: "StoresCollectionViewCell")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerCollectionView.layer.cornerRadius = 12
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.async {
            self.updateCollectionsHeight()
        }
    }

    @IBAction func filterDidTapped(_ sender: Any) {
        let nextViewController = StoresFiltersViewController.instantiate(fromAppStoryboard: .Catalog)
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Page Control Tap Handling
    @IBAction func pageControlChanged(_ sender: UIPageControl) {
        let page = sender.currentPage
        let indexPath = IndexPath(item: page, section: 0)
        bannerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    private func updateCollectionsHeight() {
        storesCollectionViewHeightConstriant.constant = storesCollectionView.contentSize.height
    }
}

extension StoresViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case bannerCollectionView:
            return 5
        case storesCollectionView:
            return 8
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case bannerCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCollectionViewCell", for: indexPath) as! HomeBannerCollectionViewCell
            cell.mainImageView.layer.cornerRadius = 0
            return cell
        case storesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoresCollectionViewCell", for: indexPath) as! StoresCollectionViewCell
            if indexPath.row % 2 == 0 {
                cell.statusView.isHidden = true
            } else{
                cell.statusView.isHidden = false
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case bannerCollectionView:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        case storesCollectionView:
            let spacing: CGFloat = 10
            let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
            let width = (collectionView.frame.width - totalSpacing) / 2
            return CGSize(width: width, height: storesCollectionView.frame.height - 10)
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = StoresDetailsViewController.instantiate(fromAppStoryboard: .Catalog)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == storesCollectionView {
            viewWillLayoutSubviews()
        }
    }
    
    // MARK: - Update Page Control on Scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == bannerCollectionView {
            let pageIndex = Int(round(scrollView.contentOffset.x / bannerCollectionView.frame.width))
            bannerPageController.currentPage = pageIndex
        }
    }
    
}
