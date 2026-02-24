//
//  AffiliatedUserProductViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 28/01/26.
//

import UIKit
import Speech

class AffiliatedUserProductViewController: UIViewController {
    
    @IBOutlet weak var btnMicOutlet: UIButton!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var categoryCollectionView: UICollectionView! {
        didSet {
            categoryCollectionView.registerCellFromNib(cellID: "MyProductsCategoryCollectionViewCell")
        }
    }
    @IBOutlet weak var subCatgeoryCollectionView: UICollectionView! {
        didSet {
            subCatgeoryCollectionView.registerCellFromNib(cellID: "MyProductsSubCategoryCollectionViewCell")
        }
    }
    
    @IBOutlet weak var productCollectionView: UICollectionView! {
        didSet {
            productCollectionView.registerCellFromNib(cellID: "MyProductsCollectionViewCell")
        }
    }
    
    private lazy var viewModel = AffiliatedUserProductViewModel(hostVC: self)
    var selectedCatrgoryId = 0
    var selectedSubCatrgoryId = 0
    
    // MARK: - Speech Recognition
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var isListening = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
        viewModel.getCategoriesListApi()
        let allSubCategory = SubCategoriesDataModel(
            id: -1,
            categoryID: -1,
            nameEnglish: "All",
            nameArabic: "الكل",
            image: nil,
            status: 1,
            createdAt: nil,
            updatedAt: nil)
            viewModel.subCategoriesSection.insert(allSubCategory, at: 0)
        viewModel.resetAndFetchProducts()
        requestPermissions()
    }
    
    @IBAction func micdidTapped(_ sender: UIButton) {
        if isListening {
            stopListening()
            sender.setImage(UIImage(systemName: "mic"), for: .normal)
        } else {
            startListening()
            sender.setImage(UIImage(systemName: "mic.fill"), for: .normal)
            sender.tintColor = .systemRed // optional: show it's active
        }
    }
    
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
                // CALL API HERE FOR SEARCHs
                self.stopListening()
                guard let searchText = searchTF.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                      !searchText.isEmpty else {
                    showAlert(msg: "Please search something")
                    return
                }
                self.viewModel.searchText = self.searchTF.text?.trimmed() ?? ""
                viewModel.resetAndFetchProducts()
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
    
}

extension AffiliatedUserProductViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case categoryCollectionView:
            return viewModel.categoriesSection.count
        case subCatgeoryCollectionView:
            return viewModel.subCategoriesSection.count
        case productCollectionView:
            return viewModel.productDetails.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case categoryCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyProductsCategoryCollectionViewCell", for: indexPath) as! MyProductsCategoryCollectionViewCell
            cell.titleLabel.text = viewModel.categoriesSection[indexPath.row].name
            if selectedCatrgoryId == viewModel.categoriesSection[indexPath.row].id {
                cell.mainView.borderWidth = 2
            } else {
                cell.mainView.borderWidth = 0
            }
            return cell
        case subCatgeoryCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyProductsSubCategoryCollectionViewCell", for: indexPath) as! MyProductsSubCategoryCollectionViewCell
            if indexPath.row == 0 {
                cell.titleLabel.isHidden = true
                cell.mainImageView.image = .allSubCatgeory
            } else {
                cell.titleLabel.isHidden = false
                cell.configData(data: viewModel.subCategoriesSection[indexPath.row])
            }
            let subCatgeoryId = viewModel.subCategoriesSection[indexPath.row].id ?? -1
            if selectedSubCatrgoryId == subCatgeoryId && subCatgeoryId > -1 {
                cell.mainImageView.borderWidth = 2
            } else {
                cell.mainImageView.borderWidth = 0
            }
            return cell
        case productCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyProductsCollectionViewCell", for: indexPath) as! MyProductsCollectionViewCell
            let data = viewModel.productDetails[indexPath.row].product
            cell.configData(data: data)
            cell.onTrackPerformanceTapped = {
                let nextVC = ItemPerformanceViewController.instantiate(fromAppStoryboard: .AffiliateUser)
                nextVC.productId = self.viewModel.productDetails[indexPath.row].productID ?? 0
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case categoryCollectionView:
            selectedCatrgoryId = viewModel.categoriesSection[indexPath.row].id ?? 0
            categoryCollectionView.reloadData()
            selectedSubCatrgoryId = 0
            viewModel.subCategoriesSection = []
            let allSubCategory = SubCategoriesDataModel(
                id: -1,
                categoryID: -1,
                nameEnglish: "All",
                nameArabic: "الكل",
                image: nil,
                status: 1,
                createdAt: nil,
                updatedAt: nil)
                viewModel.subCategoriesSection.insert(allSubCategory, at: 0)
            if indexPath.row > 0 {
                viewModel.getSubCategoriesListApi(categoryID: viewModel.categoriesSection[indexPath.row].id ?? 0)
            } else {
                subCatgeoryCollectionView.reloadData()
            }
            viewModel.resetAndFetchProducts()
        case subCatgeoryCollectionView:
            selectedSubCatrgoryId = viewModel.subCategoriesSection[indexPath.row].id ?? 0
            subCatgeoryCollectionView.reloadData()
            viewModel.resetAndFetchProducts()
        case productCollectionView:
            let nextVC = ItemPerformanceViewController.instantiate(fromAppStoryboard: .AffiliateUser)
            nextVC.productId = self.viewModel.productDetails[indexPath.row].productID ?? 0
            self.navigationController?.pushViewController(nextVC, animated: true)
        default:
            print("")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case categoryCollectionView:
            let width = (collectionView.frame.width) / 4
            return CGSize(width: width, height: 38)
        case subCatgeoryCollectionView:
            if indexPath.row == 0 {
                return CGSize(width: 60, height: 68)
            } else {
                return CGSize(width: 65, height: 90)
            }
        case productCollectionView:
            let spacing: CGFloat = 3
            let totalSpacing = spacing * 2
            let width = (collectionView.frame.width - totalSpacing) / 2
            return CGSize(width: width, height: 285)
        default:
            return .zero
        }
    }
    
}

extension AffiliatedUserProductViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == productCollectionView else { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        if offsetY > contentHeight - frameHeight - 50 {
            viewModel.getAllProducts()
        }
    }
    
}

extension AffiliatedUserProductViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        viewModel.searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            viewModel.resetAndFetchProducts()
        }
        viewModel.searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}
