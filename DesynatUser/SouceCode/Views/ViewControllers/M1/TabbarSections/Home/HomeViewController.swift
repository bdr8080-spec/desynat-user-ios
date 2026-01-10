//
//  HomeViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit
import SDWebImage
import AVFAudio
import Speech

class HomeViewController: UIViewController {
  
  
  @IBOutlet weak var searchTF: UITextField!
  @IBOutlet weak var noCatgeoriesFoundLabel: UILabel!
  @IBOutlet weak var heightConstraintOfNewestProductCollectionView: NSLayoutConstraint!
  @IBOutlet weak var browseDiscountPageController: UIPageControl!
  @IBOutlet weak var browsePrimiumPageController: UIPageControl!
  @IBOutlet weak var heightConstraintOfSuggestedStoreCollectionView: NSLayoutConstraint!
  @IBOutlet weak var heightConstraintOfCategoryColelctionView: NSLayoutConstraint!
  @IBOutlet weak var bannerPageController: UIPageControl!
  @IBOutlet weak var lblLocatioin: UILabel!
  @IBOutlet weak var imgProfile: CustomImageView!
  @IBOutlet weak var lblUserName: UILabel!
  
  @IBOutlet weak var bannerCollectionView: UICollectionView! {
    didSet {
      bannerCollectionView.registerCellFromNib(cellID: "HomeBannerCollectionViewCell")
    }
  }
  @IBOutlet weak var categoriesCollectionView: UICollectionView! {
    didSet {
      categoriesCollectionView.registerCellFromNib(cellID: "CategoriesCollectionViewCell")
    }
  }
  @IBOutlet weak var suggestedStoresCollectionView: UICollectionView! {
    didSet {
      suggestedStoresCollectionView.registerCellFromNib(cellID: "SuggestedStoresCollectionViewCell")
    }
  }
  @IBOutlet weak var bestSellingCollectionView: UICollectionView! {
    didSet {
      bestSellingCollectionView.registerCellFromNib(cellID: "BestSellingsCollectionViewCell")
    }
  }
  @IBOutlet weak var browsePrimiumCollectionView: UICollectionView! {
    didSet {
      browsePrimiumCollectionView.registerCellFromNib(cellID: "HomeBannerCollectionViewCell")
    }
  }
  @IBOutlet weak var topRatedCollectionView: UICollectionView! {
    didSet {
      topRatedCollectionView.registerCellFromNib(cellID: "BestSellingsCollectionViewCell")
    }
  }
  @IBOutlet weak var bowseSomeDisCountCollectionView: UICollectionView! {
    didSet {
      bowseSomeDisCountCollectionView.registerCellFromNib(cellID: "HomeBannerCollectionViewCell")
    }
  }
  @IBOutlet weak var newestProductsCollectionView: UICollectionView! {
    didSet {
      newestProductsCollectionView.registerCellFromNib(cellID: "BestSellingsCollectionViewCell")
    }
  }
  
  @IBOutlet weak var categoriesSectionCollectionView: UICollectionView! {
    didSet {
      categoriesSectionCollectionView.registerCellFromNib(cellID: "CategoriesSectionCollectionViewCell")
    }
  }
  
  private var bottomLabels: [UILabel] = []
  private var bannerCount = 5
  private var bestSellCount = 5
  private var newProductCount = 6
  //    private var categories = ["Abaya", "Kurti set", "Abaya", "Shoes", "Maxi Dress", "Cord Set"]
  private var suggestedStores = ["Abaya", "Kurti set", "Abaya", "Shoes", "Maxi", "Cord", "Abaya", "Shoes", "Maxi", "Cord"]
  
  let isGuestLogin = UserDefaults.standard.string(forKey:"isGuestLogin")
  //    private var categoriesSection = ["Men", "Women", "Kids"]
  
