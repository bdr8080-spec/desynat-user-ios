//
//  AffiliatedProductsViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 11/02/26.
//

import UIKit
import Speech

class AffiliatedProductsViewController: UIViewController {
    
    @IBOutlet weak var btnMicOutlet: UIButton!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var productsCollectionView: UICollectionView! {
        didSet {
            productsCollectionView.registerCellFromNib(cellID: "AffiliatedProductsCollectionViewCell")
        }
    }
    lazy var viewModel = AffiliatedProductsViewModel(hostVC: self)
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var isListening = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
        searchTF.text = viewModel.searchText
        requestPermissions()
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popToViewController(ofType: AffiliatedCategorySearchViewController.self)
    }
    
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
    
    private func requestPermissions() {
        SFSpeechRecognizer.requestAuthorization { _ in }
        AVAudioSession.sharedInstance().requestRecordPermission { _ in }
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
}

extension AffiliatedProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AffiliatedProductsCollectionViewCell", for: indexPath) as! AffiliatedProductsCollectionViewCell
        cell.onGetLinkTapped = { [weak self] in
            let nextVC = AffiliatedCopyLinkViewController.instantiate(fromAppStoryboard: .AffiliateUser)
            self?.navigationController?.present(nextVC, animated: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 7
        let totalSpacing = spacing * 2
        let width = (collectionView.frame.width - totalSpacing) / 2
        return CGSize(width: width, height: 295)
    }
}

extension AffiliatedProductsViewController: UITextFieldDelegate {
    //  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //    let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
    //    searchWorkItem?.cancel()
    //    let workItem = DispatchWorkItem { [weak self] in
    //      guard let self = self else { return }
    //      self.viewModel.searchText = currentText
    //      viewModel.getProductsApi()
    //    }
    //    searchWorkItem = workItem
    //    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    //    return true
    //  }
}
