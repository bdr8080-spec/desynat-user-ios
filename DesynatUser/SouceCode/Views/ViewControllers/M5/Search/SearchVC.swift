//
//  SearchVC.swift
//  DesynatUser
//
//  Created by fluper on 22/12/25.
//

import UIKit
import Speech
import UIKit
import MLKitObjectDetection
import MLKitVision

class SearchVC: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var latstSearchCollectionViewHieghtConstriant: NSLayoutConstraint!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var latestSearchCollectionView: CollViewAdjustedHeight!
    @IBOutlet weak var recommendedCollectionView: CollViewAdjustedHeight!
    @IBOutlet weak var RecentSearchTableView: TableViewDynamicHeight!
    @IBOutlet weak var lblNoData: CustomLabelFont!
    @IBOutlet weak var btnMicOutlet: UIButton!
    @IBOutlet weak var noLatesSearchFoundLabel: CustomLabelFont!
    @IBOutlet weak var noReconmmendedDataFoundLAbel: CustomLabelFont!
    
    // MARK: - Property Decalaration
    lazy private var viewModel = SearchVM(hostVC: self)
    var recentData: [RecentDataModel] = []
    var recommendedData: [RecommenedeSearch] = []
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
        registerXib()
        viewModel.getRecentData()
        viewModel.getRecommendedSearchData()
        lblNoData.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLatestSearchCollectionHeight()
    }
    
    // MARK: - Button's Action
    @IBAction func btnSearch(_ sender: Any) {
    }
    
    @IBAction func btnGo(_ sender: Any) {
        guard let searchText = txtSearch.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !searchText.isEmpty else {
            showAlert(msg: "Please search something".localiz())
            return
        }
        let nextVC = SearchProductListViewController.instantiate(fromAppStoryboard: .MyOrder)
        nextVC.viewModel.searchText = self.txtSearch.text?.trimmed() ?? ""
        nextVC.comingFromImageScanner = false
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func btnCamera(_ sender: Any) {
        ImagePickerHelper.shared.showPickerControllerForCameraSearch(
            onCameraSelected: { [weak self] in
                let vc = WatchScannerVc.viewFromNIB
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        ) { [weak self] image, _ in
            guard let self = self, let image = image else { return }
            self.checkForImage(image: image)
        }
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
    func registerXib() {
        RecentSearchTableView.delegate = self
        RecentSearchTableView.dataSource = self
        RecentSearchTableView.register(UINib(nibName: "RecentSearchTableCell", bundle: nil), forCellReuseIdentifier: "RecentSearchTableCell")
        latestSearchCollectionView.delegate = self
        latestSearchCollectionView.dataSource = self
        latestSearchCollectionView.registerCellFromNib(cellID: "LatestSearchCollectionCell")
        recommendedCollectionView.delegate = self
        recommendedCollectionView.dataSource = self
        recommendedCollectionView.registerCellFromNib(cellID: "RecommendCollectionCell")
    }
    
    func navigateToNextScreen() {
        let nextVC = SearchProductListViewController.instantiate(fromAppStoryboard: .MyOrder)
        nextVC.viewModel.searchText = self.txtSearch.text?.trimmed() ?? ""
        nextVC.comingFromImageScanner = false
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

// MARK: - TABLE VIEW METHODS
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchTableCell", for: indexPath) as! RecentSearchTableCell
        let data = recentData[indexPath.row]
        cell.lblName.text = data.name ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = SearchProductListViewController.instantiate(fromAppStoryboard: .MyOrder)
        nextVC.viewModel.searchText = recentData[indexPath.row].name ?? ""
        nextVC.comingFromImageScanner = false
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - COLLECTION VIEW METHODS
extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == latestSearchCollectionView {
            return recentData.count
        } else {
            return recommendedData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == latestSearchCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestSearchCollectionCell", for: indexPath) as! LatestSearchCollectionCell
            //            if AppLanguageManager.shared.currentLanguage == .ar {
            //                cell.titleLabel.text = recentData[indexPath.row].
            //            }else{
            //
            //            }
            cell.titleLabel.text = recentData[indexPath.row].name
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCollectionCell", for: indexPath) as! RecommendCollectionCell
            cell.configData(data: recommendedData[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == latestSearchCollectionView {
            let nextVC = SearchProductListViewController.instantiate(fromAppStoryboard: .MyOrder)
            nextVC.viewModel.searchText = recentData[indexPath.row].name ?? ""
            nextVC.comingFromImageScanner = false
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else {
            let nextVC = SearchProductListViewController.instantiate(fromAppStoryboard: .MyOrder)
            nextVC.viewModel.searchText = recommendedData[indexPath.row].nameEnglish ?? ""
            nextVC.comingFromImageScanner = false
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == recommendedCollectionView {
            return CGSize(width: 120, height: 50) // adjust as needed
            
        } else if collectionView == latestSearchCollectionView {
            let width = (latestSearchCollectionView.frame.width - 12) / 3
            let height: CGFloat = 38
            return CGSize(width: width, height: height)
        }
        return CGSize(width: 100, height: 40)
    }
    
    func updateLatestSearchCollectionHeight() {
        latestSearchCollectionView.layoutIfNeeded()
        latstSearchCollectionViewHieghtConstriant.constant =
        latestSearchCollectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    
    
    
}

extension SearchVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation
        objectDetector.process(visionImage) { [weak self] objects, error in
            guard let self = self else { return }
            if let error = error {
                print("Object detection error: \(error.localizedDescription)")
                return
            }
            guard let objects = objects, !objects.isEmpty else {
                DispatchQueue.main.async {
                    self.showAlert(msg: "No object detected".localiz())
                }
                return
            }
            var detectedLabels: [(text: String, confidence: Float)] = []
            for object in objects {
                object.labels.forEach { label in
                    detectedLabels.append((label.text, label.confidence))
                }
            }
            if let bestLabel = detectedLabels.max(by: { $0.confidence < $1.confidence }) {
                DispatchQueue.main.async {
                    self.txtSearch.text = bestLabel.text
                }
            }
        }
    }
    
}

extension SearchVC {
    
    func checkForImage(image: UIImage) {
        viewModel.recognizeProduct(image: image) { result in
            guard let result = result else {
                self.showAlert(msg: "Product not recognized".localiz())
                return
            }
            DispatchQueue.main.async {
                let nextVC = SearchProductListViewController
                    .instantiate(fromAppStoryboard: .MyOrder)
                nextVC.comingFromImageScanner = true
                nextVC.viewModel.attributeText = result.attributes
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
}
