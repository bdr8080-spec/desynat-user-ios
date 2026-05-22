//
//  RateProductOrderViewController.swift
//  DesynatUser
//
//  Created by fluper on 24/12/25.
//

import UIKit
import Cosmos

class RateProductOrderViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var storeRatingView: CosmosView!
    @IBOutlet weak var productRatingView: CosmosView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var productReviewTF: UITextField!
    @IBOutlet weak var storeReviewTF: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var productReviewCollectionView: UICollectionView! {
        didSet {
            productReviewCollectionView.registerCellFromNib(cellID: "UploadProductImageForRatingCollectionViewCell")
        }
    }
    @IBOutlet weak var productTitleLabel: CustomLabelFont!
    @IBOutlet weak var storeImageCollectionview: UICollectionView! {
        didSet {
            storeImageCollectionview.registerCellFromNib(cellID: "UploadProductImageForRatingCollectionViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    private lazy var viewModel = RateProductOrderViewModel(hostVC: self)
    var orderId: Int?
    var orderDetailId: Int?
    var ratingDone: (() -> Void)?
    var selectedProductImageUrl: [String] = []
    var selectedProductImages: [UIImage] = []
    var selectedStoreProductImageUrl: [String] = []
    var selectedStoreProductImages: [UIImage] = []
    var orderData: OrderModel?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        productRatingView.rating = 0
        storeRatingView.rating = 0
        submitButton.isEnabled = false
        submitButton.alpha = 0.65
        setupRatingObservers()
        productReviewCollectionView.isHidden = true
        storeImageCollectionview.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        productTitleLabel.text = AppLanguageManager.shared.currentLanguage == .ar ? orderData?.productDetails?.productNameAr : orderData?.productDetails?.productNameEn
    }
    
    // MARK: - Button's Action
    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func submitDidTapped(_ sender: Any) {
        let productRating = productRatingView.rating
        let storeRating = storeRatingView.rating
        var param: [String: Any] = ["order_id": orderId ?? "",
                                    "orderdetails_id": orderDetailId ?? "",
                                    "product_rating": productRating,
                                    "product_review": productReviewTF.text ?? "",
                                    "store_rating": storeRating,
                                    "store_review": storeReviewTF.text ?? "",
                                    //                                "store_image"
        ]
        // Send only if images exist
        if !selectedProductImageUrl.isEmpty {
            param["product_image"] = selectedProductImageUrl
        }
        
        // Send only if images exist
        if !selectedStoreProductImageUrl.isEmpty {
            param["store_image"] = selectedStoreProductImageUrl
        }
        viewModel.addRatingToRequest(param: param)
    }
    
    @IBAction func productImageDidTapped(_ sender: Any) {
        ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
            guard let self = self else { return }
            self.viewModel.uploadDocument(file: image, isImage: true) { [weak self] uploadedUrl in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.selectedProductImages.append(image)
                    self.selectedProductImageUrl.append(uploadedUrl)
                    self.productReviewCollectionView.isHidden = self.selectedProductImages.isEmpty
                    self.productReviewCollectionView.reloadData()
                }
            }
        }
    }
    
    @IBAction func storeImageDidTapped(_ sender: Any) {
        ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
            guard let self = self else { return }
            self.viewModel.uploadDocument(file: image, isImage: true) { [weak self] uploadedUrl in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.selectedStoreProductImages.append(image)
                    self.selectedStoreProductImageUrl.append(uploadedUrl)
                    self.storeImageCollectionview.isHidden = self.selectedStoreProductImages.isEmpty
                    self.storeImageCollectionview.reloadData()
                }
            }
        }
    }
    
    //MARK: Function's declaration
    private func initialSetup() {
        titleView.clipsToBounds = true
        titleView.layer.cornerRadius = 32
        titleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setupRatingObservers() {
        productRatingView.didFinishTouchingCosmos = { [weak self] rating in
            self?.updateSubmitButtonState()
        }
        storeRatingView.didFinishTouchingCosmos = { [weak self] rating in
            self?.updateSubmitButtonState()
        }
    }
    
    private func updateSubmitButtonState() {
        // Enable only if at least one rating is given (or both if required)
        let isEnabled = productRatingView.rating > 0 || storeRatingView.rating > 0
        submitButton.isEnabled = isEnabled
        submitButton.alpha = isEnabled ? 1.0 : 0.65
    }
    
    func showSuccess() {
        let successVC = SuccessMsgVC.instantiate(fromAppStoryboard: .MyOrder)
        successVC.message = "Review submitted successfully!".localiz()
        successVC.OnDismiss = { [weak self] in
            self?.dismiss(animated: true) {
                self?.ratingDone?()
            }
        }
        present(successVC, animated: true)
    }
}

extension RateProductOrderViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == storeImageCollectionview {
            return selectedStoreProductImages.count
        } else {
            return selectedProductImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadProductImageForRatingCollectionViewCell", for: indexPath) as! UploadProductImageForRatingCollectionViewCell
        if collectionView == storeImageCollectionview {
            cell.productImageView.image = selectedStoreProductImages[indexPath.row]
            cell.crossButton.isHidden = false
            cell.crossButton.tag = indexPath.row
            cell.crossButton.addTarget(self,action: #selector(deleteStoreImage(_:)), for: .touchUpInside)
        } else {
            cell.productImageView.image = selectedProductImages[indexPath.row]
            cell.crossButton.isHidden = false
            cell.crossButton.tag = indexPath.row
            cell.crossButton.addTarget(self,action: #selector(deleteImage(_:)), for: .touchUpInside)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    @objc func deleteImage(_ sender: UIButton) {
        let index = sender.tag
        guard index < selectedProductImages.count,
              index < selectedProductImageUrl.count else {
            return
        }
        selectedProductImages.remove(at: index)
        selectedProductImageUrl.remove(at: index)
        productReviewCollectionView.isHidden = selectedProductImages.isEmpty
        productReviewCollectionView.reloadData()
    }
    
    @objc func deleteStoreImage(_ sender: UIButton) {
        let index = sender.tag
        guard index < selectedStoreProductImages.count,
              index < selectedStoreProductImageUrl.count else {
            return
        }
        selectedStoreProductImages.remove(at: index)
        selectedStoreProductImageUrl.remove(at: index)
        storeImageCollectionview.isHidden = selectedStoreProductImages.isEmpty
        storeImageCollectionview.reloadData()
    }
}
