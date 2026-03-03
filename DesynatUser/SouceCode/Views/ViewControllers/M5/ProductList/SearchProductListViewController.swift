//
//  SearchProductListViewController.swift
//  DesynatUser
//
//  Created by fluper on 24/12/25.
//

import UIKit
import Speech

class SearchProductListViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var btnMicOutlet: UIButton!
    @IBOutlet weak var noProductFoundLabel: UILabel!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var storesCollectionView: UICollectionView! {
        didSet {
            storesCollectionView.registerCellFromNib(cellID: "FilteredStoreCollectionViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var isListening = false
    lazy var viewModel = SearchProductListViewModel(hostVC: self)
    var appliedSortFilter: Int?
    private var searchWorkItem: DispatchWorkItem?
    var comingFromImageScanner: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
        requestPermissions()
        if comingFromImageScanner {
            searchTF.text = viewModel.attributeText.joined(separator: ", ")
        } else {
            searchTF.text = viewModel.searchText
        }
        viewModel.getProductsApi()
    }
    
    // MARK: - Button's Action
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
            self.viewModel.getProductsApi()
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popToViewController(ofType: SearchVC.self)
    }
    
    @IBAction func sortDidTapped(_ sender: Any) {
        let nextVC = SortByStoresViewController.instantiate(fromAppStoryboard: .Catalog)
        nextVC.delegate = self
        nextVC.preSelectedApiValue = appliedSortFilter
        self.navigationController?.present(nextVC, animated: true)
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
    
    @IBAction func cameraDidTapped(_ sender: Any) {
        let vc = WatchScannerVc.viewFromNIB
        vc.comingFromSearchProduct = true
        vc.onImageRecognized = { [weak self] attributes in
            guard let self = self else { return }
            self.comingFromImageScanner = true
            self.viewModel.attributeText = attributes
            self.searchTF.text = attributes.joined(separator: ", ")
            self.viewModel.getProductsApi()
        }
        self.navigationController?.pushViewController(vc, animated: true)
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
                viewModel.getProductsApi() // live search as user speaks
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
        btnMicOutlet.setImage(UIImage(systemName: "mic"), for: .normal)
        btnMicOutlet.tintColor = .label
    }
    
    deinit {
        stopListening()
    }
    
    func handleWishlistTap(index: Int) {
        guard let product = viewModel.productDetails?[index] else { return }
        let productId = product.id ?? 0
        viewModel.addToWishlist(productId: productId) { [weak self] success in
            guard let self = self else { return }
            if success {
                guard var updatedProduct = self.viewModel.productDetails?[index] else { return }
                let newStatus = updatedProduct.wishlist == 1 ? 0 : 1
                updatedProduct.wishlist = newStatus
                self.viewModel.productDetails?[index] = updatedProduct
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
extension SearchProductListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.productDetails?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilteredStoreCollectionViewCell", for: indexPath) as! FilteredStoreCollectionViewCell
        let data = viewModel.productDetails?[indexPath.row]
        cell.configData(data: data)
        cell.wishlistButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.handleWishlistTap(index: indexPath.row)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let nextVC = ProductDetailViewController.instantiate(fromAppStoryboard: .Catalog)
        nextVC.productId = viewModel.productDetails?[indexPath.row].id
        //      nextVC.storeName = pageTitleLabel.text?.trimmed()
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt
                        indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10
        let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
        let width = (collectionView.frame.width - totalSpacing) / 2
        return CGSize(width: width, height: 220)
    }
}

//MARK: UITextFieldDelegate Methods
extension SearchProductListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            viewModel.getProductsApi()
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}

extension SearchProductListViewController: SortByStoresViewControllerDelegate {
    
    func didSelectSortOption(_ option: Int) {
        appliedSortFilter = option
        self.viewModel.getProductsApi()   // call API again
    }
}
