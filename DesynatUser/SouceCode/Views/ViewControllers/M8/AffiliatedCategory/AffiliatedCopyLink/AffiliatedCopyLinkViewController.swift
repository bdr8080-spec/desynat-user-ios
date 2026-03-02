//
//  AffiliatedCopyLinkViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 11/02/26.
//

import UIKit

class AffiliatedCopyLinkViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var linkTF: UITextField!
    @IBOutlet weak var titleView: UIView!
    
    // MARK: - Property Decalaration
    private lazy var viewModel = AffiliatedCopyLinkViewModel(hostVC: self)
    var onAddToProduct: (() -> Void)?
    var productLink: String = ""
    var productID: Int = 0
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        linkTF.text = productLink
    }
    
    // MARK: - Button's Action
    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addToProductsDidTapped(_ sender: Any) {
        viewModel.addProductToMyProduct()
    }
    
    @IBAction func copyLinkDidTapped(_ sender: Any) {
        let link = linkTF.text?.trimmed() ?? ""
        UIPasteboard.general.string = link
        showCopiedLabel()
    }
    
    private func showCopiedLabel() {
        let copiedLabel = UILabel()
        copiedLabel.text = "  Copied  "
        copiedLabel.textAlignment = .center
        copiedLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        copiedLabel.textColor = .white
        copiedLabel.backgroundColor = .darkGray
        copiedLabel.layer.cornerRadius = 8
        copiedLabel.clipsToBounds = true
        
        copiedLabel.frame = CGRect(
            x: (view.frame.width - 100) / 2,
            y: view.frame.height - 120,
            width: 100,
            height: 35
        )
        
        view.addSubview(copiedLabel)
        
        // Remove after 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            copiedLabel.removeFromSuperview()
        }
    }
    
    private func initialSetup() {
        titleView.clipsToBounds = true
        titleView.layer.cornerRadius = 32
        titleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
