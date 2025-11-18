//
//  ProductDetailViewController.swift
//  DesynatUser
//
//  Created by fluper on 18/11/25.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var ratingTableViewHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var checkDeliveryTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkDeliveryImageView: UIImageView!
    @IBOutlet weak var specificationTableViewHieghtConstraint: NSLayoutConstraint!
    @IBOutlet weak var imagesPageController: UIPageControl!
    @IBOutlet weak var addToBagView: CustomView!
    @IBOutlet weak var incrementDecrementView: CustomView!
    @IBOutlet weak var bagItemCountView: CustomView!
    @IBOutlet weak var itemCountLabel: UILabel!
    
    
    @IBOutlet weak var productImageCollectionView: UICollectionView! {
        didSet {
            productImageCollectionView.registerCellFromNib(cellID: "ProductDetailImageCollectionViewCell")
        }
    }
    
    @IBOutlet weak var colorsCollectionView: UICollectionView! {
        didSet {
            colorsCollectionView.registerCellFromNib(cellID: "ColorsCollectionViewCell")
        }
    }
    
    @IBOutlet weak var sizeCollectionView: UICollectionView! {
        didSet {
            sizeCollectionView.registerCellFromNib(cellID: "SizeVariantCollectionViewCell")
        }
    }
    
    @IBOutlet weak var specificationTableView: UITableView! {
        didSet {
            specificationTableView.registerCellFromNib(cellID: "ListTableViewCell")
        }
    }
    
    @IBOutlet weak var checkDeliveryTableView: UITableView! {
        didSet {
            checkDeliveryTableView.registerCellFromNib(cellID: "FiltersOptionsTableViewCell")
        }
    }
    
    @IBOutlet weak var ratingsTableView: UITableView! {
        didSet {
            ratingsTableView.registerCellFromNib(cellID: "ProductRatingTableViewCell")
        }
    }
    
    @IBOutlet weak var similarProductCollectionView: UICollectionView! {
        didSet {
            similarProductCollectionView.registerCellFromNib(cellID: "BestSellingsCollectionViewCell")
        }
    }
    
    
    private var selectedColourIndex = 0
    private var selectedSizeIndex = 0
    private var speifcationArray = ["Type 1- Feature", "Type 2- Feature", "Type 3- Feature"]
    private var checkDelivery: [CheckDeliveryModel] = [CheckDeliveryModel(image: "calender", title: "Get it by 24/12/2024"),
                                                       CheckDeliveryModel(image: "cashOnDelivery", title: "Cash on Delivery Available"),
                                                       CheckDeliveryModel(image: "returnExchamge", title: "7 Days Return & 5 days Exchange"),
    ]
    var quantity = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.async {
            self.checkDeliveryTableViewHeightConstraint.constant = self.checkDeliveryTableView.contentSize.height
            self.specificationTableViewHieghtConstraint.constant = self.specificationTableView.contentSize.height
            self.ratingTableViewHeightConstriant.constant = self.ratingsTableView.contentSize.height
        }
    }
    
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Page Control Tap Handling
    @IBAction func pageControlChanged(_ sender: UIPageControl) {
        let page = sender.currentPage
        let indexPath = IndexPath(item: page, section: 0)
        productImageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func viewMyBagDidTapped(_ sender: Any) {
        
    }
    
    @IBAction func addToBagDidTapped(_ sender: Any) {
        addToBagView.isHidden = true
        bagItemCountView.isHidden = false
        incrementDecrementView.isHidden = false
        quantity = 1
        updateUI()
    }
    
    
    @IBAction func minusDidTapped(_ sender: Any) {
        if quantity > 1 {
            quantity -= 1
        } else if quantity == 1 {
            quantity = 0
            addToBagView.isHidden = false
            incrementDecrementView.isHidden = true
            bagItemCountView.isHidden = true
            return
        }
        updateUI()
    }
    
    @IBAction func plusDidTapped(_ sender: Any) {
        quantity += 1
        updateUI()
    }
    
    @IBAction func buyNowDidTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: false)

            DispatchQueue.main.async {
                if let tabBarVC = self.findTabBarVC() {
                    tabBarVC.updateTabSelection(forTag: 3)
                } else {
                    print("❌ TabBarVC not found")
                }
            }
    }
    
    private func findTabBarVC() -> TabBarVC? {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            for window in scene.windows {
                if let tabVC = window.rootViewController as? TabBarVC {
                    return tabVC
                }
                if let nav = window.rootViewController as? UINavigationController {
                    if let tabVC = nav.viewControllers.first(where: { $0 is TabBarVC }) as? TabBarVC {
                        return tabVC
                    }
                }
                if let presented = window.rootViewController?.presentedViewController as? TabBarVC {
                    return presented
                }
            }
        }
        return nil
    }
    
    private func updateUI() {
        bagItemCountView.isHidden = false
        incrementDecrementView.isHidden = false
        addToBagView.isHidden = true
        itemCountLabel.text = "\(quantity)"
    }
    
    private func initialSetUp() {
        checkDeliveryImageView.layer.cornerRadius = 12
        checkDeliveryImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner] 
        checkDeliveryImageView.clipsToBounds = true
        bagItemCountView.isHidden = true
        addToBagView.isHidden = false
        incrementDecrementView.isHidden = true
    }
    
}

