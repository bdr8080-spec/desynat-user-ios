//
//  ProductDetailViewController.swift
//  DesynatUser
//
//  Created by fluper on 18/11/25.
//

import UIKit

class ProductDetailViewController: UIViewController {
  
  @IBOutlet weak var totalItemsInBagLabel: UILabel!
  @IBOutlet weak var womenDeatilsBottomLabel: UILabel!
  @IBOutlet weak var topSpaceForWomenDetails: UILabel!
  @IBOutlet weak var bottomSpaceForWomenDetails: UILabel!
  @IBOutlet weak var bustLabel: UILabel!
  @IBOutlet weak var waistLabel: UILabel!
  @IBOutlet weak var hipLabel: UILabel!
  @IBOutlet weak var shoulderLabel: UILabel!
  @IBOutlet weak var sleeveLengthLabel: UILabel!
  @IBOutlet weak var lengthLabel: UILabel!
  @IBOutlet weak var womenStackView: UIStackView!
  @IBOutlet weak var lengthStackView: UIStackView!
  @IBOutlet weak var sleeveLengthStackView: UIStackView!
  @IBOutlet weak var shoulderView: UIStackView!
  @IBOutlet weak var hipView: UIStackView!
  @IBOutlet weak var bustView: UIStackView!
  @IBOutlet weak var waistView: UIStackView!
  @IBOutlet weak var womenMeasurementView: CustomView!
  @IBOutlet weak var spaceBootmLabel: UILabel!
  @IBOutlet weak var spaceTopLabel: UILabel!
  @IBOutlet weak var customOrderView: CustomView!
  @IBOutlet weak var wishlistButtonOutlet: UIButton!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var pagetitleLabel: UILabel!
  @IBOutlet weak var ratingTableViewHeightConstriant: NSLayoutConstraint!
  @IBOutlet weak var checkDeliveryTableViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var checkDeliveryImageView: UIImageView!
  @IBOutlet weak var specificationTableViewHieghtConstraint: NSLayoutConstraint!
  @IBOutlet weak var imagesPageController: UIPageControl!
  @IBOutlet weak var addToBagView: CustomView!
  @IBOutlet weak var incrementDecrementView: CustomView!
  @IBOutlet weak var bagItemCountView: CustomView!
  @IBOutlet weak var itemCountLabel: UILabel!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var productLabel: UILabel!
  @IBOutlet weak var finalPriceLAbel: UILabel!
  @IBOutlet weak var actualPriceLAbel: CustomLabelFont!
  @IBOutlet weak var discountPercentageLabel: UILabel!
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
  
  private lazy var viewModel = ProductDetailsViewModel(hostVC: self)
  var productId: Int? = 0
  var bagCount: Int = 0
  private var selectedColourIndex = 0
  private var selectedSizeIndex = 0
  private var checkDelivery: [CheckDeliveryModel] = [CheckDeliveryModel(image: "calender", title: "Get it by 24/12/2024"),
                                                     CheckDeliveryModel(image: "cashOnDelivery", title: "Cash on Delivery Available"),
                                                     CheckDeliveryModel(image: "returnExchamge", title: "7 Days Return & 5 days Exchange"),
  ]
  var quantity = 0
  var uniqueColors: [Color] = []
  var filteredVariants: [ProductVariant] = []
  var selectedVariantImages: [String] = []
  var productDetails: ProductDetailsDataModel?
  var selectedVariant: ProductVariant? {
    guard !filteredVariants.isEmpty else { return nil }
    guard selectedSizeIndex >= 0 else { return filteredVariants[0] }
    let safeIndex = min(selectedSizeIndex, filteredVariants.count - 1)
    return filteredVariants[safeIndex]
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initialSetUp()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.getProductDetails()
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
    self.navigationController?.popToRootViewController(animated: false)
    DispatchQueue.main.async {
      if let tabBarVC = self.findTabBarVC() {
        tabBarVC.updateTabSelection(forTag: 3)
      } else {
        print("TabBarVC not found")
      }
    }
  }
  
