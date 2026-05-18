//
//  SearchProductListViewController.swift
//  DesynatUser
//
//  Created by fluper on 24/12/25.
//

import UIKit
import Speech

class SearchProductListViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var btnMicOutlet: UIButton!
    @IBOutlet weak var noProductFoundLabel: UILabel!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var storesCollectionView: UICollectionView! {
        didSet {
            storesCollectionView.registerCellFromNib(cellID: "FilteredStoreCollectionViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    lazy var viewModel = SearchProductListViewModel(hostVC: self)
    var appliedSortFilter: Int?
    private var searchWorkItem: DispatchWorkItem?
    var comingFromImageScanner: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
        if comingFromImageScanner {
            searchTF.text = viewModel.attributeText.joined(separator: ", ")
        } else {
            searchTF.text = viewModel.searchText
        }
        viewModel.getProductsApi()
    }
    
    // MARK: - Button's Action
    @IBAction func filterDidTapped(_ sender: Any) {
        let nextVC = ProductsFiltersViewController.instantiate(fromAppStoryboard: .Catalog)
        nextVC.selectedCategoryIDs = viewModel.selectedCategoryIDs
        nextVC.selectedBrandIDs = viewModel.selectedBrandIDs
        nextVC.selectedColorIDs = viewModel.selectedColorIDs
        nextVC.selectedSizeIDs = viewModel.selectedSizeIDs
        nextVC.selectedDiscountIDs = viewModel.selectedDiscountIDs
        nextVC.selectedMinPrice = viewModel.minPrice
        nextVC.selectedMaxPrice = viewModel.maxPrice
        nextVC.selectedRatings = viewModel.selectedRatings
        nextVC.selectedDeliveryTime = viewModel.selectedDelivertTime
//        nextVC.onApplyFilters = { [weak self] categories, brands, colors, sizes, discounts, minPrice, maxPrice in
        nextVC.onApplyFilters = { [weak self] categories, brands, colors, sizes, discounts, minPrice, maxPrice, ratings, deliveryTime in
            guard let self = self else { return }
            self.viewModel.selectedCategoryIDs = categories
            self.viewModel.selectedBrandIDs = brands
            self.viewModel.selectedColorIDs = colors
            self.viewModel.selectedSizeIDs = sizes
            self.viewModel.selectedDiscountIDs = discounts
            self.viewModel.minPrice = minPrice
            self.viewModel.maxPrice = maxPrice
            self.viewModel.selectedRatings = ratings ?? []
            self.viewModel.selectedDelivertTime = deliveryTime ?? []
            self.viewModel.getProductsApi()
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popToViewController(ofType: SearchVC.self)
    }
    
    @IBAction func sortDidTapped(_ sender: Any) {
        let nextVC = SortByStoresViewController.instantiate(fromAppStoryboard: .Catalog)
        nextVC.delegate = self
        nextVC.preSelectedApiValue = appliedSortFilter
        self.navigationController?.present(nextVC, animated: true)
    }
    
    // MARK: - Mic Button – This is what you wanted!
    @IBAction func micDidTapped(_ sender: UIButton) {
        let nextVC = VoiceSearchViewController.instantiate(fromAppStoryboard: .AffiliateUser)
        nextVC.onSearchedCompletionTxt = { [weak self] searchText in
            self?.searchTF.text = searchText
            self?.viewModel.searchText = searchText
            self?.viewModel.getProductsApi()
        }
        self.navigationController?.present(nextVC, animated: true)
    }
    
    @IBAction func cameraDidTapped(_ sender: Any) {
        let vc = WatchScannerVc.viewFromNIB
        vc.comingFromSearchProduct = true
        vc.onImageRecognized = { [weak self] attributes in
            guard let self = self else { return }
            self.comingFromImageScanner = true
            self.viewModel.attributeText = attributes
            self.searchTF.text = attributes.joined(separator: ", ")
            self.viewModel.getProductsApi()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Function's declaration
    func handleWishlistTap(index: Int) {
        guard let product = viewModel.productDetails?[index] else { return }
        let productId = product.id ?? 0
        viewModel.addToWishlist(productId: productId) { [weak self] success in
            guard let self = self else { return }
            if success {
                guard var updatedProduct = self.viewModel.productDetails?[index] else { return }
                let newStatus = updatedProduct.wishlist == 1 ? 0 : 1
                updatedProduct.wishlist = newStatus
                self.viewModel.productDetails?[index] = updatedProduct
                DispatchQueue.main.async {
                    self.storesCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                    if newStatus == 1 {
                        CommonUtils.showToast(message: "Product added to wishlist".localiz())
                    } else {
                        CommonUtils.showToast(message: "Product removed from wishlist".localiz())
                    }
                }
            } else {
                print("Wishlist API Failed")
            }
        }
    }
    
}

// MARK: - COLLECTION VIEW METHODS
extension SearchProductListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.productDetails?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilteredStoreCollectionViewCell", for: indexPath) as! FilteredStoreCollectionViewCell
        let data = viewModel.productDetails?[indexPath.row]
        cell.configData(data: data)
        cell.wishlistButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.handleWishlistTap(index: indexPath.row)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let nextVC = ProductDetailViewController.instantiate(fromAppStoryboard: .Catalog)
        nextVC.productId = viewModel.productDetails?[indexPath.row].id
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt
                        indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10
        let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
        let width = (collectionView.frame.width - totalSpacing) / 2
        return CGSize(width: width, height: 220)
    }
}

//MARK: UITextFieldDelegate Methods
extension SearchProductListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            viewModel.getProductsApi()
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}

extension SearchProductListViewController: SortByStoresViewControllerDelegate {
    
    func didSelectSortOption(_ option: Int) {
        appliedSortFilter = option
        self.viewModel.getProductsApi()   // call API again
    }
}
