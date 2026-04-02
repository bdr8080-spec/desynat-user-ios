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
    @IBOutlet weak var lblLive: CustomLabelFont!
    
    // MARK: - Property Decalaration
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tvLiveUsers.register(UINib(nibName: "LiveUsersCell", bundle: nil), forCellReuseIdentifier: "LiveUsersCell")
        tvLiveUsers.delegate = self
        tvLiveUsers.dataSource = self
        lblLive.layer.cornerRadius = 8
        lblLive.clipsToBounds = true
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveUsersCell", for: indexPath) as! LiveUsersCell
        cell.btnJoinLive.tag = indexPath.row
        cell.btnJoinLive.addTarget(self, action: #selector(handleJoinLiveTapped), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
}
