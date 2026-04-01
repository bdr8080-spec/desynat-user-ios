//
//  ReelsScrollViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 01/04/26.
//


import UIKit
import AVKit

class ReelsScrollViewController: UIViewController {

    @IBOutlet weak var reelsCollectionView: UICollectionView! {
        didSet {
            reelsCollectionView.registerCellFromNib(cellID: "ReelsScrollCollectionViewCell")
            reelsCollectionView.isPagingEnabled = true
            reelsCollectionView.showsVerticalScrollIndicator = false
        }
    }

    private lazy var viewModel = ReelsScrollViewModel(hostVC: self)

    private var reels: [Reel] = []
    private var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadDummyData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.playReel(at: 0)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        pauseAll()
    }

    private func setupCollectionView() {
        reelsCollectionView.delegate = self
        reelsCollectionView.dataSource = self
        
        if let flow = reelsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.scrollDirection = .vertical
            flow.minimumLineSpacing = 0
        }
    }

    private func loadDummyData() {
        reels = [
            Reel(id: 1,
                 videoURL: "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
                 caption: "Beautiful nature 🌿"),

            Reel(id: 2,
                 videoURL: "https://sample-videos.com/video123/mp4/720/elephants_dream_720p_1mb.mp4",
                 caption: "Dream animation ✨"),

            Reel(id: 3,
                 videoURL: "https://sample-videos.com/video123/mp4/720/for_bigger_joyrides_720p_1mb.mp4",
                 caption: "Adventure time 🏞️")
        ]

        reelsCollectionView.reloadData()
    }

    private func playReel(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        if let cell = reelsCollectionView.cellForItem(at: indexPath) as? ReelsScrollCollectionViewCell {
            cell.playVideo()
        }
    }

    private func pauseAll() {
        reelsCollectionView.visibleCells.forEach {
            ($0 as? ReelsScrollCollectionViewCell)?.pauseVideo()
        }
    }
    
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
}

extension ReelsScrollViewController:
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        reels.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReelsScrollCollectionViewCell",
                                                      for: indexPath) as! ReelsScrollCollectionViewCell

        let reel = reels[indexPath.item]
        cell.configure(with: reel)

        if indexPath.item == currentIndex {
            cell.playVideo()
        } else {
            cell.pauseVideo()
        }

        // 🔥 Restored share & like actions
        cell.onShareTapped = { [weak self] in
            guard let id = reel.id else { return }
            self?.viewModel.selectedReelId = id
            self?.viewModel.shareReelsRequest()
        }

        cell.onLikeTapped = { [weak self] in
            guard let id = reel.id else { return }
            self?.viewModel.selectedReelId = id
            self?.viewModel.addRemoveReelsFromWishlistRequest()
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return collectionView.bounds.size
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let visibleCenter = CGPoint(
            x: reelsCollectionView.bounds.midX,
            y: reelsCollectionView.contentOffset.y + reelsCollectionView.bounds.midY
        )

        if let newIndex = reelsCollectionView.indexPathForItem(at: visibleCenter)?.item {
            if newIndex != currentIndex {
                pauseAll()
                currentIndex = newIndex
                playReel(at: newIndex)
            }
        }
    }
}
