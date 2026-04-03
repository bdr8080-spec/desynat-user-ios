//
//  ShowViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class ShowViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var tvLiveUsers: UITableView!
    @IBOutlet weak var dataFoundLable: UILabel!
    
    // MARK: - Property Decalaration
    private lazy var viewModel = ShowViewModel(hostVC: self)
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tvLiveUsers.register(UINib(nibName: "LiveUsersCell", bundle: nil), forCellReuseIdentifier: "LiveUsersCell")
        tvLiveUsers.delegate = self
        tvLiveUsers.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAllLiveStreamingRequest()
    }
    
    // MARK: - Button's Action
    @IBAction func goLiveTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "Home", bundle: nil)
            .instantiateViewController(withIdentifier: "LiveStreamingViewController") as! LiveStreamingViewController
        vc.isHost = false
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    //MARK: Function's declaration
    @objc func handleJoinLiveTapped(_ sender:UIButton) {
        let vc = UIStoryboard(name: "Home", bundle: nil)
            .instantiateViewController(withIdentifier: "LiveStreamingViewController") as! LiveStreamingViewController
        vc.isHost = false
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

extension ShowViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.AllLiveStraming?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveUsersCell", for: indexPath) as! LiveUsersCell
        cell.configData(data: viewModel.AllLiveStraming?[indexPath.row])
        cell.onWatchLiveSelect = { [weak self] in
            self?.viewModel.generateLiveStramingTokenRequest(id: self?.viewModel.AllLiveStraming?[indexPath.row].id ?? 0)
        }
        return cell
    }
}
