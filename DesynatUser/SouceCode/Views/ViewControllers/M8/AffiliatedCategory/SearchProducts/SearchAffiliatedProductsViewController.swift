//
//  SearchAffiliatedProductsViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 24/02/26.
//

import UIKit
import Speech

class SearchAffiliatedProductsViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var btnMicOutlet: UIButton!
    @IBOutlet weak var noProductFoundLabel: UILabel!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var storesCollectionView: UICollectionView! {
        didSet {
            storesCollectionView.registerCellFromNib(cellID: "AffiliatedProductsCollectionViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var isListening = false
    private var searchWorkItem: DispatchWorkItem?
    lazy var viewModel = SearchAffiliatedProductsViewModel(hostVC: self)
    var appliedSortFilter: Int?
    var comingFromImageScanner: Bool = false
    var categoryId: Int? = 0
    var subCatrgoryId: Int? = 0
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
        if comingFromImageScanner {
            searchTF.text = viewModel.attributeText.joined(separator: ", ")
        } else {
            searchTF.text = viewModel.searchText
        }
        viewModel.resetAndFetchProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - Button's Action
    @IBAction func filterDidTapped(_ sender: Any) {
        let nextVC = AffiliatedCategoryFilterViewController.instantiate(fromAppStoryboard: .AffiliateUser)
        nextVC.selectedBrandIDs = viewModel.selectedBrandIDs
        nextVC.selectedColorIDs = viewModel.selectedColorIDs
        nextVC.selectedSizeIDs = viewModel.selectedSizeIDs
        nextVC.selectedDiscountIDs = viewModel.selectedDiscountIDs
        nextVC.selectedMinPrice = viewModel.minPrice
        nextVC.selectedMaxPrice = viewModel.maxPrice
        nextVC.onApplyFilters = { [weak self] brands, colors, sizes, discounts, minPrice, maxPrice in
            guard let self = self else { return }
            self.viewModel.selectedBrandIDs = brands
            self.viewModel.selectedColorIDs = colors
            self.viewModel.selectedSizeIDs = sizes
            self.viewModel.selectedDiscountIDs = discounts
            self.viewModel.minPrice = minPrice
            self.viewModel.maxPrice = maxPrice
            self.viewModel.resetAndFetchProducts()
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sortDidTapped(_ sender: Any) {
        let nextVC = SotByAffiliatedProductsViewController.instantiate(fromAppStoryboard: .AffiliateUser)
        nextVC.delegate = self
        nextVC.preSelectedApiValue = appliedSortFilter
        self.navigationController?.present(nextVC, animated: true)
    }
    
    // MARK: - Mic Button – This is what you wanted!
    @IBAction func micDidTapped(_ sender: UIButton) {
        let nextVC = VoiceSearchViewController.instantiate(fromAppStoryboard: .AffiliateUser)
        nextVC.onSearchedCompletionTxt = { [weak self] searchText in
            self?.searchTF.text = searchText
            self?.viewModel.searchText = searchText
            self?.viewModel.resetAndFetchProducts()
        }
        self.navigationController?.present(nextVC, animated: true)
    }
    
    @IBAction func cameraDidTapped(_ sender: Any) {
        let vc = WatchScannerVc.viewFromNIB
        vc.comingFromSearchProduct = true
        vc.onImageRecognized = { [weak self] attributes in
            guard let self = self else { return }
            self.comingFromImageScanner = true
            self.viewModel.attributeText = attributes
            self.searchTF.text = attributes.joined(separator: ", ")
            self.viewModel.resetAndFetchProducts()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - COLLECTION VIEW METHODS
extension SearchAffiliatedProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.productDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AffiliatedProductsCollectionViewCell", for: indexPath) as! AffiliatedProductsCollectionViewCell
        let data = viewModel.productDetails[indexPath.row]
        cell.configData(data: data)
        cell.onGetLinkTapped = { [weak self] in
            self?.viewModel.generateProductLink(productId: data.id ?? 0)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt
                        indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 7
        let totalSpacing = spacing * 2
        let width = (collectionView.frame.width - totalSpacing) / 2
        return CGSize(width: width, height: 290)
    }
    
}

//MARK: UITextFieldDelegate Methods
extension SearchAffiliatedProductsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            viewModel.resetAndFetchProducts()
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}

extension SearchAffiliatedProductsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == storesCollectionView else { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        if offsetY > contentHeight - frameHeight - 50 {
            self.viewModel.getAllProducts()
        }
    }
    
}

extension SearchAffiliatedProductsViewController: SortByStoresViewControllerDelegate {
    func didSelectSortOption(_ option: Int) {
        appliedSortFilter = option
        self.viewModel.resetAndFetchProducts()
    }
}
