//
//  StoresViewController.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit
import Speech

class StoresViewController: UIViewController {
    
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
    
    var slectedsubCategoryId: Int? = 0
    private lazy var viewModel = StoreViewModel(hostVC: self)
    var appliedRatings: [String] = []
    var appliedAvailability: String = ""
    var appliedShortest: Bool = false
    var appliedHighest: Bool = false
    private var searchWorkItem: DispatchWorkItem?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var isListening = false
    var slecetedCategoryID: Int = 0
    private var bannerAutoScrollTimer: Timer?
    private var currentBannerIndex = 0
    private let bannerAutoScrollDelay: TimeInterval = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerCollectionView.layer.cornerRadius = 12
        searchTF.delegate = self
        requestPermissions()
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
    
    private func requestPermissions() {
        SFSpeechRecognizer.requestAuthorization { _ in }
        AVAudioSession.sharedInstance().requestRecordPermission { _ in }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionsHeight()
    }
    
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
        if isListening {
            stopListening()
            sender.setImage(UIImage(systemName: "mic"), for: .normal)
        } else {
            startListening()
            sender.setImage(UIImage(systemName: "mic.fill"), for: .normal)
            sender.tintColor = .systemRed // optional: show it's active
        }
    }
    
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
                viewModel.getStoresListApi() // live search as user speaks
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
}

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
            cell.mainImageView.image = UIImage(named: "storeBannersImage")
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
        let nextVC = StoresDetailsViewController.instantiate(fromAppStoryboard: .Catalog)
        nextVC.storeId = viewModel.storesSection[indexPath.row].id
        let info = viewModel.storesSection[indexPath.row].sellerInformation
        nextVC.fullName = "\(info?.firstName ?? "") \(info?.lastName ?? "")"
        nextVC.profilePic = info?.profilePic
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //        if collectionView == storesCollectionView {
    //            viewWillLayoutSubviews()
    //        }
    //    }
    
    // MARK: - Update Page Control on Scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == bannerCollectionView {
            let pageIndex = Int(round(scrollView.contentOffset.x / bannerCollectionView.frame.width))
            bannerPageController.currentPage = pageIndex
            currentBannerIndex = pageIndex
        }
    }

    
}

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