  @IBAction func addToBagDidTapped(_ sender: Any) {
    quantity = 1
    addProductToCart(forIncrement: true)
    bagCount = bagCount + 1
    totalItemsInBagLabel.text = "(\(bagCount) Items) View My Bag"
  }
  
  
  @IBAction func minusDidTapped(_ sender: Any) {
    if quantity > 1 {
      quantity -= 1
      addProductToCart(forIncrement: false)
    } else {
      quantity = 0
      addToBagView.isHidden = false
      incrementDecrementView.isHidden = true
      bagItemCountView.isHidden = true
      bagCount = bagCount - 1
      totalItemsInBagLabel.text = "(\(bagCount) Items) View My Bag"
    }
  }
  
  @IBAction func plusDidTapped(_ sender: Any) {
    quantity += 1
    addProductToCart(forIncrement: true)   // c
  }
  
  @IBAction func buyNowDidTapped(_ sender: Any) {
    quantity = 1
    guard let productId = productDetails?.id else { return }
    let selectedVariant = filteredVariants[selectedSizeIndex]
    let variantId = selectedVariant.id ?? 0
    viewModel.buyNow(productId: productId, variantId: variantId, quantity: quantity) { [weak self] success in
      guard let self = self else { return }
      if success {
        self.navigationController?.popToRootViewController(animated: false)
        DispatchQueue.main.async {
          if let tabBarVC = self.findTabBarVC() {
            tabBarVC.updateTabSelection(forTag: 3)
          } else {
            print("TabBarVC not found")
          }
        }
      } else {
        showAlert(msg: "Failed to add item to cart. Please try again.")
      }
    }
  }
  
  @IBAction func sizeGuideDidTapped(_ sender: Any) {
    let nextVC = SizeChartViewController.instantiate(fromAppStoryboard: .Catalog)
    nextVC.sizeChartUrl = productDetails?.uploadSizeChart
    self.navigationController?.present(nextVC, animated: true)
  }
  
  @IBAction func wishlistDidTapped(_ sender: Any) {
    guard let productId = productDetails?.id else { return }
    viewModel.addToWishlist(productId: productId) { [weak self] success in
      guard let self = self else { return }
      if success {
        let currentStatus = self.productDetails?.wishlist ?? 0
        let newStatus = currentStatus == 1 ? 0 : 1
        self.productDetails?.wishlist = newStatus
        let wishlist = productDetails?.wishlist ?? 1
        if wishlist == 1 {
          CommonUtils.showToast(message: "Product added to wishlist")
          wishlistButtonOutlet.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
          CommonUtils.showToast(message: "Product removed from wishlist")
          wishlistButtonOutlet.setImage(UIImage(systemName: "heart"), for: .normal)
        }
      } else {
        print("Wishlist API failed")
      }
    }
  }
  
  private func addProductToCart(forIncrement: Bool) {
    guard let productId = productDetails?.id else { return }
    let selectedVariant = filteredVariants[selectedSizeIndex]
    let variantId = selectedVariant.id ?? 0
    viewModel.addToCart(productId: productId, variantId: variantId, quantity: quantity, forIncrement: forIncrement) { [weak self] success in
      guard let self = self else { return }
      if success {
        self.addToBagView.isHidden = true
        self.bagItemCountView.isHidden = false
        self.incrementDecrementView.isHidden = false
        self.itemCountLabel.text = "\(self.quantity)"
      } else {
        showAlert(msg: "Failed to add item to cart. Please try again.")
      }
    }
  }
  
