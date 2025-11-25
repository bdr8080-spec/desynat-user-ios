//
//  SubCatgoryViewController.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit

class SubCatgoryViewController: UIViewController {

  @IBOutlet weak var noDataFoundLabel: UILabel!
  @IBOutlet weak var subCatgeoryTableView: UICollectionView! {
        didSet {
            subCatgeoryTableView.registerCellFromNib(cellID: "SubCatgoryCollectionViewCell")
        }
    }
  var categoryId: Int? = 0
  
  private lazy var viewModel = SubCategoryViewModel(hostVC: self)
  
    override func viewDidLoad() {
        super.viewDidLoad()

    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.getSubCategoriesListApi(categoryID: categoryId ?? 0)
  }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension SubCatgoryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return viewModel.subCategoriesSection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCatgoryCollectionViewCell", for: indexPath) as! SubCatgoryCollectionViewCell
      let data = viewModel.subCategoriesSection[indexPath.row]
      cell.configData(data: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = StoresViewController.instantiate(fromAppStoryboard: .Catalog)
      nextVC.slectedsubCategoryId = categoryId//viewModel.subCategoriesSection[indexPath.row].id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 7
        let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
        let width = (collectionView.frame.width - totalSpacing) / 2
        return CGSize(width: width, height: 215)
    }
    
}
