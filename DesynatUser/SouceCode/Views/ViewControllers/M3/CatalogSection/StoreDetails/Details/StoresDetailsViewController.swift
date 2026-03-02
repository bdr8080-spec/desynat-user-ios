//
//  StoresDetailsViewController.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit
import SDWebImage
import AVFAudio
import Speech

class StoresDetailsViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var noReelsFound: UILabel!
    @IBOutlet weak var statusView: CustomView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var qrImageView: CustomImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var pageTitleLabel: UILabel!
    @IBOutlet weak var storeTitleLabel: UILabel!
    @IBOutlet weak var userProfileImage: CustomImageView!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var noProductsFoundLabel: UILabel!
    @IBOutlet weak var reelsCollectionViewHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var searchView: CustomView!
    @IBOutlet weak var sortFilterView: UIView!
    @IBOutlet weak var storesCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var reelsButtonOutlet: CustomButton!
    @IBOutlet weak var productButtonOutlet: CustomButton!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var reelsTitlLabel: UILabel!
    @IBOutlet weak var storiesCollectionView: UICollectionView! {
        didSet {
            storiesCollectionView.registerCellFromNib(cellID: "StoresDetailsCollectionViewCell")
        }
    }
    @IBOutlet weak var storesCollectionView: UICollectionView! {
        didSet {
            storesCollectionView.registerCellFromNib(cellID: "FilteredStoreCollectionViewCell")
        }
    }
    @IBOutlet weak var reelsCollectionView: UICollectionView! {
        didSet {
            reelsCollectionView.registerCellFromNib(cellID: "ReelsCollectionViewCell")
        }a
    }
    
    // MARK: - Property Decalaration
    private lazy var viewModel = StoreDetailsViewModel(hostVC: self)
    private var searchWorkItem: DispatchWorkItem?
    var fullName: String? = ""
    var profilePic: String? = ""
    var appliedSortFilter: Int?
    let isGuestUser = UserDefaults.standard.string(forKey: "isGuestLogin") ?? "false"
    var storeId: Int? = 0
    
    // MARK: - speechRecognizer
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var isListening = false
    private var sellerId: Int = 0
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadAllCollections()
        searchTF.delegate = self
        requestPermissions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getSingleStoresApi()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionsHeight()
    }
    
    // MARK: - Button's Action
    @IBAction func bakDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chatDidTapped(_ sender: Any) {
        if isGuestUser != "true" {
            viewModel.createNormalChatSercie(sellerId: sellerId)
        } else {
            showLoginAlert()
        }
        
    }
    
    @IBAction func productDidTapped(_ sender: Any) {
        productButtonOutlet.setImage(UIImage(named: "btnGradient"), for: .normal)
        productTitleLabel.textColor = UIColor.white
        reelsTitlLabel.textColor = UIColor.black
        reelsButtonOutlet.setImage(UIImage(named: ""), for: .normal)
        searchView.isHidden = false
        sortFilterView.isHidden = false
        storesCollectionView.isHidden = false
        reelsCollectionView.isHidden = true
        noReelsFound.isHidden = true
        storesCollectionViewHeightConstraint.constant = storesCollectionView.contentSize.height
    }
    
    @IBAction func reelsDidTapped(_ sender: Any) {
        productButtonOutlet.setImage(UIImage(named: ""), for: .normal)
        productTitleLabel.textColor = UIColor.black
        reelsTitlLabel.textColor = UIColor.white
        reelsButtonOutlet.setImage(UIImage(named: "btnGradient"), for: .normal)
        searchView.isHidden = true
        sortFilterView.isHidden = true
        storesCollectionView.isHidden = true
        reelsCollectionView.isHidden = false
        noReelsFound.isHidden = false
        reelsCollectionViewHeightConstriant.constant = reelsCollectionView.contentSize.height
    }
    
    @IBAction func sortDidTapped(_ sender: Any) {
        let nextVC = SortByStoresViewController.instantiate(fromAppStoryboard: .Catalog)
        nextVC.delegate = self
        nextVC.preSelectedApiValue = appliedSortFilter
        self.navigationController?.present(nextVC, animated: true)
    }
    
    @IBAction func filterDidTapped(_ sender: Any) {
        let nextVC = ProductsFiltersViewController.instantiate(fromAppStoryboard: .Catalog)
        nextVC.selectedCategoryIDs = viewModel.selectedCategoryIDs
        nextVC.selectedBrandIDs = viewModel.selectedBrandIDs
        nextVC.selectedColorIDs = viewModel.selectedColorIDs
        nextVC.selectedSizeIDs = viewModel.selectedSizeIDs
        nextVC.selectedDiscountIDs = viewModel.selectedDiscountIDs
        nextVC.selectedMinPrice = viewModel.minPrice
        nextVC.selectedMaxPrice = viewModel.maxPrice
        nextVC.onApplyFilters = { [weak self] categories, brands, colors, sizes, discounts, minPrice, maxPrice in
            guard let self = self else { return }
            
            self.viewModel.selectedCategoryIDs = categories
            self.viewModel.selectedBrandIDs = brands
            self.viewModel.selectedColorIDs = colors
            self.viewModel.selectedSizeIDs = sizes
            self.viewModel.selectedDiscountIDs = discounts
            self.viewModel.minPrice = minPrice
            self.viewModel.maxPrice = maxPrice
            self.viewModel.getSingleStoresApi()
        }
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // MARK: - Mic Button – This is what you wanted!
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
    
    // MARK: - Start Listening (Speech → Text)
    
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
                self.viewModel.searchText = text
                viewModel.getSingleStoresApi() // live search as user speaks
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.stopListening()
                }
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
    
    func configData(data: Store) {
        pageTitleLabel.text = data.storeName
        storeTitleLabel.text = fullName
        brandLabel.text = data.storeName
        sellerId = data.sellerID ?? 0
        if let imageUrlString = data.storeImage,
           let url = URL(string: imageUrlString) {
            
            storeImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            storeImageView.sd_imageIndicator?.startAnimatingIndicator()
            storeImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
            
            
        } else {
            storeImageView.image = UIImage(named: "")
        }
        
        if let imageUrlString = profilePic,
           let url = URL(string: imageUrlString) {
            userProfileImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            userProfileImage.sd_imageIndicator?.startAnimatingIndicator()
            userProfileImage.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            userProfileImage.image = UIImage(named: "")
        }
        
        descriptionLabel.text = data.bio
        
        if data.storeAvailability == 1 {
            statusView.isHidden = true
        } else {
            statusView.isHidden = false
        }
    }
    
    
    
    func updateCollectionsHeight() {
        storesCollectionViewHeightConstraint.constant = storesCollectionView.contentSize.height
        reelsCollectionViewHeightConstriant.constant = reelsCollectionView.contentSize.height
    }
    
    func reloadAllCollections() {
        storiesCollectionView.reloadData()
        storesCollectionView.reloadData()
        reelsCollectionView.reloadData()
        
        DispatchQueue.main.async {
            self.storesCollectionView.layoutIfNeeded()
            self.reelsCollectionView.layoutIfNeeded()
            
            self.storesCollectionViewHeightConstraint.constant =
            self.storesCollectionView.collectionViewLayout.collectionViewContentSize.height
            
            self.reelsCollectionViewHeightConstriant.constant =
            self.reelsCollectionView.collectionViewLayout.collectionViewContentSize.height
            
            self.view.layoutIfNeeded()
        }
    }
    
    func handleWishlistTap(index: Int) {
        guard let product = viewModel.singleStoresSection?.allProduct?.data?[index] else { return }
        let productId = product.id ?? 0
        viewModel.addToWishlist(productId: productId) { [weak self] success in
            guard let self = self else { return }
            if success {
                guard var updatedProduct = self.viewModel.singleStoresSection?.allProduct?.data?[index] else { return }
                let newStatus = updatedProduct.wishlist == 1 ? 0 : 1
                updatedProduct.wishlist = newStatus
                self.viewModel.singleStoresSection?.allProduct?.data?[index] = updatedProduct
                DispatchQueue.main.async {
                    self.storesCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                    if newStatus == 1 {
                        CommonUtils.showToast(message: "Product added to wishlist")
                    } else {
                        CommonUtils.showToast(message: "Product removed from wishlist")
                    }
                }
            } else {
                print("Wishlist API Failed")
            }
        }
    }
    
    
    
}

