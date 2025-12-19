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

import UIKit

class MyOrderVC: UIViewController {

    @IBOutlet weak var btnOrder: CustomButton!
    @IBOutlet weak var btnCustomOrder: CustomButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var orderTableView: TableViewDynamicHeight!
    @IBOutlet weak var lblNoData: UILabel!
    
    lazy private var viewModel = MyOrderVM(hostVC: self)
    var orderData: [OrderModel] = []
    var selectedOrderType: OrderType = .order
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        //viewModel.getOrders()
        btnSelectOrderType(btnOrder)
    }
    
    func registerXib() {
        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.register(UINib(nibName: "MyOrderTableCell", bundle: nil), forCellReuseIdentifier: "MyOrderTableCell")
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
        
        case 1:
            btnOrder.setBackgroundImage(nil, for: .normal)
            btnCustomOrder.setBackgroundImage(UIImage(named: "btnGradient"), for: .normal)
            btnOrder.setTitleColor(.black, for: .normal)
            btnCustomOrder.setTitleColor(.white, for: .normal)
            
        default:
            break
        }
    }
    
    @IBAction func btnFilter(_ sender: Any) {
    }
    
}

extension MyOrderVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderTableCell", for: indexPath) as! MyOrderTableCell
//        let order = orderData[indexPath.row]
//        cell.configure(with: order)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MyOrderDetailVC.instantiate(fromAppStoryboard: .MyOrder)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
