//
//  AffiliatedCopyLinkViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 11/02/26.
//

import UIKit

class AffiliatedCopyLinkViewController: UIViewController {

    @IBOutlet weak var linkTF: UITextField!
    @IBOutlet weak var titleView: UIView!
    
    var onAddToProduct: (() -> Void)?
    var productLink: String = ""
    var productID: Int = 0
    private lazy var viewModel = AffiliatedCopyLinkViewModel(hostVC: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        linkTF.text = productLink
    }
    
    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addToProductsDidTapped(_ sender: Any) {
        viewModel.addProductToMyProduct()
    }
    
    @IBAction func copyLinkDidTapped(_ sender: Any) {
        let link = linkTF.text?.trimmed() ?? ""
        UIPasteboard.general.string = link
    }
    
    private func initialSetup() {
        titleView.clipsToBounds = true
        titleView.layer.cornerRadius = 32
        titleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    

}
