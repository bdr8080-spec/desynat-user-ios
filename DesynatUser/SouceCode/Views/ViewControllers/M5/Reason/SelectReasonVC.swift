//
//  SelectReasonVC.swift
//  DesynatUser
//
//  Created by fluper on 22/12/25.
//

enum SelectScreenType {
    case cancelOrder
    case returnPro
    case exchangePro
    case rating
    case customCancel
}

import UIKit

class SelectReasonVC: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var txtTotalItem: UITextField!
    @IBOutlet weak var lblTitle: CustomLabelFont!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var txtReason: UITextField!
    @IBOutlet weak var imgProfilePic: CustomImageView!
    @IBOutlet weak var txtRateProduct: UITextField!
    @IBOutlet weak var txtRateStore: UITextField!
    @IBOutlet weak var reasonTableView: TableViewDynamicHeight!
    @IBOutlet weak var sizeTableView: TableViewDynamicHeight!
    @IBOutlet weak var viewTotalItemReturn: UIView!
    @IBOutlet weak var viewReason: UIView!
    @IBOutlet weak var viewOtherReason: UIView!
    @IBOutlet weak var viewUploadPic: UIView!
    @IBOutlet weak var viewSize: UIView!
    @IBOutlet weak var viewRateProduct: UIView!
    
    // MARK: - Property Decalaration
    lazy private var viewModel = SelectReasonVM(hostVC: self)
    var reasonArr = ["Reason 1", "Reason 2", "Reason 3", "Other"]
    var sizeArr = ["S", "M", "L", "XL"]
    var selectedIndex: Int = 0
    var selectedIndex1: Int = 0
    var screenType: SelectScreenType = .cancelOrder
    var orderId: Int?
    var orderDetailId: Int?
    var rejectReasonData: [RejectReasonModel] = []
    weak var delegate: SelectReasonDelegate?
    var selectedProfileImageUrl: [String] = []
    var onCancel: (()->())?
    var onReturn: (()->())?
    var onExchange: (()->())?
    var cancelReason: String? = ""
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        initialSetup()
        
        configureScreen()
        viewModel.rejectReason()
    }
    
    // MARK: - Button's Action
    @IBAction func btnDismis(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnUploadImg(_ sender: Any) {
        ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
            guard let self = self else { return }
            self.viewModel.uploadDocument(file: image, isImage: true) { [weak self] uploadedUrl in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.selectedProfileImageUrl.append(uploadedUrl)
                    self.imgProfilePic.image = image
                }
            }
        }
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        switch screenType {
            
        case .cancelOrder:
            guard let reason = getSelectedCancelReason() else {
                showAlert(msg: "Please select or enter a reason".localiz())
                return
            }
            viewModel.cancelOrder(reason: reason) {
                self.onCancel?()
                self.delegate?.didUpdateOrder(status: .cancelOrder)
            }
            
        case .returnPro:
            viewModel.returnExOrder(type: screenType) {
                DispatchQueue.main.async {
                    self.showReturnSuccess()
                    self.onReturn?()
                    self.delegate?.didUpdateOrder(status: .cancelOrder)
                }
            }
            
        case .exchangePro:
            viewModel.returnExOrder(type: screenType) {
                DispatchQueue.main.async {
                    self.showExchangeSuccess()
                    self.onExchange?()
                    self.delegate?.didUpdateOrder(status: .cancelOrder)
                }
            }
            
        case .rating, .customCancel:
            return
        }
    }
    
    //MARK: Function's declaration
    private func getSelectedCancelReason() -> String? {
        let isOtherSelected = selectedIndex == rejectReasonData.count
        
        if isOtherSelected {
            let otherReason = txtReason.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            return (otherReason?.isEmpty == false) ? otherReason : nil
        } else {
            guard rejectReasonData.indices.contains(selectedIndex) else { return nil }
            return rejectReasonData[selectedIndex].reasonEnglish
        }
    }
    
    func registerXib() {
        reasonTableView.delegate = self
        reasonTableView.dataSource = self
        reasonTableView.register(UINib(nibName: "FiltersOptionsTableViewCell", bundle: nil), forCellReuseIdentifier: "FiltersOptionsTableViewCell")
        
        sizeTableView.delegate = self
        sizeTableView.dataSource = self
        sizeTableView.register(UINib(nibName: "FiltersOptionsTableViewCell", bundle: nil), forCellReuseIdentifier: "FiltersOptionsTableViewCell")
    }
    
    func configureScreen() {
        viewTotalItemReturn.isHidden = true
        viewReason.isHidden = true
        viewOtherReason.isHidden = true
        viewUploadPic.isHidden = true
        viewSize.isHidden = true
        viewRateProduct.isHidden = true
        txtReason.text = ""
        
        switch screenType {
        case .cancelOrder:
            lblTitle.text = "Select Reason".localiz()
            viewReason.isHidden = false
            
        case .returnPro:
            lblTitle.text = "Return Request".localiz()
            viewReason.isHidden = false
            viewUploadPic.isHidden = false
            
        case .exchangePro:
            lblTitle.text = "Select Reason".localiz()
            viewReason.isHidden = false
            //      viewSize.isHidden = false
            
        case .rating:
            lblTitle.text = "Rate this product".localiz()
            viewRateProduct.isHidden = false
            
        case .customCancel:
            lblTitle.text = "Select Reason".localiz()
            viewTotalItemReturn.isHidden = false
            viewReason.isHidden = false
            viewUploadPic.isHidden = false
        }
    }
    
    private func initialSetup() {
        titleView.clipsToBounds = true
        titleView.layer.cornerRadius = 32
        titleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        parentView.clipsToBounds = true
        parentView.layer.cornerRadius = 32
        parentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func showExchangeSuccess() {
        let successVC = SuccessMsgVC.instantiate(fromAppStoryboard: .MyOrder)
        successVC.message = "Order Exchange Request Sent successfully!".localiz()
        
        successVC.OnDismiss = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        present(successVC, animated: true)
    }
    
    func showReturnSuccess() {
        let successVC = SuccessMsgVC.instantiate(fromAppStoryboard: .MyOrder)
        successVC.message = "Order Return Request Sent successfully!".localiz()
        
        successVC.OnDismiss = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        present(successVC, animated: true)
    }
    
}