// MARK: - COLLECTION VIEW METHODS
extension StoresDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case storiesCollectionView:
            return 2
        case storesCollectionView:
            return viewModel.singleStoresSection?.allProduct?.data?.count ?? 0
        case reelsCollectionView:
            return 8
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case storiesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoresDetailsCollectionViewCell", for: indexPath) as! StoresDetailsCollectionViewCell
            if indexPath.row == 0 {
                cell.mainImageView.image = UIImage(named: "statusImage")
            } else if indexPath.row == 1 {
                cell.mainImageView.image = UIImage(named: "bestSell")
            }
            return cell
        case storesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilteredStoreCollectionViewCell", for: indexPath) as! FilteredStoreCollectionViewCell
            let data = viewModel.singleStoresSection?.allProduct?.data?[indexPath.row]
            cell.configData(data: data)
            cell.wishlistButtonTapped = { [weak self] in
                guard let self = self else { return }
                if isGuestUser != "true" {
                    self.handleWishlistTap(index: indexPath.row)
                } else {
                    showLoginAlert()
                }
            }
            return cell
        case reelsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReelsCollectionViewCell", for: indexPath) as! ReelsCollectionViewCell
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case storesCollectionView:
            let nextVC = ProductDetailViewController.instantiate(fromAppStoryboard: .Catalog)
            nextVC.productId = viewModel.singleStoresSection?.allProduct?.data?[indexPath.row].id
            self.navigationController?.pushViewController(nextVC, animated: true)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt
                        indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case storiesCollectionView:
            let width = storiesCollectionView.frame.width / 5
            let height: CGFloat = 90
            return CGSize(width: width, height: height)
        case storesCollectionView:
            let spacing: CGFloat = 10
            let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
            let width = (collectionView.frame.width - totalSpacing) / 2
            return CGSize(width: width, height: 220)
        case reelsCollectionView:
            let spacing: CGFloat = 10
            let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
            let width = (collectionView.frame.width - totalSpacing) / 2
            return CGSize(width: width, height: storesCollectionView.frame.height)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
}

extension StoresDetailsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            viewModel.getSingleStoresApi()
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}

extension StoresDetailsViewController: SortByStoresViewControllerDelegate {
    func didSelectSortOption(_ option: Int) {
        appliedSortFilter = option
        self.viewModel.getSingleStoresApi()   // call API again
    }
}

protocol SortByStoresViewControllerDelegate: AnyObject {
    func didSelectSortOption(_ option: Int)
}

struct SortOptionModel {
    var title: String
    var apiParcing: String
    var isSelected: Bool = false
}

