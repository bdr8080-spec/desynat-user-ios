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
    var sellerId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        getReelsData()
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

    // MARK: - Load API Data
    private func getReelsData() {
        viewModel.getSellerReelsService(sellerId: sellerId) { [weak self] in
            guard let self = self else { return }

            // Convert API model → local Reel model
            self.reels = self.viewModel.sellerReels.map {
                Reel(id: $0.id,
                     videoURL: $0.file,
                     caption: $0.title)
            }

            DispatchQueue.main.async {
                self.reelsCollectionView.reloadData()
                self.playReel(at: 0)
            }
        }
    }

    // MARK: - Video Controls
    private func playReel(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)

        DispatchQueue.main.async {
            if let cell = self.reelsCollectionView.cellForItem(at: indexPath) as? ReelsScrollCollectionViewCell {
                cell.playVideo()
            }
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

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ReelsScrollCollectionViewCell",
            for: indexPath
        ) as! ReelsScrollCollectionViewCell

        let reel = reels[indexPath.item]
        cell.configure(with: reel)

        // Auto play/pause
        if indexPath.item == currentIndex {
            cell.playVideo()
        } else {
            cell.pauseVideo()
        }

        // MARK: - SHARE BUTTON
        cell.onShareTapped = { [weak self] in
            guard let id = reel.id else { return }
            self?.viewModel.selectedReelId = id
            self?.viewModel.shareReelsRequest()
        }

        // MARK: - LIKE BUTTON (local + API)
        let isLiked = (viewModel.sellerReels[indexPath.item].isWhishlisted ?? 0) == 1
        cell.likeButton.isSelected = isLiked

        cell.onLikeTapped = { [weak self] in
            guard let self = self else { return }

            guard let id = reel.id else { return }
            self.viewModel.selectedReelId = id

            // Toggle Local State
            if let idx = self.viewModel.sellerReels.firstIndex(where: { $0.id == id }) {
                let current = self.viewModel.sellerReels[idx].isWhishlisted ?? 0
                self.viewModel.sellerReels[idx].isWhishlisted = (current == 1) ? 0 : 1
                self.reelsCollectionView.reloadItems(at: [indexPath])
            }

            // API Request
            self.viewModel.addRemoveReelsFromWishlistRequest()
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.bounds.size
    }

    // MARK: - Scroll Detect
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let visibleCenter = CGPoint(
            x: reelsCollectionView.bounds.midX,
            y: reelsCollectionView.contentOffset.y + reelsCollectionView.bounds.midY
        )

        guard let newIndex = reelsCollectionView.indexPathForItem(at: visibleCenter)?.item else { return }

        if newIndex != currentIndex {
            pauseAll()                 // pause previous video
            currentIndex = newIndex

            // Reload only the new cell so its player gets created
            reelsCollectionView.reloadItems(at: [IndexPath(item: newIndex, section: 0)])

            // 🔥 PLAY AFTER 0.1 sec so cell is fully laid out
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.playReel(at: newIndex)
            }
        }
    }
}
