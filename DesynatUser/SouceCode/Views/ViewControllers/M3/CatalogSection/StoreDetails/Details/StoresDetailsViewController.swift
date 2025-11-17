//
//  StoresDetailsViewController.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit

class StoresDetailsViewController: UIViewController {
    
    @IBOutlet weak var reelsCollectionViewHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var searchView: CustomView!
    @IBOutlet weak var sortFilterView: UIView!
    @IBOutlet weak var storesCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var reelsButtonOutlet: CustomButton!
    @IBOutlet weak var productButtonOutlet: CustomButton!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var reelsTitlLabel: UILabel!
    @IBOutlet weak var storiesCollectionView: UICollectionView! {
        didSet {
            storiesCollectionView.registerCellFromNib(cellID: "StoresDetailsCollectionViewCell")
        }
    }
    @IBOutlet weak var storesCollectionView: UICollectionView! {
        didSet {
            storesCollectionView.registerCellFromNib(cellID: "FilteredStoreCollectionViewCell")
        }
    }
    @IBOutlet weak var reelsCollectionView: UICollectionView! {
        didSet {
            reelsCollectionView.registerCellFromNib(cellID: "ReelsCollectionViewCell")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadAllCollections()
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        DispatchQueue.main.async {
//            self.updateCollectionsHeight()
//        }
//    }
    
    @IBAction func bakDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func productDidTapped(_ sender: Any) {
        productButtonOutlet.setImage(UIImage(named: "btnGradient"), for: .normal)
        productTitleLabel.textColor = UIColor.white
        reelsTitlLabel.textColor = UIColor.black
        reelsButtonOutlet.setImage(UIImage(named: ""), for: .normal)
        searchView.isHidden = false
        sortFilterView.isHidden = false
        storesCollectionView.isHidden = false
        reelsCollectionView.isHidden = true
        storesCollectionViewHeightConstraint.constant = storesCollectionView.contentSize.height
    }
    
    @IBAction func reelsDidTapped(_ sender: Any) {
        productButtonOutlet.setImage(UIImage(named: ""), for: .normal)
        productTitleLabel.textColor = UIColor.black
        reelsTitlLabel.textColor = UIColor.white
        reelsButtonOutlet.setImage(UIImage(named: "btnGradient"), for: .normal)
        searchView.isHidden = true
        sortFilterView.isHidden = true
        storesCollectionView.isHidden = true
        reelsCollectionView.isHidden = false
        reelsCollectionViewHeightConstriant.constant = reelsCollectionView.contentSize.height
    }
    
    @IBAction func sortDidTapped(_ sender: Any) {
        let nextVC = SortByStoresViewController.instantiate(fromAppStoryboard: .Catalog)
        self.navigationController?.present(nextVC, animated: true)
    }
    
    @IBAction func filterDidTapped(_ sender: Any) {
        let nextVC = ProductsFiltersViewController.instantiate(fromAppStoryboard: .Catalog)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func updateCollectionsHeight() {
        storesCollectionViewHeightConstraint.constant = storesCollectionView.contentSize.height
        reelsCollectionViewHeightConstriant.constant = reelsCollectionView.contentSize.height
    }
    
    func reloadAllCollections() {
        storiesCollectionView.reloadData()
        storesCollectionView.reloadData()
        reelsCollectionView.reloadData()

        DispatchQueue.main.async {
            self.storesCollectionView.layoutIfNeeded()
            self.reelsCollectionView.layoutIfNeeded()

            self.storesCollectionViewHeightConstraint.constant =
                self.storesCollectionView.collectionViewLayout.collectionViewContentSize.height

            self.reelsCollectionViewHeightConstriant.constant =
                self.reelsCollectionView.collectionViewLayout.collectionViewContentSize.height

            self.view.layoutIfNeeded()
        }
    }

}

extension StoresDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case storiesCollectionView:
            return 5
        case storesCollectionView:
            return 8
        case reelsCollectionView:
            return 8
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case storiesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoresDetailsCollectionViewCell", for: indexPath) as! StoresDetailsCollectionViewCell
            //        cell.titleLabel.text = suggestedStores[indexPath.row]
            return cell
        case storesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilteredStoreCollectionViewCell", for: indexPath) as! FilteredStoreCollectionViewCell
            //        cell.titleLabel.text = suggestedStores[indexPath.row]
            return cell
        case reelsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReelsCollectionViewCell", for: indexPath) as! ReelsCollectionViewCell
            //        cell.titleLabel.text = suggestedStores[indexPath.row]
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt
                        indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case storiesCollectionView:
            let width = storiesCollectionView.frame.width / 5
            let height: CGFloat = 90
            return CGSize(width: width, height: height)
        case storesCollectionView:
            let spacing: CGFloat = 10
            let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
            let width = (collectionView.frame.width - totalSpacing) / 2
            return CGSize(width: width, height: storesCollectionView.frame.height)
        case reelsCollectionView:
            let spacing: CGFloat = 10
            let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
            let width = (collectionView.frame.width - totalSpacing) / 2
            return CGSize(width: width, height: storesCollectionView.frame.height)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if collectionView == storesCollectionView {
//            viewWillLayoutSubviews()
//        }
//    }
    
}
