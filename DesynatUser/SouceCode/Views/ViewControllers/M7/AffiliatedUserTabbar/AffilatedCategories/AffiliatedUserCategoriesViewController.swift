//
//  AffiliatedUserCategoriesViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 11/02/26.
//

import UIKit
//import Speech

class AffiliatedUserCategoriesViewController: UIViewController {

    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var btnMicOutlet: UIButton!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var subCatgeoiresListCollectionView: UICollectionView! {
        didSet {
            subCatgeoiresListCollectionView.registerCellFromNib(cellID: "SubCatgoryCollectionViewCell")
        }
    }
    @IBOutlet weak var categoriesCollectionView: UICollectionView! {
        didSet {
            categoriesCollectionView.registerCellFromNib(cellID: "AffiliatedCategoriesCollectionViewCell")
        }
    }
    
    private lazy var viewModel = AffiliatedUserCategoriesViewModel(hostVC: self)
    private var selectedCatgeoryIndex = 0
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)
        viewModel.getCategoriesListApi()
    }
    
    // MARK: - Mic Button – This is what you wanted!
    @IBAction func micDidTapped(_ sender: UIButton) {
        let nextVC = VoiceSearchViewController.instantiate(fromAppStoryboard: .AffiliateUser)
        nextVC.onSearchedCompletionTxt = { [weak self] searchText in
            self?.searchTF.text = searchText
            self?.viewModel.filterSubCategories(with: searchText)
        }
        self.navigationController?.present(nextVC, animated: true)
    }
    
    @IBAction func searchDidTapped(_ sender: Any) {
        let nextVC = AffiliatedCategorySearchViewController.instantiate(fromAppStoryboard: .AffiliateUser)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func searchTextChanged(_ textField: UITextField) {
        let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        viewModel.filterSubCategories(with: text)
    }
    
}

// MARK: - CollectionView Delegates
extension AffiliatedUserCategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollectionView {
            return viewModel.categoriesSection.count
        } else {
            return viewModel.subCategoriesSection.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AffiliatedCategoriesCollectionViewCell", for: indexPath) as! AffiliatedCategoriesCollectionViewCell
            let data = viewModel.categoriesSection[indexPath.row]
            cell.configDataForCategory(data: data)
            if selectedCatgeoryIndex == indexPath.row {
                cell.mainBackgroundView.layer.borderWidth = 2
            } else {
                cell.mainBackgroundView.layer.borderWidth = 0
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCatgoryCollectionViewCell", for: indexPath) as! SubCatgoryCollectionViewCell
            let data = viewModel.subCategoriesSection[indexPath.row]
            cell.configData(data: data)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollectionView {
            selectedCatgeoryIndex = indexPath.row
            categoriesCollectionView.reloadData()
            viewModel.getSubCategoriesListApi(categoryID: viewModel.categoriesSection[indexPath.row].id ?? 0)
        }  else {
            // Navigate to all product page
//            let nextVC = AffiliatedProductsViewController.instantiate(fromAppStoryboard: .AffiliateUser)
//            nextVC.categoryId = viewModel.categoriesSection[selectedCatgeoryIndex].id ?? 0
//            nextVC.subCatrgoryId = viewModel.subCategoriesSection[indexPath.row].id ?? 0
//            nextVC.comingReasonAtAllProducts = .fromCategory
//            self.navigationController?.pushViewController(nextVC, animated: true)
            
            let nextVC = SearchAffiliatedProductsViewController.instantiate(fromAppStoryboard: .AffiliateUser)
//            nextVC.viewModel.searchText = self.txtSearch.text?.trimmed() ?? ""
            nextVC.comingFromImageScanner = false
            nextVC.categoryId = viewModel.categoriesSection[selectedCatgeoryIndex].id ?? 0
            nextVC.subCatrgoryId = viewModel.subCategoriesSection[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoriesCollectionView {
            let width = (categoriesCollectionView.frame.width - 40) / 3
            return CGSize(width: width, height: 128)
        } else {
            let spacing: CGFloat = 7
            let totalSpacing = spacing * 2
            let width = (collectionView.frame.width - totalSpacing) / 2
            return CGSize(width: width, height: 215)
        }
    }
}
