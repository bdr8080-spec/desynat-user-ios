//
//  MyOrderVC.swift
//  DesynatUser
//
//  Created by fluper on 19/12/25.
//

enum OrderType {
    case order
    case customOrder
}

enum OrderFilterType: Int {
    case all = 1
    case ongoing = 2
    case delivered = 3
    case cancelled = 4
    case returned = 5
}

protocol FilterDelegate: AnyObject {
    func didApplyFilter(_ filter: OrderFilterType)
}

import UIKit

class MyOrderVC: UIViewController, FilterDelegate {
    func didApplyFilter(_ filter: OrderFilterType) {
        selectedFilter = filter
        viewModel.getOrders()
    }

    @IBOutlet weak var btnOrder: CustomButton!
    @IBOutlet weak var btnCustomOrder: CustomButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var orderTableView: TableViewDynamicHeight!
    @IBOutlet weak var lblNoData: UILabel!
    
    lazy private var viewModel = MyOrderVM(hostVC: self)
    var orderData: [OrderModel] = []
    var selectedOrderType: OrderType = .order
    var selectedFilter: OrderFilterType = .all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        viewModel.getOrders()
        btnSelectOrderType(btnOrder)
        lblNoData.isHidden = true
        orderTableView.isHidden = true
    }
    
    func registerXib() {
        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.register(UINib(nibName: "MyOrderTableCell", bundle: nil), forCellReuseIdentifier: "MyOrderTableCell")
    }
    
    func updateUI() {
        let hasData = !orderData.isEmpty
        lblNoData.isHidden = hasData
        orderTableView.isHidden = !hasData
    }

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSelectOrderType(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            btnOrder.setBackgroundImage(UIImage(named: "btnGradient"), for: .normal)
            btnCustomOrder.setBackgroundImage(nil, for: .normal)
            btnOrder.setTitleColor(.white, for: .normal)
            btnCustomOrder.setTitleColor(.black, for: .normal)
            viewModel.getOrders()
        
        case 1:
            btnOrder.setBackgroundImage(nil, for: .normal)
            btnCustomOrder.setBackgroundImage(UIImage(named: "btnGradient"), for: .normal)
            btnOrder.setTitleColor(.black, for: .normal)
            btnCustomOrder.setTitleColor(.white, for: .normal)
            orderData.removeAll()
            orderTableView.reloadData()
            updateUI()
            
        default:
            break
        }
    }
    
    @IBAction func btnFilter(_ sender: Any) {
        let vc = FilterVC.instantiate(fromAppStoryboard: .MyOrder)
        vc.delegate = self
        self.navigationController?.present(vc, animated: true)
    }
    
}

extension MyOrderVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderTableCell", for: indexPath) as! MyOrderTableCell
        let order = orderData[indexPath.row]
        cell.configure(with: order)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = orderData[indexPath.row]
        let vc = MyOrderDetailVC.instantiate(fromAppStoryboard: .MyOrder)
        vc.orderId = order.order?.id ?? 0
        vc.orderDetailId = order.id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
