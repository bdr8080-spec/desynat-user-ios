//
//  ViewAllProductVC.swift
//  DesynatUser
//
//  Created by Chandra Prakash on 27/07/26.
//

import UIKit

class ViewAllProductVC: UIViewController {

    //MARK: IBOUTLETS
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var pageTitleLabel: UILabel!
    @IBOutlet weak var noProductsFoundLabel: UILabel!
    @IBOutlet weak var storesCollectionView: UICollectionView! {
        didSet {
            storesCollectionView.registerCellFromNib(cellID: "FilteredStoreCollectionViewCell")
        }
    }
    
    //MARK: VARIABLES
    lazy var viewModel = ViewAllProductVM(hostVC: self)
    let isGuestUser = UserDefaults.standard.string(forKey: "isGuestLogin") ?? "false"
    private var searchWorkItem: DispatchWorkItem?
    var appliedSortFilter: Int?
    
    //MARK: VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
        if accessibilityHint == "Best Selling" {
            pageTitleLabel.text = "Best Selling".localiz()
        } else {
            pageTitleLabel.text = "Top Rated".localiz()
        }
        viewModel.getProducts()
    }
    
    // MARK: - Button's Action
    @IBAction func bakDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sortDidTapped(_ sender: Any) {
        let nextVC = SortByStoresViewController.instantiate(fromAppStoryboard: .Catalog)
        nextVC.delegate = self
        nextVC.preSelectedApiValue = appliedSortFilter
        self.navigationController?.present(nextVC, animated: true)
    }
    
    @IBAction func filterDidTapped(_ sender: Any) {
        let nextVC = ProductsFiltersViewController.instantiate(fromAppStoryboard: .Catalog)
        nextVC.selectedCategoryIDs = viewModel.selectedCategoryIDs
        nextVC.selectedBrandIDs = viewModel.selectedBrandIDs
        nextVC.selectedColorIDs = viewModel.selectedColorIDs
        nextVC.selectedSizeIDs = viewModel.selectedSizeIDs
        nextVC.selectedDiscountIDs = viewModel.selectedDiscountIDs
        nextVC.selectedRatings = viewModel.selectedRatings
        nextVC.selectedDeliveryTime = viewModel.selectedDeliveryTime
        nextVC.selectedMinPrice = viewModel.minPrice
        nextVC.selectedMaxPrice = viewModel.maxPrice
        nextVC.onApplyFilters = { [weak self] categories, brands, colors, sizes, discounts, minPrice, maxPrice, ratings, deliveryTime in
            guard let self = self else { return }
            
            self.viewModel.selectedCategoryIDs = categories
            self.viewModel.selectedBrandIDs = brands
            self.viewModel.selectedColorIDs = colors
            self.viewModel.selectedSizeIDs = sizes
            self.viewModel.selectedDiscountIDs = discounts
            self.viewModel.minPrice = minPrice
            self.viewModel.maxPrice = maxPrice
            self.viewModel.selectedDeliveryTime = deliveryTime ?? []
            self.viewModel.selectedRatings = ratings ?? []
            self.viewModel.resetPagination()
            self.viewModel.getProducts()
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // MARK: - Mic Button – This is what you wanted!
    @IBAction func micDidTapped(_ sender: UIButton) {
        let nextVC = VoiceSearchViewController.instantiate(fromAppStoryboard: .AffiliateUser)
        nextVC.onSearchedCompletionTxt = { [weak self] searchText in
            self?.searchTF.text = searchText
            self?.viewModel.searchText = searchText
            self?.viewModel.resetPagination()
            self?.viewModel.getProducts()
        }
        self.navigationController?.present(nextVC, animated: true)
    }
    
    func handleWishlistTap(index: Int) {

        let productId: Int

        if accessibilityHint == "Best Selling" {
            productId = viewModel.bestSellingProductsList[index].id ?? 0
        } else {
            productId = viewModel.topRatedProductsList[index].id ?? 0
        }

        viewModel.addToWishlist(productId: productId) { [weak self] success in

            guard let self = self else { return }
            guard success else { return }

            DispatchQueue.main.async {

                if self.accessibilityHint == "Best Selling" {

                    self.viewModel.bestSellingProductsList[index].wishlist =
                        self.viewModel.bestSellingProductsList[index].wishlist == 1 ? 0 : 1

                    let status = self.viewModel.bestSellingProductsList[index].wishlist

                    CommonUtils.showToast(
                        message: status == 1
                        ? "Product added to wishlist".localiz()
                        : "Product removed from wishlist".localiz()
                    )

                } else {

                    self.viewModel.topRatedProductsList[index].wishlist =
                        self.viewModel.topRatedProductsList[index].wishlist == 1 ? 0 : 1

                    let status = self.viewModel.topRatedProductsList[index].wishlist

                    CommonUtils.showToast(
                        message: status == 1
                        ? "Product added to wishlist".localiz()
                        : "Product removed from wishlist".localiz()
                    )
                }

                self.storesCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            }
        }
    }
}

// MARK: - COLLECTION VIEW METHODS
extension ViewAllProductVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.accessibilityHint == "Best Selling" {
            self.viewModel.bestSellingProductsList.count
        } else {
            self.viewModel.topRatedProductsList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "FilteredStoreCollectionViewCell",
            for: indexPath
        ) as! FilteredStoreCollectionViewCell

        if accessibilityHint == "Best Selling" {

            let data = viewModel.bestSellingProductsList[indexPath.row]
            cell.configBestSellingData(data: data)

            cell.shareButtonTapped = { [weak self, weak cell] in
                guard let self = self,
                      let cell = cell else { return }

                ShareUtility.shareProduct(
                    image: cell.mainImageView.image,
                    imageURL: data.productVariants?.first?.variantImage?.first,
                    title: data.productNameEn ?? "",
                    description: data.descriptionEn ?? "",
                    link: "https://desynat.com/api/user/product/detail-page/\(data.id ?? 0)",
                    from: self
                )
            }

        } else {

            let data = viewModel.topRatedProductsList[indexPath.row]
            cell.configTopRatedData(data: data)

            cell.shareButtonTapped = { [weak self, weak cell] in
                guard let self = self,
                      let cell = cell else { return }

                ShareUtility.shareProduct(
                    image: cell.mainImageView.image,
                    imageURL: data.productVariants?.first?.variantImage?.first,
                    title: data.productNameEn ?? "",
                    description: data.descriptionEn ?? "",
                    link: "https://desynat.com/api/user/product/detail-page/\(data.id ?? 0)",
                    from: self
                )
            }
        }

        cell.wishlistButtonTapped = { [weak self] in
            guard let self = self else { return }

            if isGuestUser == "true" {
                showLoginAlert()
                return
            }

            self.handleWishlistTap(index: indexPath.row)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let nextVC = ProductDetailViewController.instantiate(fromAppStoryboard: .Catalog)

        if accessibilityHint == "Best Selling" {
            nextVC.productId = viewModel.bestSellingProductsList[indexPath.row].id
        } else {
            nextVC.productId = viewModel.topRatedProductsList[indexPath.row].id
        }

        navigationController?.pushViewController(nextVC, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt
                        indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10
        let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
        let width = (collectionView.frame.width - totalSpacing) / 2
        return CGSize(width: width, height: 220)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height - 100 {

            guard !viewModel.isLoading else { return }
            guard viewModel.currentPage < viewModel.totalPages else { return }

            viewModel.currentPage += 1
            viewModel.getProducts()
        }
    }
}

//MARK: UITextFieldDelegate Methods
extension ViewAllProductVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            self.viewModel.resetPagination()
            self.viewModel.getProducts()
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}


extension ViewAllProductVC: SortByStoresViewControllerDelegate {
    func didSelectSortOption(_ option: Int) {
        appliedSortFilter = option
        viewModel.resetPagination()
        viewModel.getProducts()
    }
}

protocol SortByStoreDelegate: AnyObject {
    func didSelectSortOption(_ option: Int)
}


