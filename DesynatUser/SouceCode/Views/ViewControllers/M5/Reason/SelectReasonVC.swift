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
    
    var reasonArr = ["Reason 1", "Reason 2", "Reason 3", "Other"]
    var sizeArr = ["S", "M", "L", "XL"]
    var selectedIndex: Int = 0
    var selectedIndex1: Int = 0
    var screenType: SelectScreenType = .cancelOrder
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        initialSetup()
        configureScreen()
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
            lblTitle.text = "Select Reason"
            viewReason.isHidden = false
            
        case .returnPro:
            lblTitle.text = "Return Request"
            viewReason.isHidden = false
            viewUploadPic.isHidden = false
            
        case .exchangePro:
            lblTitle.text = "Select Reason"
            viewReason.isHidden = false
            viewSize.isHidden = false
            
        case .rating:
            lblTitle.text = "Rate this product"
            viewRateProduct.isHidden = false
            
        case .customCancel:
            lblTitle.text = "Select Reason"
            viewTotalItemReturn.isHidden = false
            viewReason.isHidden = false
            viewUploadPic.isHidden = false
        }
    }
   
    private func initialSetup() {
        titleView.clipsToBounds = true
        titleView.layer.cornerRadius = 32
        titleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    @IBAction func btnDismis(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnUploadImg(_ sender: Any) {
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
    }
    
}

extension SelectReasonVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case reasonTableView:
            return reasonArr.count
            
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
            cell.titleLabel.text = reasonArr[indexPath.row]
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
            if indexPath.row == reasonArr.count - 1 {
                viewOtherReason.isHidden = false
            } else {
                viewOtherReason.isHidden = true
                txtReason.text = ""
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
