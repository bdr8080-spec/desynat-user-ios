//
//  AffiliatedCameraSearchViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 11/02/26.
//

import UIKit
import AVFoundation

class AffiliatedCameraSearchViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var cameraPreview: UIView!
    
    // MARK: - Property Decalaration
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var captureDevice: AVCaptureDevice?
    private var photoOutput = AVCapturePhotoOutput()
    private var isFlashOn = false
    var onImageRecognized: ((_ attributes: [String]) -> Void)?
    var comingFromSearchProduct: Bool = false
    var viewModel:WatchRecognizer!
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = .init()
        setupCamera()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(focusTap(_:)))
        cameraPreview.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoPreviewLayer?.frame = cameraPreview.bounds
    }
    
    // MARK: - Button's Action
    @IBAction func btnTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func captureImage(_ sender: UIButton) {
        let settings = AVCapturePhotoSettings()
        if captureDevice?.isFlashAvailable == true {
            settings.flashMode = isFlashOn ? .on : .off
        }
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    //MARK: Function's declaration
    private func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .photo
        
        // Get the primary (back) camera
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: .back) else {
            self.showAlert(msg: "Camera not found".localiz()){
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if captureSession!.canAddInput(input) {
                captureSession!.addInput(input)
            }
            if captureSession!.canAddOutput(photoOutput) {
                captureSession!.addOutput(photoOutput)
            }
            
            // Enable autofocus, auto exposure, auto white balance
            try device.lockForConfiguration()
            if device.isFocusModeSupported(.continuousAutoFocus) {
                device.focusMode = .continuousAutoFocus
            }
            if device.isExposureModeSupported(.continuousAutoExposure) {
                device.exposureMode = .continuousAutoExposure
            }
            if device.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance) {
                device.whiteBalanceMode = .continuousAutoWhiteBalance
            }
            device.unlockForConfiguration()
            captureDevice = device
            
            // Preview layer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = .resizeAspectFill
            videoPreviewLayer?.frame = cameraPreview.bounds
            cameraPreview.layer.addSublayer(videoPreviewLayer!)
            
            // Start session
            captureSession?.startRunning()
        } catch {
            self.showAlert(msg: "Error setting up camera".localiz()) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc private func focusTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: cameraPreview)
        focus(at: location)
        showFocusRing(at: location)
    }
    
    private func showFocusRing(at point: CGPoint) {
        let focusRing = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        focusRing.center = point
        focusRing.layer.borderColor = UIColor.yellow.cgColor
        focusRing.layer.borderWidth = 2
        focusRing.layer.cornerRadius = 40
        focusRing.alpha = 0.0
        cameraPreview.addSubview(focusRing)
        
        UIView.animate(withDuration: 0.2, animations: {
            focusRing.alpha = 1.0
            focusRing.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0.5, options: [], animations: {
                focusRing.alpha = 0.0
                focusRing.transform = CGAffineTransform.identity
            }, completion: { _ in
                focusRing.removeFromSuperview()
            })
        }
    }
    
    private func focus(at point: CGPoint) {
        guard let device = captureDevice else { return }
        
        // Convert tap location to camera coordinates (0–1 range)
        let focusPoint = CGPoint(x: point.x / cameraPreview.bounds.size.width,
                                 y: point.y / cameraPreview.bounds.size.height)
        
        do {
            try device.lockForConfiguration()
            
            if device.isFocusPointOfInterestSupported {
                device.focusPointOfInterest = focusPoint
                device.focusMode = .autoFocus
            }
            
            if device.isExposurePointOfInterestSupported {
                device.exposurePointOfInterest = focusPoint
                device.exposureMode = .autoExpose
            }
            
            device.unlockForConfiguration()
        } catch {
            print("Focus error: \(error)")
        }
    }
    
}

extension AffiliatedCameraSearchViewController {
    
    func checkForImage(image: UIImage) {
        
        viewModel.recognizeProduct(image: image) { result in
            guard let result = result else {
                self.showAlert(msg: "Product not recognized".localiz())
                return
            }
            //
            //            print("CATEGORY:", result.category ?? "")
            //            print("BRAND:", result.brand ?? "")
            //            print("PRODUCT:", result.productName ?? "")
            //            print("ATTRIBUTES:", result.attributes)
            //            print("COLORS:", result.colors)
            
            DispatchQueue.main.async {
                if self.comingFromSearchProduct {
                    self.onImageRecognized?(result.attributes)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    let nextVC = SearchAffiliatedProductsViewController
                        .instantiate(fromAppStoryboard: .AffiliateUser)
                    nextVC.comingFromImageScanner = true
                    nextVC.viewModel.attributeText = result.attributes
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
        }
    }
}

extension AffiliatedCameraSearchViewController : AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else { return }
        self.checkForImage(image: image)
    }
}
