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
    
    // MARK: - Property Decalaration
    private lazy var viewModel = RateProductOrderViewModel(hostVC: self)
    var orderId: Int?
    var orderDetailId: Int?
    var ratingDone: (() -> Void)?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        productRatingView.rating = 0
        storeRatingView.rating = 0
        submitButton.isEnabled = false
        submitButton.alpha = 0.65
        setupRatingObservers()
    }

    // MARK: - Button's Action
    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func submitDidTapped(_ sender: Any) {
        let productRating = productRatingView.rating
        let storeRating = storeRatingView.rating
        let param: [String: Any] = ["order_id": orderId ?? "",
                                    "orderdetails_id": orderDetailId ?? "",
                                    "product_rating": productRating,
                                    "product_review": productReviewTF.text ?? "",
                                    //                                "product_image"
                                    "store_rating": storeRating,
                                    "store_review": storeReviewTF.text ?? "",
                                    //                                "store_image"
        ]
        viewModel.addRatingToRequest(param: param)
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
