//
//  TabBarVC.swift
//  Altair
//
//  Created by Hari on 25/07/25.
//

import UIKit

class TabBarVC: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var bagCountLabel: UILabel!
    @IBOutlet weak var bagCountView: CustomView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var tabButtons: [UIButton]!
    
    // MARK: - Property Decalaration
    var initialTabIndex: Int = 0
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTabSelection(forTag: initialTabIndex)
        NotificationCenter.default.addObserver(self, selector: #selector(handleGetBagDetailsApi), name: NSNotification.Name("ItemRemovedFromBag"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBagDetailsApi()
    }
    
    // MARK: - Button's Action
    @IBAction func tabBarAction(_ sender: UIButton) {
        updateTabSelection(forTag: sender.tag)
    }
    
    func updateTabSelection(forTag tag: Int) {
        loadSubview(forTag: tag)
        setUserButtonImages(selectedTag: tag)
    }
    
    private func setUserButtonImages(selectedTag: Int) {
        let unselectedImages = ["homeUnselected", "catalogUnselected", "show", "bagUnselected", "profileUnselected"]
        let selectedImages = ["homeSelected", "catalogSelected", "show", "bagSelected", "profileSelected"]
        
        for button in tabButtons {
            let imageName = (button.tag == selectedTag) ? selectedImages[button.tag] : unselectedImages[button.tag]
            button.setImage(UIImage(named: imageName), for: .normal)
        }
    }
}

// MARK: - Load Child VC
extension TabBarVC {
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
            childVC = HomeViewController.instantiate(fromAppStoryboard: .Home)
        case 1:
            childVC = CatalogViewController.instantiate(fromAppStoryboard: .Home)
        case 2:
            childVC = ShowViewController.instantiate(fromAppStoryboard: .Home)
        case 3:
            childVC = MyBagViewController.instantiate(fromAppStoryboard: .Home)
        case 4:
            childVC = ProfileViewController.instantiate(fromAppStoryboard: .Home)
        default:
            return
        }
        
        addChild(childVC)
        childVC.view.frame = containerView.bounds
        containerView.addSubview(childVC.view)
        childVC.didMove(toParent: self)
    }
    
    @objc func handleGetBagDetailsApi() {
        getBagDetailsApi()
    }
    
    func getBagDetailsApi(){
        let isGuestUser = UserDefaults.standard.string(forKey: "isGuestLogin") ?? "false"
        if isGuestUser != "true" {
            WebService.sharedInstance.gteBagDetails { [self] list in
                let productCount = list.cartData?.count ?? 0
                if productCount > 0 {
                    self.bagCountView.isHidden = false
                    self.bagCountLabel.text = "\(productCount)"
                } else {
                    self.bagCountView.isHidden = true
                }
            }
        }
    }
}
