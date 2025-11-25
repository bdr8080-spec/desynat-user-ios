//
//  StoresDetailsViewController.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit
import SDWebImage

class StoresDetailsViewController: UIViewController, SortByStoresViewControllerDelegate {
  func didSelectSortOption(_ option: Int) {
          appliedSortFilter = option
          self.viewModel.getSingleStoresApi()   // call API again
      }
  
    
  @IBOutlet weak var statusView: CustomView!
  @IBOutlet weak var searchTF: UITextField!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var qrImageView: CustomImageView!
  @IBOutlet weak var brandLabel: UILabel!
  @IBOutlet weak var pageTitleLabel: UILabel!
  @IBOutlet weak var storeTitleLabel: UILabel!
  @IBOutlet weak var userProfileImage: CustomImageView!
  @IBOutlet weak var storeImageView: UIImageView!
  @IBOutlet weak var noProductsFoundLabel: UILabel!
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
  
  var storeId: Int? = 0
  private lazy var viewModel = StoreDetailsViewModel(hostVC: self)
  private var searchWorkItem: DispatchWorkItem?
  var fullName: String? = ""
  var appliedSortFilter: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadAllCollections()
      searchTF.delegate = self
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.getSingleStoresApi()
  }
    
  override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      updateCollectionsHeight()
  }
    
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
              nextVC.delegate = self
              nextVC.preSelectedApiValue = appliedSortFilter
              self.navigationController?.present(nextVC, animated: true)
    }
    
    @IBAction func filterDidTapped(_ sender: Any) {
        let nextVC = ProductsFiltersViewController.instantiate(fromAppStoryboard: .Catalog)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
  
  func configData(data: Store) {
    pageTitleLabel.text = data.storeName
    storeTitleLabel.text = fullName
    brandLabel.text = data.storeName
    
    if let imageUrlString = data.storeImage,
           let url = URL(string: imageUrlString) {

      storeImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
      storeImageView.sd_imageIndicator?.startAnimatingIndicator()
      storeImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        
       
        } else {
          storeImageView.image = UIImage(named: "")
        }
    
    descriptionLabel.text = data.bio
    
    if data.storeAvailability == 1 {
      statusView.isHidden = true
    } else {
      statusView.isHidden = false
    }
  }
  

    
     func updateCollectionsHeight() {
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
          return viewModel.singleStoresSection?.allProduct?.data?.count ?? 0
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
          let data = viewModel.singleStoresSection?.allProduct?.data?[indexPath.row]
          cell.configData(data: data)
            return cell
        case reelsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReelsCollectionViewCell", for: indexPath) as! ReelsCollectionViewCell
            //        cell.titleLabel.text = suggestedStores[indexPath.row]
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case storesCollectionView:
            let nextVC = ProductDetailViewController.instantiate(fromAppStoryboard: .Catalog)
            self.navigationController?.pushViewController(nextVC, animated: true)
        default:
            break
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
            return CGSize(width: width, height: 220)
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

extension StoresDetailsViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
    searchWorkItem?.cancel()
    let workItem = DispatchWorkItem { [weak self] in
      guard let self = self else { return }
      self.viewModel.searchText = currentText
      viewModel.getSingleStoresApi()
    }
    searchWorkItem = workItem
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    return true
  }
}

protocol SortByStoresViewControllerDelegate: AnyObject {
    func didSelectSortOption(_ option: Int)
}

struct SortOptionModel {
    var title: String
    var apiParcing: String
    var isSelected: Bool = false
}

