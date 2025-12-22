//
//  MyOrderDetailVC.swift
//  DesynatUser
//
//  Created by fluper on 19/12/25.
//

import UIKit

class MyOrderDetailVC: UIViewController {

    @IBOutlet weak var lblOrderId: CustomLabelFont!
    @IBOutlet weak var lblPlacedDate: CustomLabelFont!
    @IBOutlet weak var viewStatus: CustomView!
    @IBOutlet weak var lblStatus: CustomLabelFont!
    @IBOutlet weak var lblTotalMrp: CustomLabelFont!
    @IBOutlet weak var lblDiscountMrp: CustomLabelFont!
    @IBOutlet weak var lblCouponDis: CustomLabelFont!
    @IBOutlet weak var lblShippingFee: CustomLabelFont!
    @IBOutlet weak var lblTax: CustomLabelFont!
    @IBOutlet weak var lblTotalAmount: CustomLabelFont!
    @IBOutlet weak var lblSavedAmount: CustomLabelFont!
    @IBOutlet weak var lblDeliveryInst: CustomLabelFont!
    @IBOutlet weak var lblDeliveredOn: CustomLabelFont!
    
    @IBOutlet weak var imgConfirm: UIImageView!
    @IBOutlet weak var lblConfirm: UILabel!
    @IBOutlet weak var imgShip: UIImageView!
    @IBOutlet weak var lblShip: UILabel!
    @IBOutlet weak var imgWay: UIImageView!
    @IBOutlet weak var lblWay: UILabel!
    @IBOutlet weak var imgDelivered: UIImageView!
    @IBOutlet weak var lblDelivered: UILabel!
    
    @IBOutlet weak var lblShippingAdd: CustomLabelFont!
    @IBOutlet weak var lblTransactionId: CustomLabelFont!
    @IBOutlet weak var lblPaidByCardAmount: CustomLabelFont!
    @IBOutlet weak var lblPaidByCard: CustomLabelFont!
    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var txtTshirtReview: UITextField!
    @IBOutlet weak var txtStoreReview: UITextField!
    @IBOutlet weak var orderTableView: TableViewDynamicHeight!
    
    lazy private var viewModel = MyOrderDetailVM(hostVC: self)
    var orderData: OrderModel?
    var orderId: Int?
    var orderDetailId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
    }
    
    func registerXib() {
        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.register(UINib(nibName: "OrderDetailTableCell", bundle: nil), forCellReuseIdentifier: "OrderDetailTableCell")
    }

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func btnSubmitReview(_ sender: Any) {
    }
    
    @IBAction func btnDownloadInvoice(_ sender: Any) {
    }
    
    @IBAction func btnExchnge(_ sender: Any) {
    }
    
    @IBAction func btnReturn(_ sender: Any) {
    }
    
}

extension MyOrderDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailTableCell", for: indexPath) as! OrderDetailTableCell
        cell.onTapCancel = {
            let vc = SelectReasonVC.instantiate(fromAppStoryboard: .MyOrder)
            vc.screenType = .cancelOrder
            self.navigationController?.present(vc, animated: true)
        }
        
        cell.onTapExchange = {
            let vc = SelectReasonVC.instantiate(fromAppStoryboard: .MyOrder)
            vc.screenType = .exchangePro
            self.navigationController?.present(vc, animated: true)
        }
        
        cell.onTapReturn = {
            let vc = SelectReasonVC.instantiate(fromAppStoryboard: .MyOrder)
            vc.screenType = .returnPro
            self.navigationController?.present(vc, animated: true)
        }
        return cell
    }
    
    
}
