//
//  SearchVC.swift
//  DesynatUser
//
//  Created by fluper on 22/12/25.
//

import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var latestSearchCollectionView: CollViewAdjustedHeight!
    @IBOutlet weak var recommendedCollectionView: CollViewAdjustedHeight!
    @IBOutlet weak var RecentSearchTableView: TableViewDynamicHeight!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
    }
    
    func registerXib() {
        latestSearchCollectionView.delegate = self
        latestSearchCollectionView.dataSource = self
        latestSearchCollectionView.register(UINib(nibName: "LatestSearchCollectionCell", bundle: nil), forCellWithReuseIdentifier: "LatestSearchCollectionCell")
        
        recommendedCollectionView.delegate = self
        recommendedCollectionView.dataSource = self
        recommendedCollectionView.register(UINib(nibName: "RecommendCollectionCell", bundle: nil), forCellWithReuseIdentifier: "RecommendCollectionCell")
        
        RecentSearchTableView.delegate = self
        RecentSearchTableView.dataSource = self
        RecentSearchTableView.register(UINib(nibName: "RecentSearchTableCell", bundle: nil), forCellReuseIdentifier: "RecentSearchTableCell")
    }
    
    @IBAction func btnSearch(_ sender: Any) {
    }
    
    @IBAction func btnGo(_ sender: Any) {
    }
    
    @IBAction func btnCamera(_ sender: Any) {
    }
    
    @IBAction func btnMic(_ sender: Any) {
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RecentSearchTableView.dequeueReusableCell(withIdentifier: "RecentSearchTableCell", for: indexPath) as! RecentSearchTableCell
        return cell
    }
}

extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch UICollectionView() {
        case latestSearchCollectionView:
            return 6
            
        case recommendedCollectionView:
            return 4
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch UICollectionView() {
        case latestSearchCollectionView:
            let cell = latestSearchCollectionView.dequeueReusableCell(withReuseIdentifier: "LatestSearchCollectionCell", for: indexPath) as! LatestSearchCollectionCell
            return cell
            
        case recommendedCollectionView:
            let cell = recommendedCollectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCollectionCell", for: indexPath) as! RecommendCollectionCell
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
}
