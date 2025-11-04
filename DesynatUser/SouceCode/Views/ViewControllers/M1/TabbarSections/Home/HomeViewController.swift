//
//  HomeViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var heightConstraintOfNewestProductCollectionView: NSLayoutConstraint!
    @IBOutlet weak var browseDiscountPageController: UIPageControl!
    @IBOutlet weak var browsePrimiumPageController: UIPageControl!
    @IBOutlet weak var heightConstraintOfSuggestedStoreCollectionView: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintOfCategoryColelctionView: NSLayoutConstraint!
    @IBOutlet weak var bannerPageController: UIPageControl!
    @IBOutlet weak var menBottomLabel: UILabel!
    @IBOutlet weak var womenBottomLabel: UILabel!
    @IBOutlet weak var kidsBottomLabel: UILabel!
    @IBOutlet weak var bannerCollectionView: UICollectionView! {
        didSet {
            bannerCollectionView.registerCellFromNib(cellID: "HomeBannerCollectionViewCell")
        }
    }
    @IBOutlet weak var categoriesCollectionView: UICollectionView! {
        didSet {
            categoriesCollectionView.registerCellFromNib(cellID: "CategoriesCollectionViewCell")
        }
    }
    @IBOutlet weak var suggestedStoresCollectionView: UICollectionView! {
        didSet {
            suggestedStoresCollectionView.registerCellFromNib(cellID: "SuggestedStoresCollectionViewCell")
        }
    }
    @IBOutlet weak var bestSellingCollectionView: UICollectionView! {
        didSet {
            bestSellingCollectionView.registerCellFromNib(cellID: "BestSellingsCollectionViewCell")
        }
    }
    @IBOutlet weak var browsePrimiumCollectionView: UICollectionView! {
        didSet {
            browsePrimiumCollectionView.registerCellFromNib(cellID: "HomeBannerCollectionViewCell")
        }
    }
    @IBOutlet weak var topRatedCollectionView: UICollectionView! {
        didSet {
            topRatedCollectionView.registerCellFromNib(cellID: "BestSellingsCollectionViewCell")
        }
    }
    
    @IBOutlet weak var bowseSomeDisCountCollectionView: UICollectionView! {
        didSet {
            bowseSomeDisCountCollectionView.registerCellFromNib(cellID: "HomeBannerCollectionViewCell")
        }
    }
    
    @IBOutlet weak var newestProductsCollectionView: UICollectionView! {
        didSet {
            newestProductsCollectionView.registerCellFromNib(cellID: "BestSellingsCollectionViewCell")
        }
    }

    private var bottomLabels: [UILabel] = []
    private var bannerCount = 5
    private var bestSellCount = 5
    private var newProductCount = 6
    private var categories = ["Abaya", "Kurti set", "Abaya", "Shoes", "Maxi Dress", "Cord Set"]
    private var suggestedStores = ["Abaya", "Kurti set", "Abaya", "Shoes", "Maxi", "Cord", "Abaya", "Shoes", "Maxi", "Cord"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerPageController.numberOfPages = bannerCount
        bottomLabels = [menBottomLabel, womenBottomLabel, kidsBottomLabel]
        //        updateCategoriesCollectionHeight()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.async {
            self.updateCollectionsHeight()
        }
    }
    
    @IBAction func categoryTapped(_ sender: UIButton) {
        hideAllBottomLines()
        bottomLabels[sender.tag].isHidden = false
    }
    
    // MARK: - Page Control Tap Handling
    @IBAction func pageControlChanged(_ sender: UIPageControl) {
        let page = sender.currentPage
        let indexPath = IndexPath(item: page, section: 0)
        bannerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func browsePrimiumChanges(_ sender: UIPageControl) {
        let page = sender.currentPage
        let indexPath = IndexPath(item: page, section: 0)
        browsePrimiumCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    
    @IBAction func browseDiscountChanges(_ sender: UIPageControl) {
        let page = sender.currentPage
        let indexPath = IndexPath(item: page, section: 0)
        bowseSomeDisCountCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    private func hideAllBottomLines() {
        bottomLabels.forEach { $0.isHidden = true }
    }
    
    private func updateCollectionsHeight() {
        heightConstraintOfCategoryColelctionView.constant = categoriesCollectionView.contentSize.height
        heightConstraintOfSuggestedStoreCollectionView.constant = suggestedStoresCollectionView.contentSize.height
        heightConstraintOfNewestProductCollectionView.constant = newestProductsCollectionView.contentSize.height
    }
    
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case bannerCollectionView:
            return bannerCount
        case categoriesCollectionView:
            return categories.count
        case suggestedStoresCollectionView:
            return suggestedStores.count
        case bestSellingCollectionView:
            return bestSellCount
        case browsePrimiumCollectionView:
            return bannerCount
        case topRatedCollectionView:
            return bestSellCount
        case bowseSomeDisCountCollectionView:
            return bannerCount
        case topRatedCollectionView:
            return bestSellCount
        case newestProductsCollectionView:
            return newProductCount
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
            
        case categoriesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as! CategoriesCollectionViewCell
            cell.titleLabel.text = categories[indexPath.row]
            return cell
            
              case suggestedStoresCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestedStoresCollectionViewCell", for: indexPath) as! SuggestedStoresCollectionViewCell
            cell.titleLabel.text = suggestedStores[indexPath.row]
            return cell
            
        case bestSellingCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestSellingsCollectionViewCell", for: indexPath) as! BestSellingsCollectionViewCell
      return cell
            
        case browsePrimiumCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCollectionViewCell", for: indexPath) as! HomeBannerCollectionViewCell
            cell.mainImageView.layer.cornerRadius = 8
            return cell
            
        case topRatedCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestSellingsCollectionViewCell", for: indexPath) as! BestSellingsCollectionViewCell
      return cell
            
        case bowseSomeDisCountCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCollectionViewCell", for: indexPath) as! HomeBannerCollectionViewCell
            cell.mainImageView.layer.cornerRadius = 8
            return cell
            
        case newestProductsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestSellingsCollectionViewCell", for: indexPath) as! BestSellingsCollectionViewCell
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case bannerCollectionView:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
            
        case categoriesCollectionView:
            let spacing: CGFloat = 10
            let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
            let width = (collectionView.frame.width - totalSpacing) / 3
            let height: CGFloat = 120
            return CGSize(width: width, height: height)
            
        case suggestedStoresCollectionView:
                 let width = suggestedStoresCollectionView.frame.width / 5
                let height: CGFloat = 95
                return CGSize(width: width, height: height)
            
        case bestSellingCollectionView:
            let spacing: CGFloat = 10
            let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
            let width = (collectionView.frame.width - totalSpacing) / 2
            return CGSize(width: width, height: bestSellingCollectionView.frame.height)
            
        case browsePrimiumCollectionView:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
            
        case topRatedCollectionView:
            let spacing: CGFloat = 10
            let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
            let width = (collectionView.frame.width - totalSpacing) / 2
            return CGSize(width: width, height: topRatedCollectionView.frame.height)
            
        case bowseSomeDisCountCollectionView:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
            
        case newestProductsCollectionView:
            let spacing: CGFloat = 10
            let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
            let width = (collectionView.frame.width - totalSpacing) / 2
            return CGSize(width: width, height: newestProductsCollectionView.frame.height)
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollectionView {
            viewWillLayoutSubviews()
        }
    }
    
    // MARK: - Update Page Control on Scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == bannerCollectionView {
            let pageIndex = Int(round(scrollView.contentOffset.x / bannerCollectionView.frame.width))
            bannerPageController.currentPage = pageIndex
        } else if scrollView == browsePrimiumCollectionView {
            let pageIndex = Int(round(scrollView.contentOffset.x / browsePrimiumCollectionView.frame.width))
            browsePrimiumPageController.currentPage = pageIndex
        } else if scrollView == bowseSomeDisCountCollectionView {
            let pageIndex = Int(round(scrollView.contentOffset.x / bowseSomeDisCountCollectionView.frame.width))
            browseDiscountPageController.currentPage = pageIndex
        }
    }
    
}
