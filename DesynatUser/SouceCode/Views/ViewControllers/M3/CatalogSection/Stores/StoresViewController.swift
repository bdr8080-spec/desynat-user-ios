//
//  StoresViewController.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit
import Speech

class StoresViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var btnMicOutlet: UIButton!
    @IBOutlet weak var noResultFoundLabel: UILabel!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var storesCollectionViewHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var bannerPageController: UIPageControl!
    @IBOutlet weak var bannerCollectionView: UICollectionView! {
        didSet {
            bannerCollectionView.registerCellFromNib(cellID: "HomeBannerCollectionViewCell")
        }
    }
    @IBOutlet weak var storesCollectionView: UICollectionView! {
        didSet {
            storesCollectionView.registerCellFromNib(cellID: "StoresCollectionViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    private lazy var viewModel = StoreViewModel(hostVC: self)
    private var searchWorkItem: DispatchWorkItem?
    private var bannerAutoScrollTimer: Timer?
    private var currentBannerIndex = 0
    private let bannerAutoScrollDelay: TimeInterval = 6
    var slecetedCategoryID: Int = 0
    var slectedsubCategoryId: Int? = 0
    var appliedRatings: [String] = []
    var appliedAvailability: String = ""
    var appliedShortest: Bool = false
    var appliedHighest: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerCollectionView.layer.cornerRadius = 12
        searchTF.delegate = self
        viewModel.getTopHomeBannersListApi(type: 3, category: slecetedCategoryID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getStoresListApi()
        startBannerAutoScroll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopBannerAutoScroll()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionsHeight()
    }
    
    // MARK: - Button's Action
    @IBAction func filterDidTapped(_ sender: Any) {
        let nextVC = StoresFiltersViewController.instantiate(fromAppStoryboard: .Catalog)
        
        // Pass previous selections
        nextVC.selectedRatings = appliedRatings
        nextVC.selectedAvailability = appliedAvailability
        nextVC.selectedShortest = appliedShortest
        nextVC.selectedHighest = appliedHighest
        
        // Closure callback
        nextVC.onFilterApplied = { [weak self] ratings, availability, shortest, highest in
            guard let self = self else { return }
            
            self.appliedRatings = ratings
            self.appliedAvailability = availability
            self.appliedShortest = shortest
            self.appliedHighest = highest
            
            self.viewModel.getStoresListApi()
        }
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Page Control Tap Handling
    @IBAction func pageControlChanged(_ sender: UIPageControl) {
        currentBannerIndex = sender.currentPage
        let indexPath = IndexPath(item: currentBannerIndex, section: 0)
        bannerCollectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
    }
    
    // MARK: - Mic Button – This is what you wanted!
    @IBAction func micDidTapped(_ sender: UIButton) {
        let nextVC = VoiceSearchViewController.instantiate(fromAppStoryboard: .AffiliateUser)
        nextVC.onSearchedCompletionTxt = { [weak self] searchText in
            self?.searchTF.text = searchText
            self?.viewModel.searchText = searchText
            self?.viewModel.getStoresListApi()
        }
        self.navigationController?.present(nextVC, animated: true)
    }
    
    //MARK: Function's declaration
    
    func updateCollectionsHeight() {
        storesCollectionViewHeightConstriant.constant = storesCollectionView.contentSize.height
    }
    
    private func startBannerAutoScroll() {
        stopBannerAutoScroll()
        
        bannerAutoScrollTimer = Timer.scheduledTimer(
            timeInterval: bannerAutoScrollDelay,
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
    
    @objc private func autoScrollBanner() {
        let totalItems = viewModel.homeScreenAllBannersList.count
        guard totalItems > 1 else { return }
        
        currentBannerIndex += 1
        if currentBannerIndex >= totalItems {
            currentBannerIndex = 0
        }
        
        let indexPath = IndexPath(item: currentBannerIndex, section: 0)
        
        bannerCollectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
        
        bannerPageController.currentPage = currentBannerIndex
    }
    
}

// MARK: - COLLECTION VIEW METHODS
extension StoresViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case bannerCollectionView:
            let data = viewModel.homeScreenAllBannersList
            if data.isEmpty {
                return 1
            } else {
                return viewModel.homeScreenAllBannersList.count
            }
        case storesCollectionView:
            return viewModel.storesSection.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case bannerCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCollectionViewCell", for: indexPath) as! HomeBannerCollectionViewCell
            cell.mainImageView.layer.cornerRadius = 12
            let data = viewModel.homeScreenAllBannersList
            if data.isEmpty {
                cell.mainImageView.image = .noBannerFound
            } else {
                cell.configData(data: data[indexPath.row])
            }
            return cell
        case storesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoresCollectionViewCell", for: indexPath) as! StoresCollectionViewCell
            let data = viewModel.storesSection[indexPath.row]
            cell.configData(data: data)
            cell.onProfileTapped = { [weak self] in
                let nextVC = StoryViewerViewController.instantiate(fromAppStoryboard: .Home)
                nextVC.comingFor = .forSellerStory
                nextVC.sellerId = data.sellerID ?? 0
                self?.navigationController?.pushViewController(nextVC, animated: false)
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
        case storesCollectionView:
            let spacing: CGFloat = 10
            let totalSpacing = spacing * 2 // 3 cells per row → 2 spaces between
            let width = (collectionView.frame.width - totalSpacing) / 2
            return CGSize(width: width, height: 194)
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case bannerCollectionView:
            if !viewModel.homeScreenAllBannersList.isEmpty {
                let nextVC = StoresDetailsViewController.instantiate(fromAppStoryboard: .Catalog)
                nextVC.storeId = viewModel.homeScreenAllBannersList[indexPath.row].sellerDetails?.storeInfo?.id
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        case storesCollectionView:
            let nextVC = StoresDetailsViewController.instantiate(fromAppStoryboard: .Catalog)
            nextVC.storeId = viewModel.storesSection[indexPath.row].id
            self.navigationController?.pushViewController(nextVC, animated: true)
        default:
            print("")
        }
    }
    
    // MARK: - Update Page Control on Scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == bannerCollectionView {
            let pageIndex = Int(round(scrollView.contentOffset.x / bannerCollectionView.frame.width))
            bannerPageController.currentPage = pageIndex
            currentBannerIndex = pageIndex
        }
    }
}

//MARK: UITextFieldDelegate Methods
extension StoresViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            viewModel.getStoresListApi()
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}
