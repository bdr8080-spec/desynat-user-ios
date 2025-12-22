//
//  OrderDetailTableCell.swift
//  DesynatUser
//
//  Created by fluper on 19/12/25.
//

import UIKit

class OrderDetailTableCell: UITableViewCell {

    @IBOutlet weak var imgProduct: CustomImageView!
    @IBOutlet weak var lblProductName: CustomLabelFont!
    @IBOutlet weak var lblSize: CustomLabelFont!
    @IBOutlet weak var lblDisPrice: CustomLabelFont!
    @IBOutlet weak var lblPrice: CustomLabelFont!
    @IBOutlet weak var lblReturnAvail: CustomLabelFont!
    @IBOutlet weak var viewReturnDays: UIView!
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var viewRate: UIView!
    @IBOutlet weak var viewReturnEx: UIView!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var viewCustom: UIView!
    @IBOutlet weak var lblTotalQuantity: CustomLabelFont!
    @IBOutlet weak var lblAddress: CustomLabelFont!
    @IBOutlet weak var lblDetails: CustomLabelFont!
    
    var onTapCancel: (()->())?
    var onTapExchange: (()->())?
    var onTapReturn: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func btnCancel(_ sender: Any) {
        onTapCancel?()
    }
    
    @IBAction func btnExchange(_ sender: Any) {
        onTapExchange?()
    }
    
    @IBAction func btnReturn(_ sender: Any) {
        onTapReturn?()
    }
}
