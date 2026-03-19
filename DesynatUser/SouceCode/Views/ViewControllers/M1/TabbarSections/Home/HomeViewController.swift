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
    
    // MARK: - IBOutlet's
    @IBOutlet weak var noCnterHomeBannersFoundLabel: UILabel!
    @IBOutlet weak var noTopHomeBannersFoundLabel: UILabel!
    @IBOutlet weak var browseBannersView: UIView!
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
    
    // MARK: - Property Decalaration
    private var bottomLabels: [UILabel] = []
    private var bannerCount = 5
    private var bestSellCount = 5
    private var newProductCount = 6
    private var suggestedStores = ["Abaya", "Kurti set", "Abaya", "Shoes", "Maxi", "Cord", "Abaya", "Shoes", "Maxi", "Cord"]
    let isGuestLogin = UserDefaults.standard.string(forKey:"isGuestLogin")
    private lazy var viewModel = HomeViewModel(hostVC: self)
    var slecetdCategoryId: Int? = 0
    private var bannerAutoScrollTimer: Timer?
    private var currentBannerIndex = 0
    private var premiumAutoScrollTimer: Timer?
    private var discountAutoScrollTimer: Timer?
    private var currentPremiumIndex = 0
    private var currentDiscountIndex = 0
    private let autoScrollDelay: TimeInterval = 6
    
    // MARK: - Speech Recognition
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var isListening = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getCategoriesListApi()
        showUserData()
        requestPermissions()
        viewModel.getTopHomeBannersListApi()
        viewModel.getCenterHomeBannersListApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startBannerAutoScroll()
        startPremiumAutoScroll()
        startDiscountAutoScroll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getAllFullscreenBannersList()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopBannerAutoScroll()
        stopPremiumAutoScroll()
        stopDiscountAutoScroll()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.async {
            self.updateCollectionsHeight()
        }
    }
    
    // MARK: - Button's Action
    @IBAction func pageControlChanged(_ sender: UIPageControl) {
        currentBannerIndex = sender.currentPage
        let indexPath = IndexPath(item: currentBannerIndex, section: 0)
        bannerCollectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
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
        vc.locationCallBack = { fullAddress,  localityName, locality, city, state, country, pincode, latitude, longitude in
            self.lblLocatioin.text = fullAddress
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func lieDidTapped(_ sender: Any) {
        let isGuestUser = UserDefaults.standard.string(forKey: "isGuestLogin") ?? "false"
        if isGuestUser != "true" {
            let vc = FavoruitesViewController.instantiate(fromAppStoryboard: .Catalog)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            showLoginAlert()
        }
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
        let isGuestUser = UserDefaults.standard.string(forKey: "isGuestLogin") ?? "false"
        if isGuestUser != "true" {
            let vc = SearchVC.instantiate(fromAppStoryboard: .MyOrder)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            showLoginAlert()
        }
    }
    
    @IBAction func chatDidTapped(_ sender: Any) {
        let isGuestUser = UserDefaults.standard.string(forKey: "isGuestLogin") ?? "false"
        if isGuestUser != "true" {
            let nextVC = ChatInboxListViewController.instantiate(fromAppStoryboard: .Chat)
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else {
            showLoginAlert()
        }
    }
    
    @IBAction func notificationDidTapped(_ sender: Any) {
        let nextVC = NotificationListViewController.instantiate(fromAppStoryboard: .Chat)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK: Function's declaration
    private func requestPermissions() {
        SFSpeechRecognizer.requestAuthorization { status in
            print("Speech permission: \(status)")
        }
        
        if #available(iOS 17.0, *) {
            AVAudioApplication.requestRecordPermission { granted in
                DispatchQueue.main.async {
                    print("Mic permission: \(granted)")
                }
            }
        } else {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async {
                    print("Mic permission: \(granted)")
                }
            }
        }
    }
    
    // MARK: - Start Listening (Speech → Text)
    private func startListening() {
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
    
    //MARK: Function's declaration
    func startBannerAutoScroll() {
        stopBannerAutoScroll() // prevent duplicate timers
        bannerAutoScrollTimer = Timer.scheduledTimer(
            timeInterval: autoScrollDelay,
            target: self,
            selector: #selector(autoScrollBanner),
            userInfo: nil,
            repeats: true
        )
    }
    
    private func stopBannerAutoScroll() {
        bannerAutoScrollTimer?.invalidate()
        bannerAutoScrollTimer = nil
    }
    
    func startPremiumAutoScroll() {
        stopPremiumAutoScroll()
        premiumAutoScrollTimer = Timer.scheduledTimer(
            timeInterval: autoScrollDelay,
            target: self,
            selector: #selector(autoScrollPremium),
            userInfo: nil,
            repeats: true
        )
    }
    
    func stopPremiumAutoScroll() {
        premiumAutoScrollTimer?.invalidate()
        premiumAutoScrollTimer = nil
    }
    
    @objc private func autoScrollPremium() {
        let totalItems = viewModel.homeCenterScreenAllBannersList.count
        guard totalItems > 1 else { return }
        
        currentPremiumIndex += 1
        if currentPremiumIndex >= totalItems {
            currentPremiumIndex = 0
        }
        
        let indexPath = IndexPath(item: currentPremiumIndex, section: 0)
        browsePrimiumCollectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
        
        browsePrimiumPageController.currentPage = currentPremiumIndex
    }
    
    func startDiscountAutoScroll() {
        stopDiscountAutoScroll()
        discountAutoScrollTimer = Timer.scheduledTimer(
            timeInterval: autoScrollDelay,
            target: self,
            selector: #selector(autoScrollDiscount),
            userInfo: nil,
            repeats: true
        )
    }
    
    func stopDiscountAutoScroll() {
        discountAutoScrollTimer?.invalidate()
        discountAutoScrollTimer = nil
    }
    
    @objc private func autoScrollDiscount() {
        let totalItems = bannerCount // or your actual data source count
        guard totalItems > 1 else { return }
        
        currentDiscountIndex += 1
        if currentDiscountIndex >= totalItems {
            currentDiscountIndex = 0
        }
        
        let indexPath = IndexPath(item: currentDiscountIndex, section: 0)
        bowseSomeDisCountCollectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
        
        browseDiscountPageController.currentPage = currentDiscountIndex
    }
    
    deinit {
        stopListening()
    }
    
    @objc private func autoScrollBanner() {
        let totalItems = viewModel.homeScreenAllBannersList.count
        guard totalItems > 1 else { return }
        currentBannerIndex += 1
        if currentBannerIndex >= totalItems {
            currentBannerIndex = 0
        }
        let indexPath = IndexPath(item: currentBannerIndex, section: 0)
        bannerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally,animated: true)
        bannerPageController.currentPage = currentBannerIndex
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
        } else {
            lblUserName.text = "Deliver to \(Global.shared.user?.fullName ?? "")"
            imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.medium
        }
    }
}

