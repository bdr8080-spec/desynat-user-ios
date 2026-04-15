//
//  FavoruitesViewController.swift
//  DesynatUser
//
//  Created by fluper on 27/11/25.
//

import UIKit
import AVFoundation
import AVKit

class FavoruitesViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var favouriteCollectionView: UICollectionView! {
        didSet {
            favouriteCollectionView.registerCellFromNib(cellID: "FilteredStoreCollectionViewCell")
            favouriteCollectionView.registerCellFromNib(cellID: "ReelsCollectionViewCell")
        }
    }
    @IBOutlet weak var reelsButtonOutlet: CustomButton!
    @IBOutlet weak var productButtonOutlet: CustomButton!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var reelsTitlLabel: UILabel!
    @IBOutlet weak var emptyLabel: UILabel!
    
    // MARK: - Property Decalaration
    private lazy var viewModel = FavouirtesVieModel(hostVC: self)
    private var showingProducts = true
    private var videoURL: URL?
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getProductDetails()
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func productDidTapped(_ sender: Any) {
        showingProducts = true
        productButtonOutlet.setImage(UIImage(named: "btnGradient"), for: .normal)
        productTitleLabel.textColor = .white
        
        reelsTitlLabel.textColor = .black
        reelsButtonOutlet.setImage(nil, for: .normal)
        viewModel.getProductDetails()
    }
    
    @IBAction func reelsDidTapped(_ sender: Any) {
        showingProducts = false
        
        reelsButtonOutlet.setImage(UIImage(named: "btnGradient"), for: .normal)
        reelsTitlLabel.textColor = .white
        
        productTitleLabel.textColor = .black
        productButtonOutlet.setImage(nil, for: .normal)
        viewModel.getReelsWishlistRequest()
    }
    
    //MARK: Function's declaration
    func handleWishlistTap(index: Int) {
        if showingProducts {
            guard let productId = viewModel.productList?[index].id else { return }
            
            viewModel.addToWishlist(productId: productId) { [weak self] success in
                guard let self = self, success else { return }
                
                self.viewModel.productList?.remove(at: index)
                
                self.favouriteCollectionView.performBatchUpdates({
                    self.favouriteCollectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
                })
                
//                viewModel.getProductDetails()
            }
        } else {
//            guard let reelId = viewModel.reelsList?[index].id else { return }
//
//            viewModel.addToReelsWishelistRequest(reelId: reelId) { [weak self] success in
//                guard let self = self, success else { return }
//
//                self.viewModel.reelsList?.remove(at: index)
//
//                self.favouriteCollectionView.performBatchUpdates({
//                    self.favouriteCollectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
//                })
//
////                viewModel.getReelsWishlistRequest()
//            }
        }
    }
    
    func handleReelRemove(reelId: Int) {
        guard let index = viewModel.reelsList?.firstIndex(where: { $0.reelID == reelId }) else {
            return
        }
        
        viewModel.addToReelsWishelistRequest(reelId: reelId) { [weak self] success in
            guard let self = self, success else { return }
            
            // Remove from array
            self.viewModel.reelsList?.remove(at: index)
            
            // Update UI
            self.favouriteCollectionView.performBatchUpdates({
                self.favouriteCollectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
            }, completion: { _ in
                
                // ✅ If list is now empty, show "No reels found"
                let isEmpty = self.viewModel.reelsList?.isEmpty ?? true
                if isEmpty {
                    self.emptyLabel.text = "No reels found"
                    self.emptyLabel.isHidden = false
                } else {
                    self.emptyLabel.isHidden = true
                }
            })
        }
    }
    
    func shareReel(reelId: Int, completion: @escaping (Bool) -> Void) {

        let shareText = "Check out this reel: https://yourapp.com/reel/\(reelId)"
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)

        activityVC.completionWithItemsHandler = { activityType, completed, returnedItems, error in
            completion(completed)   // return true if shared
        }

        self.present(activityVC, animated: true)
    }
    
    @objc func playVideo() {
            guard let url = videoURL else { return }
            
            let player = AVPlayer(url: url)
            let vc = AVPlayerViewController()
            vc.player = player
            
            present(vc, animated: true) {
                player.play()
            }
        }
    
    func toURL(_ string: String?) -> URL? {
        guard let string = string,
              let url = URL(string: string.trimmingCharacters(in: .whitespacesAndNewlines))
        else { return nil }
        return url
    }
    
    func openShareSheet(urlString: String) {

        guard let url = URL(string: urlString) else { return }

        let activityVC = UIActivityViewController(activityItems: [url],
                                                  applicationActivities: nil)

        activityVC.excludedActivityTypes = [.assignToContact]

        present(activityVC, animated: true)
    }
    
}

