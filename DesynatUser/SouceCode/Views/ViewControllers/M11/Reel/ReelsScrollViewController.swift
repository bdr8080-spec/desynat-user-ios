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
    private var isVideoPlaying = true
    private var reels: [Reel] = []
    var currentIndex = 0
    var sellerId: Int = 0
    var isComingFromMywishlist: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        getReelsData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.playReel(at: self.currentIndex)
        }
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        let indexPath = IndexPath(item: currentIndex, section: 0)
//
//        reelsCollectionView.scrollToItem(
//            at: indexPath,
//            at: .centeredVertically,
//            animated: false
//        )
//    }
    
    private func scrollToInitialIndex() {

        guard reels.count > 0 else { return }

        guard currentIndex < reels.count else { return }

        let indexPath = IndexPath(item: currentIndex, section: 0)

        reelsCollectionView.layoutIfNeeded()

        reelsCollectionView.scrollToItem(
            at: indexPath,
            at: .centeredVertically,
            animated: false
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {

            if let cell = self.reelsCollectionView.cellForItem(at: indexPath)
                as? ReelsScrollCollectionViewCell {

                cell.playVideo()
            }
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
        if isComingFromMywishlist {
            viewModel.getReelsWishlistRequest() { [weak self] in
                guard let self = self else { return }
                
                self.reels = self.viewModel.reelsList.map {
                    Reel(id: $0.reelID,
                         videoURL: $0.reelDetails?.file,
                         caption: $0.reelDetails?.caption ?? "",
                         isWhishlisted: 1
                    )
                }
                
                DispatchQueue.main.async {

                    self.reelsCollectionView.reloadData()

                    self.scrollToInitialIndex()
                }
            }
        } else {
            viewModel.getSellerReelsService(sellerId: sellerId) { [weak self] in
                guard let self = self else { return }
                
                self.reels = self.viewModel.sellerReels.map {
                    Reel(id: $0.id,
                         videoURL: $0.file,
                         caption: $0.caption,
                         isWhishlisted: $0.isWhishlisted
                    )
                }
                
                DispatchQueue.main.async {

                    self.reelsCollectionView.reloadData()

                    self.scrollToInitialIndex()
                }
            }
        }
    }

    // MARK: - Video Controls
    private func playReel(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)

        if let cell = reelsCollectionView.cellForItem(at: indexPath) as? ReelsScrollCollectionViewCell {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                cell.playVideo()
            }
        }
    }

    private func pauseAll() {
        for cell in reelsCollectionView.visibleCells {
            (cell as? ReelsScrollCollectionViewCell)?.pauseVideo()
        }
    }

    @IBAction func backDidTapped(_ sender: Any) {
        dismiss(animated: false)
    }
    
    func openShareSheet(urlString: String) {

        guard let url = URL(string: urlString) else { return }

        let activityVC = UIActivityViewController(activityItems: [url],
                                                  applicationActivities: nil)

        activityVC.excludedActivityTypes = [.assignToContact]

        present(activityVC, animated: true)
    }
}

extension ReelsScrollViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        reels.count
    }

    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReelsScrollCollectionViewCell",for: indexPath) as! ReelsScrollCollectionViewCell

        let reel = reels[indexPath.item]
        cell.configure(with: reel)

        // Auto Play Current Index
//        if indexPath.item == currentIndex {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
//                cell.playVideo()
//            }
//        } else {
//            cell.pauseVideo()
//        }
        
        cell.onPlayPauseTapped = { [weak self, weak cell] in

            guard let self = self,
                  let cell = cell else { return }

            self.isVideoPlaying = cell.isPlaying()
        }

        // MARK: - SHARE BUTTON
        cell.onShareTapped = { [weak self] in
            guard let self = self else { return }
            guard let id = reel.id else { return }

            self.viewModel.selectedReelId = id

            self.viewModel.shareReelsRequest { link in
                guard let link = link else { return }
                self.openShareSheet(urlString: link)
            }
        }

        // MARK: - LIKE BUTTON
        cell.onLikeTapped = { [weak self, weak cell] in
            guard let self = self,
                  let cell = cell,
                  let id = reel.id else { return }

            self.viewModel.selectedReelId = id

            if let idx = self.viewModel.sellerReels.firstIndex(where: { $0.id == id }) {

                let current = self.viewModel.sellerReels[idx].isWhishlisted ?? 0
                let newValue = current == 1 ? 0 : 1

                self.viewModel.sellerReels[idx].isWhishlisted = newValue
                self.reels[indexPath.item].isWhishlisted = newValue

                cell.btnLike.image = newValue == 1 ? .selectedHeart : .besSellLike
            }

            self.viewModel.addRemoveReelsFromWishlistRequest()
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.bounds.size
    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        willDisplay cell: UICollectionViewCell,
//                        forItemAt indexPath: IndexPath) {
//
//        guard let cell = cell as? ReelsScrollCollectionViewCell else { return }
//
//        if indexPath.item == currentIndex {
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                cell.playVideo()
//            }
//        }
//    }

    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {

        guard let cell = cell as? ReelsScrollCollectionViewCell else { return }

        cell.pauseVideo()
    }

    // MARK: - Scroll Detect
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let centerPoint = CGPoint(x: reelsCollectionView.bounds.midX,y: reelsCollectionView.contentOffset.y + reelsCollectionView.bounds.midY)
//        guard let newIndex = reelsCollectionView.indexPathForItem(at: centerPoint)?.item else { return }
//        if newIndex != currentIndex {
//            // Pause old reel
//            if let oldCell = reelsCollectionView.cellForItem(
//                at: IndexPath(item: currentIndex, section: 0)
//            ) as? ReelsScrollCollectionViewCell {
//                oldCell.pauseVideo()
//            }
//            currentIndex = newIndex
//            // Play new reel
//            if let newCell = reelsCollectionView.cellForItem(
//                at: IndexPath(item: newIndex, section: 0)
//            ) as? ReelsScrollCollectionViewCell {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
//                    newCell.playVideo()
//                }
//            }
//        }
//    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                  willDecelerate decelerate: Bool) {

        if !decelerate {
            playCenteredVideo()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        playCenteredVideo()
    }
    
    private func playCenteredVideo() {

        let visibleRect = CGRect(
            origin: reelsCollectionView.contentOffset,
            size: reelsCollectionView.bounds.size
        )

        let visiblePoint = CGPoint(
            x: visibleRect.midX,
            y: visibleRect.midY
        )

        guard let indexPath = reelsCollectionView.indexPathForItem(at: visiblePoint) else {
            return
        }

        // Same reel
        if currentIndex == indexPath.item {
            return
        }

        // Pause ALL visible cells first
        for case let cell as ReelsScrollCollectionViewCell in reelsCollectionView.visibleCells {
            cell.pauseVideo()
        }

        currentIndex = indexPath.item

        // IMPORTANT:
        // Wait until collectionview finishes layout
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in

            guard let self = self else { return }

            guard let cell = self.reelsCollectionView.cellForItem(at: indexPath)
                    as? ReelsScrollCollectionViewCell else {
                return
            }

            if self.isVideoPlaying {
                cell.playVideo()
            } else {
                cell.pauseVideo(showPlayIcon: true)
            }
        }
    }
    
}