// MARK: - COLLECTION VIEW METHODS
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case bannerCollectionView:
            let data = viewModel.homeScreenAllBannersList
            if data.isEmpty {
                return 1
            } else {
                return viewModel.homeScreenAllBannersList.count
            }
        case categoriesCollectionView:
            return viewModel.subCategoriesSection.count
        case suggestedStoresCollectionView:
            return suggestedStores.count
        case bestSellingCollectionView:
            return bestSellCount
        case browsePrimiumCollectionView:
            let data = viewModel.homeCenterScreenAllBannersList
            if data.isEmpty {
                return 1
            } else {
                return viewModel.homeCenterScreenAllBannersList.count
            }
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
            let data = viewModel.homeScreenAllBannersList
            if data.isEmpty {
                cell.mainImageView.image = .noBannerFound
            } else {
                cell.configData(data: data[indexPath.row])
            }
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
            let data = viewModel.homeCenterScreenAllBannersList
            if data.isEmpty {
                cell.mainImageView.image = .noBannerFound
            } else {
                cell.configData(data: data[indexPath.row])
            }
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
            nextVC.slecetedCategoryID = viewModel.selectedCategoriesSection
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
            currentBannerIndex = pageIndex
        } else if scrollView == browsePrimiumCollectionView {
            let pageIndex = Int(round(scrollView.contentOffset.x / browsePrimiumCollectionView.frame.width))
            browsePrimiumPageController.currentPage = pageIndex
            currentPremiumIndex = pageIndex
        } else if scrollView == bowseSomeDisCountCollectionView {
            let pageIndex = Int(round(scrollView.contentOffset.x / bowseSomeDisCountCollectionView.frame.width))
            browseDiscountPageController.currentPage = pageIndex
            currentDiscountIndex = pageIndex
        }
    }
}
