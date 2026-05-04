//
//  ImageDocumentHelper.swift
//  ClupPeRestaurant
//
//  Created by Fluper on 08/02/24.
//
import Foundation
import MobileCoreServices
import UIKit

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIDocumentPickerDelegate {
    
    static let shared = ImagePickerManager()
    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose File".localiz(), message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback: ((UIImage,String, URL?) -> ())?
    var allowPDFSelection: Bool = false // Add this property
    
    override init(){
        super.init()
        picker.delegate = self
    }
    
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage, String, URL?) -> ())) {
        pickImageCallback = callback
        self.viewController = viewController
        setupAlert()
        alert.popoverPresentationController?.sourceView = viewController.view
        viewController.present(alert, animated: true)
    }
    
    private func setupAlert() {
        alert = UIAlertController(title: "Choose File".localiz(), message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera".localiz(), style: .default) { _ in
            self.openCamera()
        }
        
        let galleryAction = UIAlertAction(title: "Gallery".localiz(), style: .default) { _ in
            self.openGallery()
        }
        
        // ✅ PDF option — only if allowed
        if allowPDFSelection {
            let pdfAction = UIAlertAction(title: "PDF / Files".localiz(), style: .default) { _ in
                self.openDocumentPicker()
            }
            alert.addAction(pdfAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localiz(), style: .cancel)
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
    }
    
    func openCamera() {
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)) {
            picker.sourceType = .camera
            self.viewController!.present(picker, animated: true, completion: nil)
        } else {
            let alertController: UIAlertController = {
                let controller = UIAlertController(title: "Warning".localiz(), message: "You don't have camera".localiz(), preferredStyle: .alert)
                let action = UIAlertAction(title: "OK".localiz(), style: .default)
                controller.addAction(action)
                return controller
            } ()
            viewController?.present(alertController, animated: true)
        }
    }
    
    func openGallery() {
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }
    
    func openDocumentPicker() {
        alert.dismiss(animated: true)
        initializeDocument()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

            guard let image = info[.originalImage] as? UIImage else { return }

            // ✅ Save image to temporary folder
            let fileName = UUID().uuidString + ".jpg"
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

            if let data = image.jpegData(compressionQuality: 0.8) {
                try? data.write(to: tempURL)
            }

            // ✅ Provide valid URL to callback
            pickImageCallback?(image, fileName, tempURL)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }
    
}

extension ImagePickerManager {
    // MARK: - Document Picker
    private func initializeDocument() {
        let doc = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        doc.delegate = self
        viewController?.present(doc, animated: true)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        for url in urls {
            defer { url.stopAccessingSecurityScopedResource() }
            guard url.startAccessingSecurityScopedResource() else { return }
            pickImageCallback?(UIImage(), "", url)
        }
    }
}
