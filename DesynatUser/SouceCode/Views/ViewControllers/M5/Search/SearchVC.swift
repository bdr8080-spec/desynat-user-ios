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
    // MARK: - Speech Recognition
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var isListening = false
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
        requestPermissions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLatestSearchCollectionHeight()
    }
    
    // MARK: - Button's Action
    @IBAction func btnSearch(_ sender: Any) {
    }
    
    @IBAction func btnGo(_ sender: Any) {
        stopListening()
        guard let searchText = txtSearch.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !searchText.isEmpty else {
            showAlert(msg: "Please search something")
            return
        }
        let nextVC = SearchProductListViewController.instantiate(fromAppStoryboard: .MyOrder)
        nextVC.viewModel.searchText = self.txtSearch.text?.trimmed() ?? ""
        nextVC.comingFromImageScanner = false
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func btnCamera(_ sender: Any) {
        let vc = WatchScannerVc.viewFromNIB
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnMic(_ sender: UIButton) {
        if isListening {
            stopListening()
            sender.setImage(UIImage(systemName: "mic"), for: .normal)
        } else {
            startListening()
            sender.setImage(UIImage(systemName: "mic.fill"), for: .normal)
            sender.tintColor = .systemRed // optional: show it's active
        }
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        stopListening()
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Start Listening (Speech → Text)
    
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
                self.txtSearch.text = text
                // CALL API HERE FOR SEARCHs
                self.stopListening()
                guard let searchText = txtSearch.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                      !searchText.isEmpty else {
                    showAlert(msg: "Please search something")
                    return
                }
                let nextVC = SearchProductListViewController.instantiate(fromAppStoryboard: .MyOrder)
                nextVC.viewModel.searchText = self.txtSearch.text?.trimmed() ?? ""
                nextVC.comingFromImageScanner = false
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            
            if error != nil || result?.isFinal == true {
                self.stopListening()
                DispatchQueue.main.async {
                    (self.txtSearch.inputView as? UIButton)?.setImage(UIImage(systemName: "mic"), for: .normal)
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
            txtSearch.becomeFirstResponder() // optional: show cursor
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
                    self.showAlert(msg: "No object detected")
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

