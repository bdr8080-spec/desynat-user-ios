//
//  FavoruitesViewController.swift
//  DesynatUser
//
//  Created by fluper on 27/11/25.
//

import UIKit

class FavoruitesViewController: UIViewController {

  @IBOutlet weak var favouriteTableView: UITableView! {
    didSet {
      favouriteTableView.registerCellFromNib(cellID: "FilteredStoreCollectionViewCell")
    }
  }
  @IBOutlet weak var reelsButtonOutlet: CustomButton!
  @IBOutlet weak var productButtonOutlet: CustomButton!
  @IBOutlet weak var productTitleLabel: UILabel!
  @IBOutlet weak var reelsTitlLabel: UILabel!
  
  private lazy var viewModel = FavouirtesVieModel(hostVC: self)
  override func viewDidLoad() {
        super.viewDidLoad()
    viewModel.getProductDetails()
        // Do any additional setup after loading the view.
    }
    

  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func productDidTapped(_ sender: Any) {
    productButtonOutlet.setImage(UIImage(named: "btnGradient"), for: .normal)
    productTitleLabel.textColor = UIColor.white
    reelsTitlLabel.textColor = UIColor.black
    reelsButtonOutlet.setImage(UIImage(named: ""), for: .normal)
   
  }
  
  @IBAction func reelsDidTapped(_ sender: Any) {
    productButtonOutlet.setImage(UIImage(named: ""), for: .normal)
    productTitleLabel.textColor = UIColor.black
    reelsTitlLabel.textColor = UIColor.white
    reelsButtonOutlet.setImage(UIImage(named: "btnGradient"), for: .normal)
  }
  
  func handleWishlistTap(index: Int) {
    guard let product = viewModel.favouritesList?[index] else { return }
    let productId = product.id ?? 0
    viewModel.addToWishlist(productId: productId) { [weak self] success in
      guard let self = self else { return }
      if success {
        viewModel.getProductDetails()
        
        }
    }
  }
}


extension FavoruitesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.favouritesList?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilteredStoreCollectionViewCell", for: indexPath) as! FilteredStoreCollectionViewCell
      let data = viewModel.favouritesList?[indexPath.row]
      cell.configDataForFavouites(data: data)
      cell.wishlistButtonTapped = { [weak self] in
        guard let self = self else { return }
        self.handleWishlistTap(index: indexPath.row)
      }
      return cell
   
    
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
   
      let nextVC = ProductDetailViewController.instantiate(fromAppStoryboard: .Catalog)
      nextVC.productId = viewModel.favouritesList?[indexPath.row].id
//      nextVC.storeName = pageTitleLabel.text?.trimmed()
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
