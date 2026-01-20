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
//  func didApplyFilter(_ filter: OrderFilterType) {
//    selectedFilter = filter
//    if isCustomOrderSeleced {
//      viewModel.getOrders(type: 2)
//    } else {
//      viewModel.getOrders(type: 1)
//    }
//  }
  
  func didApplyFilter(_ filter: OrderFilterType) {
      if isCustomOrderSeleced {
          customOrderFilter = filter
          viewModel.getOrders(type: 2)
      } else {
          normalOrderFilter = filter
          viewModel.getOrders(type: 1)
      }
  }
  
  @IBOutlet weak var btnOrder: CustomButton!
  @IBOutlet weak var btnCustomOrder: CustomButton!
  @IBOutlet weak var txtSearch: UITextField!
  @IBOutlet weak var orderTableView: TableViewDynamicHeight!
  @IBOutlet weak var lblNoData: UILabel!
  
  lazy private var viewModel = MyOrderVM(hostVC: self)
  var orderData: [OrderModel] = []
  var selectedOrderType: OrderType = .order
//  var selectedFilter: OrderFilterType = .all
  var normalOrderFilter: OrderFilterType = .all
  var customOrderFilter: OrderFilterType = .all
  private var searchWorkItem: DispatchWorkItem?
  var comingFromOrderTracking: Bool = false
  var isCustomOrderSeleced : Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerXib()
    txtSearch.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
      if comingFromOrderTracking {
          if isCustomOrderSeleced {
              btnOrder.setBackgroundImage(nil, for: .normal)
              btnCustomOrder.setBackgroundImage(UIImage(named: "btnGradient"), for: .normal)
              btnOrder.setTitleColor(.black, for: .normal)
              btnCustomOrder.setTitleColor(.white, for: .normal)
              viewModel.getOrders(type: 2)
          } else {
              btnOrder.setBackgroundImage(UIImage(named: "btnGradient"), for: .normal)
              btnCustomOrder.setBackgroundImage(nil, for: .normal)
              btnOrder.setTitleColor(.white, for: .normal)
              btnCustomOrder.setTitleColor(.black, for: .normal)
              viewModel.getOrders(type: 1)
          }
      } else {
          btnOrder.setBackgroundImage(UIImage(named: "btnGradient"), for: .normal)
          btnCustomOrder.setBackgroundImage(nil, for: .normal)
          btnOrder.setTitleColor(.white, for: .normal)
          btnCustomOrder.setTitleColor(.black, for: .normal)
          viewModel.getOrders(type: 1)
      }
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
  
  private func findTabBarVC() -> TabBarVC? {
    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
      for window in scene.windows {
        if let tabVC = window.rootViewController as? TabBarVC {
          return tabVC
        }
        if let nav = window.rootViewController as? UINavigationController {
          if let tabVC = nav.viewControllers.first(where: { $0 is TabBarVC }) as? TabBarVC {
            return tabVC
          }
        }
        if let presented = window.rootViewController?.presentedViewController as? TabBarVC {
          return presented
        }
      }
    }
    return nil
  }
  
  @IBAction func btnSelectOrderType(_ sender: UIButton) {
    switch sender.tag {
    case 0:
      btnOrder.setBackgroundImage(UIImage(named: "btnGradient"), for: .normal)
      btnCustomOrder.setBackgroundImage(nil, for: .normal)
      btnOrder.setTitleColor(.white, for: .normal)
      btnCustomOrder.setTitleColor(.black, for: .normal)
      isCustomOrderSeleced = false
      orderData.removeAll()
      viewModel.getOrders(type: 1)
      
    case 1:
      btnOrder.setBackgroundImage(nil, for: .normal)
      btnCustomOrder.setBackgroundImage(UIImage(named: "btnGradient"), for: .normal)
      btnOrder.setTitleColor(.black, for: .normal)
      btnCustomOrder.setTitleColor(.white, for: .normal)
      isCustomOrderSeleced = true
      orderData.removeAll()
      viewModel.getOrders(type: 2)
      
    default:
      break
    }
  }
  
  @IBAction func btnFilter(_ sender: Any) {
//    let vc = FilterVC.instantiate(fromAppStoryboard: .MyOrder)
//    vc.delegate = self
//    self.navigationController?.present(vc, animated: true)
    let vc = FilterVC.instantiate(fromAppStoryboard: .MyOrder)
        vc.delegate = self

        // Pass correct preselected filter
        vc.preselectedFilter = isCustomOrderSeleced
            ? customOrderFilter
            : normalOrderFilter

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
    vc.isCustomOrder = isCustomOrderSeleced
      isCustomOrderSeleced = false
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
          if isCustomOrderSeleced {
//              customOrderFilter = filter
              viewModel.getOrders(type: 2)
          } else {
//              normalOrderFilter = filter
              viewModel.getOrders(type: 1)
          }
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}