// MARK: - TABLE VIEW METHODS
extension SelectReasonVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case reasonTableView:
            return rejectReasonData.count + 1
            
        case sizeTableView:
            return sizeArr.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case reasonTableView:
            let cell = reasonTableView.dequeueReusableCell(withIdentifier: "FiltersOptionsTableViewCell", for: indexPath) as! FiltersOptionsTableViewCell
            
            let isOtherRow = indexPath.row == rejectReasonData.count
            
            if isOtherRow {
                cell.titleLabel.text = "Others".localiz()
            } else {
                let data = rejectReasonData[indexPath.row]
                cell.titleLabel.text = data.reasonEnglish ?? ""
            }
            
            if selectedIndex == indexPath.row {
                cell.selectionImageView.image = UIImage(named: "radioSelected")
            } else {
                cell.selectionImageView.image = UIImage(named: "radioUnselected")
            }
            return cell
            
        case sizeTableView:
            let cell = sizeTableView.dequeueReusableCell(withIdentifier: "FiltersOptionsTableViewCell", for: indexPath) as! FiltersOptionsTableViewCell
            if selectedIndex1 == indexPath.row {
                cell.selectionImageView.image = UIImage(named: "radioSelected")
            } else {
                cell.selectionImageView.image = UIImage(named: "radioUnselected")
            }
            cell.titleLabel.text = sizeArr[indexPath.row]
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
            
        case reasonTableView:
            selectedIndex = indexPath.row
            
            let isOtherSelected = indexPath.row == rejectReasonData.count
            viewOtherReason.isHidden = !isOtherSelected
            
            if isOtherSelected {
                txtReason.text = ""
                viewSize.isHidden = true   // hide size for "Others"
            } else {
                txtReason.text = ""
                
                let selectedReason = rejectReasonData[indexPath.row]
                
                // Show size only for reason id 40 or 41
                if selectedReason.id == 40 || selectedReason.id == 41 {
                    viewSize.isHidden = false
                } else {
                    viewSize.isHidden = true
                    selectedIndex1 = 0 // reset size selection if needed
                }
            }
            
            reasonTableView.reloadData()
            
        case sizeTableView:
            selectedIndex1 = indexPath.row
            sizeTableView.reloadData()
            
        default:
            return
        }
    }
    
}