  private lazy var viewModel = HomeViewModel(hostVC: self)
  var slecetdCategoryId: Int? = 0
  // MARK: - Speech Recognition
  private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
  private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
  private var recognitionTask: SFSpeechRecognitionTask?
  private let audioEngine = AVAudioEngine()
  private var isListening = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bannerPageController.numberOfPages = bannerCount
    viewModel.getCategoriesListApi()
    showUserData()
    requestPermissions()
    
//    showToast(msg: hasShownFullscreenBanner)
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel.getAllFullscreenBannersList()
    
  }
  
  

  private func requestPermissions() {
    SFSpeechRecognizer.requestAuthorization { _ in }
    AVAudioSession.sharedInstance().requestRecordPermission { _ in }
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    DispatchQueue.main.async {
      self.updateCollectionsHeight()
    }
  }
  
  // MARK: - Page Control Tap Handling
  @IBAction func pageControlChanged(_ sender: UIPageControl) {
    let page = sender.currentPage
    let indexPath = IndexPath(item: page, section: 0)
    bannerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
  }
  
  @IBAction func browsePrimiumChanges(_ sender: UIPageControl) {
    let page = sender.currentPage
    let indexPath = IndexPath(item: page, section: 0)
    browsePrimiumCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
  }
  
  @IBAction func browseDiscountChanges(_ sender: UIPageControl) {
    let page = sender.currentPage
    let indexPath = IndexPath(item: page, section: 0)
    bowseSomeDisCountCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
  }
  
  @IBAction func changeLocationButtonAction(_ sender: Any) {
    let vc = LocationViewController.instantiate(fromAppStoryboard: .Profile)
    vc.comingReason = .fromHome
    vc.locationCallBack = { fullAddress, locality, city, state, country, pincode, latitude, longitude in
      self.lblLocatioin.text = fullAddress
    }
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  
  @IBAction func lieDidTapped(_ sender: Any) {
    let vc = FavoruitesViewController.instantiate(fromAppStoryboard: .Catalog)
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func micDidTapped(_ sender: UIButton) {
    if isListening {
      stopListening()
      sender.setImage(UIImage(systemName: "mic"), for: .normal)
    } else {
      startListening()
      sender.setImage(UIImage(systemName: "mic.fill"), for: .normal)
      sender.tintColor = .systemRed // optional: show it's active
    }
  }
  
  @IBAction func btnSearch(_ sender: Any) {
    let vc = SearchVC.instantiate(fromAppStoryboard: .MyOrder)
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func chatDidTapped(_ sender: Any) {
    let nextVC = ChatInboxListViewController.instantiate(fromAppStoryboard: .Chat)
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
  // MARK: - Start Listening (Speech → Text)
  private func startListening() {
    // Reset everything
    recognitionTask?.cancel()
    recognitionTask = nil
    recognitionRequest = nil
    
    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
      try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    } catch {
      print("Audio session error: \(error)")
      return
    }
    
    recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    guard let request = recognitionRequest else { return }
    request.shouldReportPartialResults = true
    
    recognitionTask = speechRecognizer?.recognitionTask(with: request) { [weak self] result, error in
      guard let self = self else { return }
      
      if let result = result {
        let text = result.bestTranscription.formattedString
        self.searchTF.text = text
        // CALL API HERE FOR SEARCHs
      }
      
      if error != nil || result?.isFinal == true {
        self.stopListening()
        DispatchQueue.main.async {
          (self.searchTF.inputView as? UIButton)?.setImage(UIImage(systemName: "mic"), for: .normal)
        }
      }
    }
    
    let inputNode = audioEngine.inputNode
    let recordingFormat = inputNode.outputFormat(forBus: 0)
    inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
      request.append(buffer)
    }
    
    audioEngine.prepare()
    do {
      try audioEngine.start()
      isListening = true
      searchTF.becomeFirstResponder() // optional: show cursor
    } catch {
      print("Failed to start audio engine: \(error)")
      stopListening()
    }
  }
  
  // MARK: - Stop Listening
  private func stopListening() {
    audioEngine.stop()
    audioEngine.inputNode.removeTap(onBus: 0)
    recognitionRequest?.endAudio()
    recognitionRequest = nil
    recognitionTask?.cancel()
    recognitionTask = nil
    isListening = false
  }
  
  deinit {
    stopListening()
  }
  
  
  private func updateCollectionsHeight() {
    
    heightConstraintOfSuggestedStoreCollectionView.constant = suggestedStoresCollectionView.contentSize.height
    heightConstraintOfNewestProductCollectionView.constant = newestProductsCollectionView.contentSize.height
  }
  
  func updateCategoryCollectionHeight() {
    let itemCount = viewModel.subCategoriesSection.count
    let rows = ceil(Double(itemCount) / 3.0)
    let itemHeight: CGFloat = 120
    let verticalSpacing: CGFloat = 10
    
    let totalHeight = (CGFloat(rows) * itemHeight) + ((CGFloat(rows - 1)) * verticalSpacing)
    heightConstraintOfCategoryColelctionView.constant = totalHeight
  }
  
  private func showUserData() {
    if isGuestLogin == "true" {
      lblUserName.text = "Hello Guest"
      //            imgProfile.image = UIImage(named: "userProfile")
    } else {
      lblUserName.text = "Deliver to \(Global.shared.user?.fullName ?? "")"
      imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.medium
      //            imgProfile.sd_imageIndicator?.startAnimatingIndicator()
      //            imgProfile.sd_setImage(
      //                with: URL(string: Global.shared.user?.profileImage ?? "userProfile"),
      //                placeholderImage: UIImage(named: "userProfile")
      //            ) { [weak imgProfile] _, _, _, _ in
      //                imgProfile?.sd_imageIndicator?.stopAnimatingIndicator()
      //            }
    }
  }
  
  
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch collectionView {
    case bannerCollectionView:
      return bannerCount
    case categoriesCollectionView:
      return viewModel.subCategoriesSection.count
    case suggestedStoresCollectionView:
      return suggestedStores.count
    case bestSellingCollectionView:
      return bestSellCount
    case browsePrimiumCollectionView:
      return bannerCount
    case topRatedCollectionView:
      return bestSellCount
    case bowseSomeDisCountCollectionView:
      return bannerCount
    case topRatedCollectionView:
      return bestSellCount
    case newestProductsCollectionView:
      return newProductCount
    case categoriesSectionCollectionView:
      return viewModel.categoriesSection.count
    default:
      return 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch collectionView {
    case bannerCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCollectionViewCell", for: indexPath) as! HomeBannerCollectionViewCell
      cell.mainImageView.layer.cornerRadius = 0
      return cell
      
    case categoriesCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as! CategoriesCollectionViewCell
      let data = viewModel.subCategoriesSection[indexPath.row]
      cell.configData(data: data)
      return cell
      
    case suggestedStoresCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestedStoresCollectionViewCell", for: indexPath) as! SuggestedStoresCollectionViewCell
      cell.titleLabel.text = suggestedStores[indexPath.row]
      return cell
      
    case bestSellingCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestSellingsCollectionViewCell", for: indexPath) as! BestSellingsCollectionViewCell
      return cell
      
    case browsePrimiumCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCollectionViewCell", for: indexPath) as! HomeBannerCollectionViewCell
      cell.mainImageView.layer.cornerRadius = 8
      return cell
      
    case topRatedCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestSellingsCollectionViewCell", for: indexPath) as! BestSellingsCollectionViewCell
      return cell
      
    case bowseSomeDisCountCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCollectionViewCell", for: indexPath) as! HomeBannerCollectionViewCell
      cell.mainImageView.layer.cornerRadius = 8
      return cell
      
    case newestProductsCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestSellingsCollectionViewCell", for: indexPath) as! BestSellingsCollectionViewCell
      return cell
      
    case categoriesSectionCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesSectionCollectionViewCell", for: indexPath) as! CategoriesSectionCollectionViewCell
      let data = viewModel.categoriesSection[indexPath.row]
      cell.titleLabel.text = data.name
      if viewModel.selectedCategoriesSection == data.id {
        cell.bottomLabel.isHidden = false
      } else {
        cell.bottomLabel.isHidden = true
      }
      return cell
    default:
      return UICollectionViewCell()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch collectionView {
    case bannerCollectionView:
      return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
      
    case categoriesCollectionView:
      //            let spacing: CGFloat = 10
      //            let totalSpacing = spacing * 2
      //            let width = (collectionView.frame.width - totalSpacing) / 3
      //            let height: CGFloat = 125
      //            return CGSize(width: width, height: height)
      let width = (categoriesCollectionView.frame.width - 40) / 3
      let height: CGFloat = 135
      return CGSize(width: width, height: height)
      
    case suggestedStoresCollectionView:
      let width = suggestedStoresCollectionView.frame.width / 5
      let height: CGFloat = 95
      return CGSize(width: width, height: height)
      
    case bestSellingCollectionView:
      let spacing: CGFloat = 10
      let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
      let width = (collectionView.frame.width - totalSpacing) / 2
      return CGSize(width: width, height: bestSellingCollectionView.frame.height)
      
    case browsePrimiumCollectionView:
      return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
      
    case topRatedCollectionView:
      let spacing: CGFloat = 10
      let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
      let width = (collectionView.frame.width - totalSpacing) / 2
      return CGSize(width: width, height: topRatedCollectionView.frame.height)
      
    case bowseSomeDisCountCollectionView:
      return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
      
    case newestProductsCollectionView:
      let spacing: CGFloat = 10
      let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
      let width = (collectionView.frame.width - totalSpacing) / 2
      return CGSize(width: width, height: newestProductsCollectionView.frame.height)
      
    case categoriesSectionCollectionView:
      //             let spacing: CGFloat = 2
      //            let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
      let width = (collectionView.frame.width - 0) / 3
      let height: CGFloat = 35
      return CGSize(width: width, height: height)
      
    default:
      return CGSize.zero
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch collectionView {
    case categoriesSectionCollectionView:
      viewModel.selectedCategoriesSection = viewModel.categoriesSection[indexPath.row].id ?? 1
      categoriesSectionCollectionView.reloadData()
    case categoriesCollectionView:
      let nextVC = StoresViewController.instantiate(fromAppStoryboard: .Catalog)
      nextVC.slectedsubCategoryId = viewModel.selectedCategoriesSection
      self.navigationController?.pushViewController(nextVC, animated: true)
    default:
      print("")
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if collectionView == categoriesCollectionView {
      viewWillLayoutSubviews()
    }
  }
  
  // MARK: - Update Page Control on Scroll
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == bannerCollectionView {
      let pageIndex = Int(round(scrollView.contentOffset.x / bannerCollectionView.frame.width))
      bannerPageController.currentPage = pageIndex
    } else if scrollView == browsePrimiumCollectionView {
      let pageIndex = Int(round(scrollView.contentOffset.x / browsePrimiumCollectionView.frame.width))
      browsePrimiumPageController.currentPage = pageIndex
    } else if scrollView == bowseSomeDisCountCollectionView {
      let pageIndex = Int(round(scrollView.contentOffset.x / bowseSomeDisCountCollectionView.frame.width))
      browseDiscountPageController.currentPage = pageIndex
    }
  }
  
}
