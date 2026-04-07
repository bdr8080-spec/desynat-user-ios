//
//  SupportViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 19/03/26.
//

import UIKit

class SupportViewController: UIViewController {
    
    // MARK: - IBOultet
    @IBOutlet weak var contactBtn: CustomButton!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var ticketmanagementbtn: CustomButton!
    @IBOutlet weak var ticketmanagementLbl: UILabel!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var ticketManagementTableView: UITableView!{
        didSet{
            ticketManagementTableView.delegate = self
            ticketManagementTableView.dataSource = self
            ticketManagementTableView.registerCellFromNib(cellID: "TicketManagementTableViewCell")
        }
    }
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var serachTF: UITextField!
    
    private lazy var viewModel = SupportViewModel(hostVC: self)
    var comingUserRole: UserRoleType = .normalUser
    private var searchWorkItem: DispatchWorkItem?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        serachTF.delegate = self
        ticketManagementTableView.isHidden = true
        contactView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.currentPage = 1
        viewModel.getAllTicketListRequest()
    }
    
    // MARK: - Navigation
    
    @IBAction func backbtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func contactBtn(_ sender: Any) {
        ticketmanagementbtn.setImage(UIImage(named: ""), for: .normal)
        ticketmanagementLbl.textColor = UIColor.black
        contactBtn.setImage(UIImage(named: "btnGradient"), for: .normal)
        contactLbl.textColor = UIColor.white
        ticketManagementTableView.isHidden = true
        contactView.isHidden = false
        
    }
    
    @IBAction func raiseTicketBtn(_ sender: Any) {
        let vc = RaiseTicketViewController.instantiate(fromAppStoryboard: .DashBoard)
        self.present(vc, animated: true)
    }
    
    @IBAction func ticketManagementBtn(_ sender: Any) {
        contactBtn.setImage(UIImage(named: ""), for: .normal)
        contactLbl.textColor = UIColor.black
        
        ticketmanagementbtn.setImage(UIImage(named: "btnGradient"), for: .normal)
        ticketmanagementLbl.textColor = UIColor.white
        ticketManagementTableView.isHidden = false
        contactView.isHidden = true
    }
    
    @IBAction func nextButtonDidTapped(_ sender: Any) {
        viewModel.goToNextPage()
    }
    
    @IBAction func previousButtonDidTapped(_ sender: Any) {
        viewModel.goToPreviousPage()
    }
    
    //MARK: Function's declaration
    func updatePaginationButtonImages() {
        // Previous Button
        if viewModel.currentPage == 1 {
            previousButton.setImage(UIImage(named: "previousLeft"), for: .normal)
            previousButton.isUserInteractionEnabled = false
        } else {
            previousButton.setImage(UIImage(named: "darkpreviousimage"), for: .normal)
            previousButton.isUserInteractionEnabled = true
        }
        
        // Next Button
        if viewModel.currentPage >= viewModel.totalPages {
            nextButton.setImage(UIImage(named: "lightnextimage"), for: .normal)
            nextButton.isUserInteractionEnabled = false
        } else {
            nextButton.setImage(UIImage(named: "nextRight"), for: .normal)
            nextButton.isUserInteractionEnabled = true
        }
    }
}

extension SupportViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.ticketsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketManagementTableViewCell", for: indexPath) as! TicketManagementTableViewCell
        let data = viewModel.ticketsList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TicketDetailViewController.instantiate(fromAppStoryboard: .DashBoard)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: UITextFieldDelegate Methods
extension SupportViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        
        // Cancel previous search work item
        searchWorkItem?.cancel()
        
        // Create new one
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            self.viewModel.currentPage = 1
            self.viewModel.getAllTicketListRequest()
        }
        
        // Store and execute after delay
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        
        return true
    }
}
