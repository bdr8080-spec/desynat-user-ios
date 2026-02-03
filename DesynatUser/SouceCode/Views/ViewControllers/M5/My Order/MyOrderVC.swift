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
        normalOrderFilter = filter
        viewModel.getOrders()
    }
    
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var orderTableView: TableViewDynamicHeight!
    @IBOutlet weak var lblNoData: UILabel!
    
    lazy private var viewModel = MyOrderVM(hostVC: self)
    var orderData: [OrderModel] = []
    var selectedOrderType: OrderType = .order
    var normalOrderFilter: OrderFilterType = .all
    private var searchWorkItem: DispatchWorkItem?
    var comingFromOrderTracking: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        txtSearch.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getOrders()
    }
    
    func registerXib() {
        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.register(UINib(nibName: "MyOrderTableCell", bundle: nil), forCellReuseIdentifier: "MyOrderTableCell")
    }
    
    @IBAction func btnBack(_ sender: Any) {
        if comingFromOrderTracking {
            self.navigationController?.popToRootViewController(animated: false)
            DispatchQueue.main.async {
                if let tabBarVC = self.findTabBarVC() {
                    tabBarVC.updateTabSelection(forTag: 4)
                } else {
                    print("TabBarVC not found")
                }
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func btnFilter(_ sender: Any) {
        let vc = FilterVC.instantiate(fromAppStoryboard: .MyOrder)
        vc.delegate = self
        vc.preselectedFilter = normalOrderFilter
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
        if order.orderType == "2" {
            vc.isCustomOrder = true
        } else {
            vc.isCustomOrder = false
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MyOrderVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            viewModel.getOrders()
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}
