//
//  AffiliatedUserProductViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 28/01/26.
//

import UIKit

class AffiliatedUserProductViewController: UIViewController {
    
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
    private var selectedCatrgoryIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getCategoriesListApi()
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
            return 10
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case categoryCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyProductsCategoryCollectionViewCell", for: indexPath) as! MyProductsCategoryCollectionViewCell
            cell.titleLabel.text = viewModel.categoriesSection[indexPath.row].name
            if selectedCatrgoryIndex == indexPath.row {
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
            
            return cell
        case productCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyProductsCollectionViewCell", for: indexPath) as! MyProductsCollectionViewCell
            cell.onTrackPerformanceTapped = {
                let nextVC = ItemPerformanceViewController.instantiate(fromAppStoryboard: .AffiliateUser)
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
            selectedCatrgoryIndex = indexPath.row
            categoryCollectionView.reloadData()
        case subCatgeoryCollectionView:
            print("")
        case productCollectionView:
            print("")
            
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
                return CGSize(width: 57, height: 65)
            } else {
                return CGSize(width: 57, height: 90)
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