extension ProductDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case productImageCollectionView:
            return 5
        case colorsCollectionView:
            return 5
        case sizeCollectionView:
            return 5
        case similarProductCollectionView:
            return 5
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case productImageCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailImageCollectionViewCell", for: indexPath) as! ProductDetailImageCollectionViewCell
            return cell
        case colorsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorsCollectionViewCell", for: indexPath) as! ColorsCollectionViewCell
            if selectedColourIndex == indexPath.row {
                cell.borderView.layer.borderColor = UIColor.darkBrown.cgColor
            } else {
                cell.borderView.layer.borderColor = UIColor.white.cgColor
            }
            return cell
        case sizeCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeVariantCollectionViewCell", for: indexPath) as! SizeVariantCollectionViewCell
            if selectedSizeIndex == indexPath.row {
                cell.mainView.layer.borderColor = UIColor.darkBrown.cgColor
            } else {
                cell.mainView.layer.borderColor = UIColor.lightGray.cgColor
            }
            return cell
        case similarProductCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestSellingsCollectionViewCell", for: indexPath) as! BestSellingsCollectionViewCell
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case productImageCollectionView:
            print("")
        case colorsCollectionView:
            selectedColourIndex = indexPath.row
            colorsCollectionView.reloadData()
        case sizeCollectionView:
            selectedSizeIndex = indexPath.row
            sizeCollectionView.reloadData()
        case similarProductCollectionView:
            print("")
        default:
            print("")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case productImageCollectionView:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        case colorsCollectionView:
            return CGSize(width: 54, height: 45)
        case sizeCollectionView:
            return CGSize(width: 55, height: 42)
        case similarProductCollectionView:
            let spacing: CGFloat = 10
            let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
            let width = (collectionView.frame.width - totalSpacing) / 2
            return CGSize(width: width, height: similarProductCollectionView.frame.height)
        default:
            return CGSize(width: 0, height: 0)
        }
        
    }
    
    // MARK: - Update Page Control on Scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == productImageCollectionView {
            let pageIndex = Int(round(scrollView.contentOffset.x / productImageCollectionView.frame.width))
            imagesPageController.currentPage = pageIndex
        }
    }
    
    
}

extension ProductDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case specificationTableView:
            return speifcationArray.count
        case checkDeliveryTableView:
            return checkDelivery.count
        case ratingsTableView:
            return 2
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case specificationTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
            cell.titleLabel.text = "● \(speifcationArray[indexPath.row])"
            return cell
        case checkDeliveryTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FiltersOptionsTableViewCell", for: indexPath) as! FiltersOptionsTableViewCell
            let data = checkDelivery[indexPath.row]
            cell.titleLabel.text = data.title
            cell.selectionImageView.image = UIImage(named: data.image)
            cell.colourView.isHidden = true
            cell.mainContentView.backgroundColor = .clear
            return cell
        case ratingsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductRatingTableViewCell", for: indexPath) as! ProductRatingTableViewCell
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case specificationTableView:
            return 30
        default:
            return UITableView.automaticDimension
        }
    }
    
}
