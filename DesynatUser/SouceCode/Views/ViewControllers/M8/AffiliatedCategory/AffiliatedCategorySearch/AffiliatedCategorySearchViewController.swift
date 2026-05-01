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
    
    // MARK: - Speech Recognition
    private let speechRecognizer = SFSpeechRecognizer(
        locale: Locale(identifier: "en-US")
    )
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var isListening = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNoRecentData.isHidden = true
        requestPermissions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getLatestSearchData()
        viewModel.getSearchProducts()
    }
    
    // MARK: - Button's Action
    @IBAction func btnGo(_ sender: Any) {
        stopListening()
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
        if isListening {
            stopListening()
            sender.setImage(UIImage(systemName: "mic"), for: .normal)
        } else {
            startListening()
            sender.setImage(UIImage(systemName: "mic.fill"), for: .normal)
            sender.tintColor = .systemRed
        }
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        stopListening()
        self.navigationController?.popViewController(animated: true)
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
    
    //MARK: Function's declaration
    private func startListening() {
        // Reset everything
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = nil
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(
                .record,
                mode: .measurement,
                options: .duckOthers
            )
            try audioSession.setActive(
                true,
                options: .notifyOthersOnDeactivation
            )
        } catch {
            print("Audio session error: \(error)")
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let request = recognitionRequest else { return }
        request.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request) {
            [weak self] result, error in
            guard let self = self else { return }
            
            if let result = result {
                let text = result.bestTranscription.formattedString
                self.txtSearch.text = text
                // CALL API HERE FOR SEARCHs
                self.stopListening()
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
                nextVC.viewModel.searchText =
                self.txtSearch.text?.trimmed() ?? ""
                nextVC.comingFromImageScanner = false
                self.navigationController?.pushViewController(
                    nextVC,
                    animated: true
                )
            }
            
            if error != nil || result?.isFinal == true {
                self.stopListening()
                DispatchQueue.main.async {
                    (self.txtSearch.inputView as? UIButton)?.setImage(
                        UIImage(systemName: "mic"),
                        for: .normal
                    )
                }
            }
        }
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(
            onBus: 0,
            bufferSize: 1024,
            format: recordingFormat
        ) { buffer, _ in
            request.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
            isListening = true
            txtSearch.becomeFirstResponder()  // optional: show cursor
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
