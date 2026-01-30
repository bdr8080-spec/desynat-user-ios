//
//  AffiliatedUserTabbarViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 28/01/26.
//

import UIKit

class AffiliatedUserTabbarViewController: UIViewController {

    @IBOutlet weak var paymnetTabImageView: CustomImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var tabButtons: [UIButton]!
    
    var initialTabIndex: Int = 0
    
    override func viewDidLoad() {
      super.viewDidLoad()
      updateTabSelection(forTag: initialTabIndex)
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
    }
    
    @IBAction func tabBarAction(_ sender: UIButton) {
      updateTabSelection(forTag: sender.tag)
    }
    
    func updateTabSelection(forTag tag: Int) {
      loadSubview(forTag: tag)
      setUserButtonImages(selectedTag: tag)
    }
    
    private func setUserButtonImages(selectedTag: Int) {
        let unselectedImages = [
            "homeUnselected",
            "productsAffiliated",
            "showAffiliated",
            "paymentAffiliated",
            "profileUnselected"
        ]

        let selectedImages = [
            "homeSelected",
            "selectedProductAffiliated",
            "showAffiliated",
            "selectedPaymnetAffiliated",
            "profileSelected"
        ]

        let paymentTabIndex = 3

        // ✅ Always control visibility first
//        paymnetTabImageView.isHidden = selectedTag != paymentTabIndex

        // ✅ Update payment image explicitly
        let paymentImageName = (selectedTag == paymentTabIndex)
            ? selectedImages[paymentTabIndex]
            : unselectedImages[paymentTabIndex]

        paymnetTabImageView.image = UIImage(named: paymentImageName)

        // ✅ Update all button images except payment
        for button in tabButtons {
            if button.tag == paymentTabIndex {
                button.setImage(nil, for: .normal) // image handled by imageView
                continue
            }

            let imageName = (button.tag == selectedTag)
                ? selectedImages[button.tag]
                : unselectedImages[button.tag]

            button.setImage(UIImage(named: imageName), for: .normal)
        }
    }

    
//    private func setUserButtonImages(selectedTag: Int) {
//        let unselectedImages = [
//            "homeUnselected",
//            "productsAffiliated",
//            "showAffiliated",
//            "paymentAffiliated",
//            "profileUnselected"
//        ]
//        
//        let selectedImages = [
//            "homeSelected",
//            "selectedProductAffiliated",
//            "showAffiliated",
//            "selectedPaymnetAffiliated",
//            "profileSelected"
//        ]
//
//        for button in tabButtons {
//
//            // ✅ Payment tab = tag 3
//            if button.tag == 3 {
//                button.setImage(nil, for: .normal)
//
//                let imageName = (selectedTag == 3)
//                    ? selectedImages[3]
//                    : unselectedImages[3]
//
//                paymnetTabImageView.image = UIImage(named: imageName)
//                paymnetTabImageView.isHidden = false
//            } else {
//                let imageName = (button.tag == selectedTag)
//                    ? selectedImages[button.tag]
//                    : unselectedImages[button.tag]
//
//                button.setImage(UIImage(named: imageName), for: .normal)
//            }
//        }
//    }

    
//    private func setUserButtonImages(selectedTag: Int) {
//      let unselectedImages = ["homeUnselected", "productsAffiliated", "showAffiliated", "paymentAffiliated", "profileUnselected"]
//      let selectedImages = ["homeSelected", "selectedProductAffiliated", "showAffiliated", "selectedPaymnetAffiliated", "profileSelected"]
//      
////      for button in tabButtons {
////        let imageName = (button.tag == selectedTag) ? selectedImages[button.tag] : unselectedImages[button.tag]
////        button.setImage(UIImage(named: imageName), for: .normal)
////      }
//        for button in tabButtons {
//                // Special handling for index 4
//                if button.tag == 4 {
//                    button.setImage(nil, for: .normal) // optional: remove button image
//                    
//                    let imageName = (selectedTag == 4)
//                        ? selectedImages[4]
//                        : unselectedImages[4]
//                    
//                    paymnetTabImageView.image = UIImage(named: imageName)
//                    paymnetTabImageView.isHidden = false
//                } else {
//                    let imageName = (button.tag == selectedTag)
//                        ? selectedImages[button.tag]
//                        : unselectedImages[button.tag]
//                    
//                    button.setImage(UIImage(named: imageName), for: .normal)
//                }
//            }
//    }
  }

  // MARK: - Load Child VC
  extension AffiliatedUserTabbarViewController {
    func loadSubview(forTag tag: Int) {
      guard let containerView = containerView else { return }
      
      // Remove existing child view
      for child in children {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
      }
      
      // Load new child view controller
      let childVC: UIViewController
      switch tag {
      case 0:
        childVC = AffiliatedUserHomeViewController.instantiate(fromAppStoryboard: .AffiliateUser)
      case 1:
        childVC = AffiliatedUserProductViewController.instantiate(fromAppStoryboard: .AffiliateUser)
      case 2:
        childVC = AffiliatedUserShowViewController.instantiate(fromAppStoryboard: .AffiliateUser)
      case 3:
        childVC = AffiliatedUserPaymentsViewController.instantiate(fromAppStoryboard: .AffiliateUser)
      case 4:
        childVC = AffiliatedUserProfileViewController.instantiate(fromAppStoryboard: .AffiliateUser)
      default:
        return
      }
      
      addChild(childVC)
      childVC.view.frame = containerView.bounds
      containerView.addSubview(childVC.view)
      childVC.didMove(toParent: self)
    }
    
  }
