//
//  AffiliatedCategorySearchViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 11/02/26.
//

import MLKitObjectDetection
import MLKitVision
import Speech
import UIKit

class AffiliatedCategorySearchViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var latstSearchCollectionViewHieghtConstriant:
    NSLayoutConstraint!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var latestSearchCollectionView: CollViewAdjustedHeight! {
        didSet {
            latestSearchCollectionView.registerCellFromNib(
                cellID: "LatestSearchCollectionCell"
            )
        }
    }
    @IBOutlet weak var RecentSearchTableView: TableViewDynamicHeight! {
        didSet {
            RecentSearchTableView.registerCellFromNib(
                cellID: "RecentSearchTableCell"
            )
        }
    }
    @IBOutlet weak var lblNoRecentData: CustomLabelFont!
    @IBOutlet weak var btnMicOutlet: UIButton!
    @IBOutlet weak var noLatesSearchFoundLabel: CustomLabelFont!
    
    // MARK: - Property Decalaration
    private lazy var viewModel = AffiliatedCategorySearchViewModel(hostVC: self)
    lazy var objectDetector: ObjectDetector = {
        let options = ObjectDetectorOptions()
        options.detectorMode = .singleImage
        options.shouldEnableMultipleObjects = true
        options.shouldEnableClassification = true
        return ObjectDetector.objectDetector(options: options)
    }()
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNoRecentData.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getLatestSearchData()
        viewModel.getSearchProducts()
    }
    
    // MARK: - Button's Action
    @IBAction func btnGo(_ sender: Any) {
        guard
            let searchText = txtSearch.text?.trimmingCharacters(
                in: .whitespacesAndNewlines
            ),
            !searchText.isEmpty
        else {
            showAlert(msg: "Please search something".localiz())
            return
        }
        let nextVC = SearchAffiliatedProductsViewController.instantiate(
            fromAppStoryboard: .AffiliateUser
        )
        nextVC.viewModel.searchText = self.txtSearch.text?.trimmed() ?? ""
        nextVC.comingFromImageScanner = false
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func btnCamera(_ sender: Any) {
        let vc = AffiliatedCameraSearchViewController.instantiate(
            fromAppStoryboard: .AffiliateUser
        )
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnMic(_ sender: UIButton) {
        let nextVC = VoiceSearchViewController.instantiate(fromAppStoryboard: .AffiliateUser)
                nextVC.onSearchedCompletionTxt = { [weak self] searchText in
                    self?.txtSearch.text = searchText
                    self?.navigateToNextScreen()
                }
                self.navigationController?.present(nextVC, animated: true)

    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Function's declaration
    func navigateToNextScreen() {
        let nextVC = SearchAffiliatedProductsViewController.instantiate(fromAppStoryboard: .AffiliateUser)
        nextVC.viewModel.searchText =
        self.txtSearch.text?.trimmed() ?? ""
        nextVC.comingFromImageScanner = false
        self.navigationController?.pushViewController(nextVC,animated: true)
    }
    
}

// MARK: - TABLE VIEW METHODS
extension AffiliatedCategorySearchViewController: UITableViewDelegate,
                                                  UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
    -> Int
    {
        return viewModel.searchProductsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
    {
        let cell =
        tableView.dequeueReusableCell(
            withIdentifier: "RecentSearchTableCell",
            for: indexPath
        ) as! RecentSearchTableCell
        cell.lblName.text =
        viewModel.searchProductsData[indexPath.row].name ?? ""
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let nextVC = SearchAffiliatedProductsViewController.instantiate(
            fromAppStoryboard: .AffiliateUser
        )
        nextVC.viewModel.searchText =
        viewModel.searchProductsData[indexPath.row].name ?? ""
        nextVC.comingFromImageScanner = false
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - COLLECTION VIEW METHODS
extension AffiliatedCategorySearchViewController: UICollectionViewDelegate,
                                                  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.latestSearchData.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell =
        collectionView.dequeueReusableCell(
            withReuseIdentifier: "LatestSearchCollectionCell",
            for: indexPath
        ) as! LatestSearchCollectionCell
        cell.titleLabel.text = viewModel.latestSearchData[indexPath.row].name
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let nextVC = SearchAffiliatedProductsViewController.instantiate(
            fromAppStoryboard: .AffiliateUser
        )
        nextVC.viewModel.searchText =
        viewModel.latestSearchData[indexPath.row].name ?? ""
        nextVC.comingFromImageScanner = false
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if collectionView == latestSearchCollectionView {
            let width = (latestSearchCollectionView.frame.width - 12) / 3
            let height: CGFloat = 38
            return CGSize(width: width, height: height)
        }
        return CGSize(width: 100, height: 40)
    }
    
    func updateLatestSearchCollectionHeight() {
        latestSearchCollectionView.layoutIfNeeded()
        if viewModel.latestSearchData.isEmpty {
            latstSearchCollectionViewHieghtConstriant.constant = 120
        } else {
            latstSearchCollectionViewHieghtConstriant.constant =
            latestSearchCollectionView.collectionViewLayout
                .collectionViewContentSize.height
        }
    }
}
