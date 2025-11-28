//
//  FavoruitesViewController.swift
//  DesynatUser
//
//  Created by fluper on 27/11/25.
//

import UIKit

class FavoruitesViewController: UIViewController {

  @IBOutlet weak var favouriteCollectionView: UICollectionView! {
    didSet {
      favouriteCollectionView.registerCellFromNib(cellID: "FilteredStoreCollectionViewCell")
    }
  }
  @IBOutlet weak var reelsButtonOutlet: CustomButton!
  @IBOutlet weak var productButtonOutlet: CustomButton!
  @IBOutlet weak var productTitleLabel: UILabel!
  @IBOutlet weak var reelsTitlLabel: UILabel!
  @IBOutlet weak var emptyLabel: UILabel!
  
  private lazy var viewModel = FavouirtesVieModel(hostVC: self)
     private var showingProducts = true
     
     override func viewDidLoad() {
         super.viewDidLoad()
         
     }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.getProductDetails { [weak self] in
        self?.updateUI()
    }
  }
    

  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func productDidTapped(_ sender: Any) {
    showingProducts = true
            
            productButtonOutlet.setImage(UIImage(named: "btnGradient"), for: .normal)
            productTitleLabel.textColor = .white
            
            reelsTitlLabel.textColor = .black
            reelsButtonOutlet.setImage(nil, for: .normal)
            
            updateUI()
  }
  
  @IBAction func reelsDidTapped(_ sender: Any) {
    showingProducts = false
            
            reelsButtonOutlet.setImage(UIImage(named: "btnGradient"), for: .normal)
            reelsTitlLabel.textColor = .white
            
            productTitleLabel.textColor = .black
            productButtonOutlet.setImage(nil, for: .normal)
            
            updateUI()
  }
  
  func handleWishlistTap(index: Int) {
      if showingProducts {
          guard let productId = viewModel.productList?[index].id else { return }

          viewModel.addToWishlist(productId: productId) { [weak self] success in
              guard let self = self, success else { return }

              self.viewModel.productList?.remove(at: index)

              self.favouriteCollectionView.performBatchUpdates({
                  self.favouriteCollectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
              })

              self.updateUI()
          }
      } else {
          guard let reelId = viewModel.reelsList?[index].id else { return }

          viewModel.addToWishlist(productId: reelId) { [weak self] success in
              guard let self = self, success else { return }

              self.viewModel.reelsList?.remove(at: index)

              self.favouriteCollectionView.performBatchUpdates({
                  self.favouriteCollectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
              })

              self.updateUI()
          }
      }
  }

  
  private func updateUI() {
      if showingProducts {
          let isEmpty = viewModel.productList?.isEmpty ?? true
          emptyLabel.text = isEmpty ? "No product found" : ""
          emptyLabel.isHidden = !isEmpty
      } else {
          let isEmpty = viewModel.reelsList?.isEmpty ?? true
          emptyLabel.text = isEmpty ? "Under Developement" : ""
          emptyLabel.isHidden = !isEmpty
      }

      favouriteCollectionView.reloadData()
  }


}


extension FavoruitesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return showingProducts
              ? (viewModel.productList?.count ?? 0)
              : (viewModel.reelsList?.count ?? 0)
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          
          let cell = collectionView.dequeueReusableCell(
              withReuseIdentifier: "FilteredStoreCollectionViewCell",
              for: indexPath
          ) as! FilteredStoreCollectionViewCell
          
          let data = showingProducts
              ? viewModel.productList?[indexPath.row]
              : viewModel.reelsList?[indexPath.row]
          
          cell.configDataForFavouites(data: data)
          
        cell.wishlistButtonTapped = { [weak self, weak cell] in
            guard
                let self = self,
                let cell = cell,
                let currentIndex = collectionView.indexPath(for: cell)?.row
            else { return }
            
            self.handleWishlistTap(index: currentIndex)
        }

          
          return cell
      }
      
      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          
          if showingProducts {
              let nextVC = ProductDetailViewController.instantiate(fromAppStoryboard: .Catalog)
              nextVC.productId = viewModel.productList?[indexPath.row].id
              navigationController?.pushViewController(nextVC, animated: true)
          } else {
              // If you have a reel Player VC, push it here
              print("Tap on Reel")
          }
      }
      
      func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          sizeForItemAt indexPath: IndexPath) -> CGSize {
          
          let spacing: CGFloat = 10
          let totalSpacing = spacing * 2
          let width = (collectionView.frame.width - totalSpacing) / 2
          
          return CGSize(width: width, height: 220)
      }
  
}