// MARK: - COLLECTION VIEW METHODS
extension FavoruitesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showingProducts
        ? (viewModel.productList?.count ?? 0)
        : (viewModel.reelsList?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if showingProducts {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilteredStoreCollectionViewCell",for: indexPath) as! FilteredStoreCollectionViewCell
            let data = viewModel.productList?[indexPath.row]
            cell.configDataForFavouites(data: data)
            cell.wishlistButtonTapped = { [weak self, weak cell] in
                guard
                    let self = self,
                    let cell = cell,
                    let currentIndex = collectionView.indexPath(for: cell)?.row
                else { return }
                self.handleWishlistTap(index: currentIndex)
            }
            cell.shareButtonTapped = { [weak self] in
                guard let self = self else { return }
                ShareUtility.shareProduct(
                    image: cell.mainImageView.image,
                    imageURL: data?.productVariants?.first?.variantImage?.first,
                    title: data?.productNameEn ?? "",
                    description: data?.descriptionEn ?? "",
                    link: "https://desynat.com/api/user/product/detail-page/\(data?.id ?? 0)",
                    from: self
                )
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReelsCollectionViewCell",for: indexPath) as! ReelsCollectionViewCell
            let data = viewModel.reelsList?[indexPath.row]
            cell.configData(data: data?.reelDetails)
            cell.likeButton.setImage(UIImage(named: "selectedHeartImage"), for: .normal)
            cell.onLikeTapped = { [weak self] in
                guard let self = self else { return }
                
                let reelId = data?.reelID ?? 0          // ← Use the data you already have here
                if reelId == 0 { return }
                
                self.handleReelRemove(reelId: reelId)
            }
            cell.onshareTapped = { [weak self] in
                guard let self = self else { return }
                guard let id = data?.reelID else { return }

//                self.viewModel.selectedReelId = id

                self.viewModel.shareReelsRequest(reelId: id) { link in
                    guard let link = link else { return }
                    self.openShareSheet(urlString: link)
                }
            }
            cell.onPlayTapped = { [weak self] in
//                guard let self = self else { return }
//                videoURL = toURL(data?.reelDetails?.file ?? "")
//                playVideo()
                let nextVC = ReelsScrollViewController.instantiate(fromAppStoryboard: .Catalog)
                nextVC.isComingFromMywishlist = true
                nextVC.modalPresentationStyle = .fullScreen
                self?.navigationController?.present(nextVC, animated: false)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if showingProducts {
            let nextVC = ProductDetailViewController.instantiate(fromAppStoryboard: .Catalog)
            nextVC.productId = viewModel.productList?[indexPath.row].id
            navigationController?.pushViewController(nextVC, animated: true)
        } else {
            let nextVC = ReelsScrollViewController.instantiate(fromAppStoryboard: .Catalog)
            nextVC.isComingFromMywishlist = true
            nextVC.modalPresentationStyle = .fullScreen
            self.navigationController?.present(nextVC, animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if showingProducts {
            let spacing: CGFloat = 10
            let totalSpacing = spacing * 2
            let width = (collectionView.frame.width - totalSpacing) / 2
            return CGSize(width: width, height: 220)
        } else {
            let spacing: CGFloat = 10
            let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
            let width = (collectionView.frame.width - totalSpacing) / 2
            return CGSize(width: width, height: 275)
        }
    }
    
}