  func prepareVariantData() {
    guard let variants = productDetails?.productVariants else { return }
    let storeName = productDetails?.store?.storeName ?? productDetails?.productNameEn ?? ""
    pagetitleLabel.text = storeName
    productNameLabel.text = productDetails?.productNameEn
    if productDetails?.brand?.nameEnglish == "Other" {
      productLabel.text = productDetails?.otherEn
    } else {
      productLabel.text = productDetails?.brand?.nameEnglish
    }
    
    if productDetails?.customizedProduct == "1" {
      customOrderView.isHidden = false
      spaceTopLabel.isHidden = false
    } else {
      customOrderView.isHidden = true
      spaceTopLabel.isHidden = true
    }
    finalPriceLAbel.text = "\(variants.first?.finalPrice ?? "") KD"
    CommonUtils.setStrikethrough(label: actualPriceLAbel, text: "\(variants.first?.actualPrice ?? "") KD")
    let discountType = variants.first?.discountType ?? "1"
    if discountType == "1" {
      discountPercentageLabel.text = "\(variants.first?.discountValue ?? "")% Off"
    } else {
      discountPercentageLabel.text = "\(variants.first?.discountValue ?? "") KD Off"
    }
    descriptionLabel.text = productDetails?.descriptionEn
    // 1️⃣ Get unique colors
    uniqueColors = Array(
      Dictionary(grouping: variants, by: { $0.color?.id })
        .compactMap { $0.value.first?.color }
    )
    
    let categoryName = productDetails?.category?.name ?? "Women"
    if categoryName == "Women" {
      womenMeasurementView.isHidden = false
      bustView.isHidden = false
      hipView.isHidden = false
      waistView.isHidden = false
      shoulderView.isHidden = false
      sleeveLengthStackView.isHidden = false
      lengthStackView.isHidden = false
      womenStackView.isHidden = false
      topSpaceForWomenDetails.isHidden = false
      bottomSpaceForWomenDetails.isHidden = false
      womenDeatilsBottomLabel.isHidden = false
    } else {
      womenMeasurementView.isHidden = true
      bustView.isHidden = true
      hipView.isHidden = true
      waistView.isHidden = true
      shoulderView.isHidden = true
      sleeveLengthStackView.isHidden = true
      lengthStackView.isHidden = true
      womenStackView.isHidden = true
      topSpaceForWomenDetails.isHidden = true
      bottomSpaceForWomenDetails.isHidden = true
      womenDeatilsBottomLabel.isHidden = true
    }
    
    
    
    // 2️⃣ Default selected color = first color
    selectedColourIndex = 0
    filterVariantsForSelectedColor()
    
    // RELOAD UI
    colorsCollectionView.reloadData()
    sizeCollectionView.reloadData()
    productImageCollectionView.reloadData()
    ratingsTableView.reloadData()
    let wishlist = productDetails?.wishlist ?? 1
    if wishlist == 1 {
      wishlistButtonOutlet.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    } else {
      wishlistButtonOutlet.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    specificationTableView.reloadData()
    checkDeliveryTableView.reloadData()
    //    checkAndUpdateCartStatus()
    checkAndPreselectCartVariant()
    bagCount = productDetails?.addtocartTotalProduct ?? 0
    totalItemsInBagLabel.text = "(\(productDetails?.addtocartTotalProduct ?? 0) Items) View My Bag"
  }
  
  private func checkAndUpdateCartStatus() {
    guard let productDetails = productDetails,
          let cartItem = productDetails.addtocart,
          let currentVariantId = selectedVariant?.id,
          cartItem.productID == productDetails.id,
          cartItem.variantsID == currentVariantId,
          (cartItem.quantity ?? 0) > 0 else {
      // Not in cart or different variant
      quantity = 0
      addToBagView.isHidden = false
      bagItemCountView.isHidden = true
      incrementDecrementView.isHidden = true
      return
    }
    
    // Already in cart and matches current selection
    quantity = cartItem.quantity ?? 1
    addToBagView.isHidden = true
    bagItemCountView.isHidden = false
    incrementDecrementView.isHidden = false
    itemCountLabel.text = "\(quantity)"
  }
  
  private func checkAndPreselectCartVariant() {
    guard let productDetails = productDetails,
          let cartItem = productDetails.addtocart,
          let variants = productDetails.productVariants,
          !variants.isEmpty,
          (cartItem.quantity ?? 0) > 0 else {
      // No item in cart → use default flow
      selectedColourIndex = 0
      filterVariantsForSelectedColor()
      checkAndUpdateCartStatus() // this will hide/show Add to Bag correctly
      return
    }
    
    let cartVariantId = cartItem.variantsID
    let cartProductId = cartItem.productID
    
    guard cartProductId == productDetails.id else { return }
    
    // Find the variant that matches the one in cart
    if let matchingVariant = variants.first(where: { $0.id == cartVariantId }) {
      // Step 1: Select the correct COLOR
      if let colorId = matchingVariant.color?.id,
         let colorIndex = uniqueColors.firstIndex(where: { $0.id == colorId }) {
        selectedColourIndex = colorIndex
      }
      
      // Step 2: Filter variants for selected color
      filterVariantsForSelectedColor()
      
      // Step 3: Now select the correct SIZE within filtered variants
      if let sizeIndex = filteredVariants.firstIndex(where: { $0.id == cartVariantId }) {
        selectedSizeIndex = sizeIndex
      }
      
      // Step 4: Update images, price, measurements, etc.
      updateImagesForSelectedSize()
      updateUIForSelectedVariant()
      
      // Step 5: Update quantity from cart
      quantity = cartItem.quantity ?? 1
      
      // Step 6: Update UI to show increment/decrement view
      addToBagView.isHidden = true
      incrementDecrementView.isHidden = false
      bagItemCountView.isHidden = false
      itemCountLabel.text = "\(quantity)"
      
      // Step 7: Scroll and highlight selected color & size
      DispatchQueue.main.async {
        if self.uniqueColors.count > self.selectedColourIndex {
          let colorIndexPath = IndexPath(item: self.selectedColourIndex, section: 0)
          self.colorsCollectionView.selectItem(at: colorIndexPath, animated: false, scrollPosition: .centeredHorizontally)
        }
        if self.selectedSizeIndex >= 0 && self.selectedSizeIndex < self.filteredVariants.count {
          let sizeIndexPath = IndexPath(item: self.selectedSizeIndex, section: 0)
          self.sizeCollectionView.selectItem(at: sizeIndexPath, animated: false, scrollPosition: .centeredHorizontally)
        }
      }
    } else {
      // Cart item exists but variant not found → fallback to default
      selectedColourIndex = 0
      filterVariantsForSelectedColor()
      checkAndUpdateCartStatus()
    }
    
    // Reload collections to reflect selection
    colorsCollectionView.reloadData()
    sizeCollectionView.reloadData()
  }
  
  private func updateUIForSelectedVariant() {
    guard let selectedVariant = self.selectedVariant else { return }
    
    // 1. Price
    let finalPrice = selectedVariant.finalPrice ?? "0"
    finalPriceLAbel.text = "\(finalPrice) KD"
    
    // 2. Actual Price (strikethrough)
    let actualPrice = selectedVariant.actualPrice ?? "0"
    CommonUtils.setStrikethrough(label: actualPriceLAbel, text: "\(actualPrice) KD")
    
    // 3. Discount
    let discountType = selectedVariant.discountType ?? "1"
    let discountValue = selectedVariant.discountValue ?? "0"
    
    if discountType == "1" {
      discountPercentageLabel.text = "\(discountValue)% Off"
    } else {
      discountPercentageLabel.text = "\(discountValue) KD Off"
    }
    
    bustLabel.text = selectedVariant.bust ?? "-"
    hipLabel.text = selectedVariant.hip ?? "-"
    waistLabel.text = selectedVariant.waist ?? "-"
    shoulderLabel.text = selectedVariant.shoulder ?? "-"
    sleeveLengthLabel.text = selectedVariant.sleeveLength ?? "-"
    lengthLabel.text = selectedVariant.length ?? "-"
  }
  
  private func filterVariantsForSelectedColor() {
    guard let variants = productDetails?.productVariants,
          !variants.isEmpty,
          selectedColourIndex < uniqueColors.count else {
      return
    }
    
    let selectedColor = uniqueColors[selectedColourIndex]
    
    // Filter variants for selected color
    filteredVariants = variants.filter { $0.color?.id == selectedColor.id }
    
    // Select first available size
    selectFirstAvailableSize()
    
    // Reset Add to Bag state every time color changes
    addToBagView.alpha = 1
    addToBagView.isUserInteractionEnabled = true
    
    if selectedSizeIndex >= 0 {
      // At least one size IN STOCK
      updateImagesForSelectedSize()
      updateUIForSelectedVariant()
    } else {
      // No size in stock
      selectedVariantImages = []
      productImageCollectionView.reloadData()
      
      finalPriceLAbel.text = "-"
      actualPriceLAbel.text = "-"
      discountPercentageLabel.text = ""
      
      // Disable Add to Bag (no sizes)
      addToBagView.isHidden = false
      addToBagView.alpha = 0.4
      addToBagView.isUserInteractionEnabled = false
    }
    
    // Reload UI
    sizeCollectionView.reloadData()
    colorsCollectionView.reloadData()
    resetImageCarouselToFirst()
    
    // Highlight selected size ONLY if in-stock
    if selectedSizeIndex >= 0 {
      DispatchQueue.main.async {
        let indexPath = IndexPath(item: self.selectedSizeIndex, section: 0)
        self.sizeCollectionView.selectItem(at: indexPath,
                                           animated: false,
                                           scrollPosition: .centeredHorizontally)
      }
    }
    
    sizeCollectionView.reloadData()
    colorsCollectionView.reloadData()
    resetImageCarouselToFirst()
    
    // Add this:
    checkAndUpdateCartStatus()
  }
  
  private func updateImagesForSelectedSize() {
    guard !filteredVariants.isEmpty else {
      selectedVariantImages = []
      imagesPageController.numberOfPages = 0
      productImageCollectionView.reloadData()
      return
    }
    
    let safeIndex = min(selectedSizeIndex, filteredVariants.count - 1)
    let variant = filteredVariants[safeIndex]
    
    selectedVariantImages = variant.variantImage ?? []
    
    imagesPageController.numberOfPages = selectedVariantImages.count
    imagesPageController.currentPage = 0
    
    productImageCollectionView.reloadData()
    resetImageCarouselToFirst()
    
    updateUIForSelectedVariant()
  }
  
  private func resetImageCarouselToFirst() {
    guard !selectedVariantImages.isEmpty else {
      imagesPageController.currentPage = 0
      imagesPageController.numberOfPages = 0
      return
    }
    
    imagesPageController.numberOfPages = selectedVariantImages.count
    imagesPageController.currentPage = 0
    
    productImageCollectionView.layoutIfNeeded()
    
    let firstIndexPath = IndexPath(item: 0, section: 0)
    productImageCollectionView.scrollToItem(at: firstIndexPath,
                                            at: .centeredHorizontally,
                                            animated: false)
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
  
  private func selectFirstAvailableSize() {
    if let index = filteredVariants.firstIndex(where: {
      (Int($0.totalStock ?? "0") ?? 0) > 0
    }) {
      selectedSizeIndex = index
    } else {
      // If NO SIZE is in stock
      selectedSizeIndex = -1
    }
  }
  
}

extension ProductDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch collectionView {
    case productImageCollectionView:
      return selectedVariantImages.count
    case colorsCollectionView:
      return uniqueColors.count
    case sizeCollectionView:
      return filteredVariants.count
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
      let img = selectedVariantImages[indexPath.row]
      cell.configData(data: img)
      return cell
    case colorsCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorsCollectionViewCell", for: indexPath) as! ColorsCollectionViewCell
      let colorData = uniqueColors[indexPath.row]
      cell.mainView.backgroundColor = UIColor(hex: colorData.hexCode ?? "#FFFFFF")
      
      cell.borderView.layer.borderColor =
      (selectedColourIndex == indexPath.row ? UIColor.darkBrown : UIColor.clear).cgColor
      
      return cell
    case sizeCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeVariantCollectionViewCell", for: indexPath) as! SizeVariantCollectionViewCell
      let variant = filteredVariants[indexPath.row]
      cell.titleLabel.text = variant.size?.name
      let stock = Int(variant.totalStock ?? "0") ?? 0
      if stock > 0 {
        cell.titleLabel.textColor = .black
        cell.mainView.alpha = 1.0
        cell.mainView.layer.borderColor =
        (selectedSizeIndex == indexPath.row ? UIColor.darkBrown : UIColor.lightGray).cgColor
      } else {
        cell.titleLabel.textColor = .gray
        cell.mainView.layer.borderColor = UIColor.lightGray.cgColor
        cell.mainView.alpha = 0.5
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
      guard let images = selectedVariant?.variantImage else { return }
      let vc = FullscreenGalleryViewController()
      vc.images = images
      vc.startIndex = indexPath.row
      vc.modalPresentationStyle = .fullScreen
      present(vc, animated: true)
    case colorsCollectionView:
      selectedColourIndex = indexPath.row
      filterVariantsForSelectedColor()
      colorsCollectionView.reloadData()
      colorsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
      checkAndUpdateCartStatus()
    case sizeCollectionView:
      let variant = filteredVariants[indexPath.row]
      let stock = Int(variant.totalStock ?? "0") ?? 0
      guard stock > 0 else { return }
      
      selectedSizeIndex = indexPath.row
      updateUIForSelectedVariant()
      updateImagesForSelectedSize() // if you want images to update
      sizeCollectionView.reloadData()
      
      // Add this:
      checkAndUpdateCartStatus()
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
      return productDetails?.productSpecifications?.count ?? 0
    case checkDeliveryTableView:
      return checkDelivery.count
    case ratingsTableView:
      return productDetails?.review?.count ?? 0
    default:
      return 0
    }
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch tableView {
    case specificationTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
      cell.titleLabel.text = "● \(productDetails?.productSpecifications?[indexPath.row].nameEn ?? "")"
      return cell
    case checkDeliveryTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "FiltersOptionsTableViewCell", for: indexPath) as! FiltersOptionsTableViewCell
      let data = checkDelivery[indexPath.row]
      
      cell.selectionImageView.image = UIImage(named: data.image ?? "")
      cell.colourView.isHidden = true
      cell.mainContentView.backgroundColor = .clear
      
      let cod = productDetails?.cashOnDelivery ?? "1"
      let exchangable = productDetails?.productExchangable ?? "1"
      let returnable = productDetails?.productReturn ?? "1"
      
      switch indexPath.row {
        
      case 0:
        cell.titleLabel.text = data.title
        
      case 1:
        cell.titleLabel.text = (cod == "1") ?
        "Cash on Delivery Available" :
        "Cash on Delivery Not Available"
        
      case 2:
        
        var title = ""
        if returnable == "1" {
          let days = productDetails?.returnDays ?? "0"
          title += "\(days) Days Return"
        } else {
          title += "Non Returnable"
        }
        
        title += " & "
        if exchangable == "1" {
          let days = productDetails?.exchangableDays ?? "0"
          title += "\(days) Days Exchange"
        } else {
          title += "Non Exchangeable"
        }
        cell.titleLabel.text = title
      default:
        cell.titleLabel.text = ""
      }
      return cell
      
    case ratingsTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "ProductRatingTableViewCell", for: indexPath) as! ProductRatingTableViewCell
      let data = productDetails?.review?[indexPath.row]
      cell.configData(data: data)
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
