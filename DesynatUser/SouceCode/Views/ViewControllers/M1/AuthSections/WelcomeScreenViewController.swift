//
//  WelcomeScreenViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 22/10/25.
//

import UIKit
import JXPageControl

class WelcomeScreenViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var skipButtonOutlet: CustomButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ellipse: BannerPageControl!
    @IBOutlet weak var walkthroghtCollectionView: UICollectionView!
    @IBOutlet weak var previousButtonOutlet: UIButton!
    
    // MARK: - Property Decalaration
    var bannerArray: [WalkthroughModel] = [
        WalkthroughModel(image: UIImage(named: "walk1") ?? UIImage(systemName: "photo")!,
                         name: "Order Item".localiz(),
                         description: "Lorem ipsum dolor sit amet consectetur. Mi ultrices diam sociis volutpat orci non. Commodo pretium urna ut augue ac amet sed.".localiz()),
        WalkthroughModel(image: UIImage(named: "walk2") ?? UIImage(systemName: "photo")!,
                         name: "Product Delivery".localiz(),
                         description: "Lorem ipsum dolor sit amet consectetur. Mi ultrices diam sociis volutpat orci non. Commodo pretium urna ut augue ac amet sed.".localiz()),
        WalkthroughModel(image: UIImage(named: "walk3") ?? UIImage(systemName: "photo")!,
                         name: "Item Tracking".localiz(),
                         description: "Lorem ipsum dolor sit amet consectetur. Mi ultrices diam sociis volutpat orci non. Commodo pretium urna ut augue ac amet sed.".localiz())
    ]
    
    var affiliatedUserArray: [WalkthroughModel] = [
        WalkthroughModel(image: UIImage(named: "walk1") ?? UIImage(systemName: "photo")!,
                         name: "Earn Money".localiz(),
                         description: "Lorem ipsum dolor sit amet consectetur. Mi ultrices diam sociis volutpat orci non. Commodo pretium urna ut augue ac amet sed.".localiz()),
        WalkthroughModel(image: UIImage(named: "walk2") ?? UIImage(systemName: "photo")!,
                         name: "Track Commission".localiz(),
                         description: "Lorem ipsum dolor sit amet consectetur. Mi ultrices diam sociis volutpat orci non. Commodo pretium urna ut augue ac amet sed.".localiz()),
        WalkthroughModel(image: UIImage(named: "walk3") ?? UIImage(systemName: "photo")!,
                         name: "Share Product Link".localiz(),
                         description: "Lorem ipsum dolor sit amet consectetur. Mi ultrices diam sociis volutpat orci non. Commodo pretium urna ut augue ac amet sed.".localiz())
    ]
    var currentCellIndex = 0
    var comingUserRole: UserType = .normalUser
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configurePageControl()
        updateUI(for: 0)
        walkthroghtCollectionView.reloadData()
    }
    
    // MARK: - Button's Action
    @IBAction func forwardNextButtonDidTapped(_ sender: Any) {
        switch comingUserRole {
        case .normalUser:
            if currentCellIndex < bannerArray.count - 1 {
                moveToPage(currentCellIndex + 1)
            } else {
                let vc = LoginViewController.instantiate(fromAppStoryboard: .Main)
                self.navigationController?.pushViewController(vc, animated: true)
                UserDefaults.standard.setValue("false", forKey: "isAppInstall")
            }
        case .affiliateUser:
            if currentCellIndex < affiliatedUserArray.count - 1 {
                moveToPage(currentCellIndex + 1)
            } else {
                let vc = CreateAffiliateUserAccountViewController.instantiate(fromAppStoryboard: .AffiliateUser)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func previousPageDidTapped(_ sender: Any) {
        if currentCellIndex > 0 {
            moveToPage(currentCellIndex - 1)
        }
    }
    
    @IBAction func skipDidTapped(_ sender: Any) {
        switch comingUserRole {
        case .normalUser:
            let vc = LoginViewController.instantiate(fromAppStoryboard: .Main)
            self.navigationController?.pushViewController(vc, animated: true)
            UserDefaults.standard.setValue("false", forKey: "isAppInstall")
        case .affiliateUser:
            let nextVC = CreateAffiliateUserAccountViewController.instantiate(fromAppStoryboard: .AffiliateUser)
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
    }
    
    //MARK: Function's declaration
    private func setupCollectionView() {
        walkthroghtCollectionView.delegate = self
        walkthroghtCollectionView.dataSource = self
        walkthroghtCollectionView.isPagingEnabled = true
        walkthroghtCollectionView.showsHorizontalScrollIndicator = false
        
        if let layout = walkthroghtCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
    }
    
    func configurePageControl() {
        switch comingUserRole {
        case .normalUser:
            ellipse.numberOfPages = bannerArray.count
        case .affiliateUser:
            ellipse.numberOfPages = affiliatedUserArray.count
        }
        ellipse.currentPage = 0
        ellipse.activeSize = CGSize(width: 16, height: 8)
        ellipse.inactiveSize = CGSize(width: 8, height: 8)
        ellipse.activeColor = .brown // Adjust color as needed
        ellipse.inactiveColor = .gray
        ellipse.isUserInteractionEnabled = false
    }
    
    private func moveToPage(_ index: Int) {
        switch comingUserRole {
        case .normalUser:
            guard bannerArray.indices.contains(index) else {
                return
            }
        case .affiliateUser:
            guard affiliatedUserArray.indices.contains(index) else {
                return
            }
        }
        currentCellIndex = index
        let indexPath = IndexPath(item: currentCellIndex, section: 0)
        walkthroghtCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.updateUI(for: self.currentCellIndex)
            self.walkthroghtCollectionView.reloadItems(at: [indexPath])
        }
    }
    
    func updateUI(for index: Int) {
        switch comingUserRole {
        case .normalUser:
            guard bannerArray.indices.contains(index) else { return }
            titleLabel.text = bannerArray[index].name
            descriptionLabel.text = bannerArray[index].description
            ellipse.currentPage = index
            skipButtonOutlet.isHidden = (index == bannerArray.count - 1)
            previousButtonOutlet.isHidden = (index == 0)
        case .affiliateUser:
            guard affiliatedUserArray.indices.contains(index) else { return }
            titleLabel.text = affiliatedUserArray[index].name
            descriptionLabel.text = affiliatedUserArray[index].description
            ellipse.currentPage = index
            skipButtonOutlet.isHidden = (index == affiliatedUserArray.count - 1)
            previousButtonOutlet.isHidden = (index == 0)
        }
        
    }
    
}

// MARK: - COLLECTION VIEW METHODS
extension WelcomeScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch comingUserRole {
        case .normalUser:
            return bannerArray.count
        case .affiliateUser:
            return affiliatedUserArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalkThroughCell", for: indexPath) as! WalkThroughCell
        switch comingUserRole {
        case .normalUser:
            let data = bannerArray[indexPath.row]
            cell.imageWalk.image = nil
            cell.imageWalk.image = data.image
        case .affiliateUser:
            let data = affiliatedUserArray[indexPath.row]
            cell.imageWalk.image = nil
            cell.imageWalk.image = data.image
        }
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        currentCellIndex = page
        updateUI(for: page)
        let indexPath = IndexPath(item: page, section: 0)
        walkthroghtCollectionView.reloadItems(at: [indexPath])
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
//        print("Scroll ended (animation) at page: \(page), offset: \(scrollView.contentOffset)")
        currentCellIndex = page
        updateUI(for: page)
        let indexPath = IndexPath(item: page, section: 0)
        walkthroghtCollectionView.reloadItems(at: [indexPath])
    }
}

extension WelcomeScreenViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: collectionView.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

struct WalkthroughModel {
    var image: UIImage
    var name: String
    var description: String
}
