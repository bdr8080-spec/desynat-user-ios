//
//  AffiliatedUserProductViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 28/01/26.
//

import UIKit
//import Speech

class AffiliatedUserProductViewController: UIViewController {
    
    @IBOutlet weak var btnMicOutlet: UIButton!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var categoryCollectionView: UICollectionView! {
        didSet {
            categoryCollectionView.registerCellFromNib(cellID: "MyProductsCategoryCollectionViewCell")
        }
    }
    @IBOutlet weak var subCatgeoryCollectionView: UICollectionView! {
        didSet {
            subCatgeoryCollectionView.registerCellFromNib(cellID: "MyProductsSubCategoryCollectionViewCell")
        }
    }
    
    @IBOutlet weak var productCollectionView: UICollectionView! {
        didSet {
            productCollectionView.registerCellFromNib(cellID: "MyProductsCollectionViewCell")
        }
    }
    
    private lazy var viewModel = AffiliatedUserProductViewModel(hostVC: self)
    var selectedCatrgoryId = 0
    var selectedSubCatrgoryId = -1//0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
        viewModel.getCategoriesListApi()
        let allSubCategory = SubCategoriesDataModel(
            id: -1,
            categoryID: -1,
            nameEnglish: "All",
            nameArabic: "الكل",
            image: nil,
            status: 1,
            createdAt: nil,
            updatedAt: nil)
        viewModel.subCategoriesSection.insert(allSubCategory, at: 0)
        viewModel.resetAndFetchProducts()
        viewModel.getAllSubCategoriesService()
    }
    
    @IBAction func micdidTapped(_ sender: UIButton) {
        let nextVC = VoiceSearchViewController.instantiate(fromAppStoryboard: .AffiliateUser)
        nextVC.onSearchedCompletionTxt = { [weak self] searchText in
            self?.searchTF.text = searchText
            self?.viewModel.searchText = searchText
            self?.viewModel.resetAndFetchProducts()
        }
        self.navigationController?.present(nextVC, animated: true)
    }
}

extension AffiliatedUserProductViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case categoryCollectionView:
            return viewModel.categoriesSection.count
        case subCatgeoryCollectionView:
            return viewModel.subCategoriesSection.count
        case productCollectionView:
            return viewModel.productDetails.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case categoryCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyProductsCategoryCollectionViewCell", for: indexPath) as! MyProductsCategoryCollectionViewCell
            cell.titleLabel.text = viewModel.categoriesSection[indexPath.row].name
            if selectedCatrgoryId == viewModel.categoriesSection[indexPath.row].id {
                cell.mainView.borderWidth = 2
            } else {
                cell.mainView.borderWidth = 0
            }
            return cell
        case subCatgeoryCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyProductsSubCategoryCollectionViewCell", for: indexPath) as! MyProductsSubCategoryCollectionViewCell
            if indexPath.row == 0 {
                cell.titleLabel.isHidden = true
                cell.mainImageView.image = .allSubCatgeory
            } else {
                cell.titleLabel.isHidden = false
                cell.configData(data: viewModel.subCategoriesSection[indexPath.row])
            }
            let subCatgeoryId = viewModel.subCategoriesSection[indexPath.row].id ?? -1
            if selectedSubCatrgoryId == subCatgeoryId {//} && subCatgeoryId > -1 {
                cell.mainImageView.borderWidth = 2
            } else {
                cell.mainImageView.borderWidth = 0
            }
            return cell
        case productCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyProductsCollectionViewCell", for: indexPath) as! MyProductsCollectionViewCell
            let data = viewModel.productDetails[indexPath.row].product
            cell.configData(data: data)
            cell.onTrackPerformanceTapped = {
                let nextVC = ItemPerformanceViewController.instantiate(fromAppStoryboard: .AffiliateUser)
                nextVC.productId = self.viewModel.productDetails[indexPath.row].productID ?? 0
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case categoryCollectionView:
            selectedCatrgoryId = viewModel.categoriesSection[indexPath.row].id ?? 0
            categoryCollectionView.reloadData()
            selectedSubCatrgoryId = 0
            viewModel.subCategoriesSection = []
            let allSubCategory = SubCategoriesDataModel(
                id: -1,
                categoryID: -1,
                nameEnglish: "All",
                nameArabic: "الكل",
                image: nil,
                status: 1,
                createdAt: nil,
                updatedAt: nil)
            viewModel.subCategoriesSection.insert(allSubCategory, at: 0)
            if indexPath.row > 0 {
                viewModel.getSubCategoriesListApi(categoryID: viewModel.categoriesSection[indexPath.row].id ?? 0)
            } else {
                viewModel.getAllSubCategoriesService()
            }
            viewModel.resetAndFetchProducts()
        case subCatgeoryCollectionView:
            selectedSubCatrgoryId = viewModel.subCategoriesSection[indexPath.row].id ?? 0
            subCatgeoryCollectionView.reloadData()
            viewModel.resetAndFetchProducts()
        default:
            print("")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case categoryCollectionView:
            let width = (collectionView.frame.width) / 4
            return CGSize(width: width, height: 38)
        case subCatgeoryCollectionView:
            if indexPath.row == 0 {
                return CGSize(width: 60, height: 68)
            } else {
                return CGSize(width: 65, height: 90)
            }
        case productCollectionView:
            let spacing: CGFloat = 3
            let totalSpacing = spacing * 2
            let width = (collectionView.frame.width - totalSpacing) / 2
            return CGSize(width: width, height: 285)
        default:
            return .zero
        }
    }
    
}

extension AffiliatedUserProductViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == productCollectionView else { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        if offsetY > contentHeight - frameHeight - 50 {
            viewModel.getAllProducts()
        }
    }
    
}

extension AffiliatedUserProductViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        viewModel.searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            viewModel.resetAndFetchProducts()
        }
        viewModel.searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}
