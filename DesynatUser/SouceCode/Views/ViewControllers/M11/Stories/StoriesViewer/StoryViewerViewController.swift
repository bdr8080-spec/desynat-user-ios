//
//  StoryViewerViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 27/03/26.
//

import UIKit
import AVFoundation

class StoryViewerViewController: UIViewController {
    
    @IBOutlet weak var storiesCollectionView: UICollectionView! {
        didSet {
            storiesCollectionView.registerCellFromNib(cellID: "StorieDetailsCollectionViewCell")
        }
    }
    @IBOutlet weak var topSliderCollectionView: UICollectionView! {
        didSet {
            topSliderCollectionView.registerCellFromNib(cellID: "StorieTopSliderCollectionViewCell")
        }
    }
    
    // MARK: - Variables
    var users: [UserStories] = []
    var currentUserIndex = 0
    var currentStoryIndex = 0
    var currentProgress: CGFloat = 0.0
    var timer: Timer?
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDummyStories()
        view.backgroundColor = .black
        setupUI()
        setupCollectionViews()
        showStory()
    }
    
    // MARK: - Dummy Stories
    func loadDummyStories() {
        let img1 = "https://picsum.photos/800/1400"
        let img2 = "https://picsum.photos/801/1401"
        let img3 = "https://picsum.photos/802/1402"
        
        let video1 = "https://www.w3schools.com/html/mov_bbb.mp4"
        let video2 = "https://www.w3schools.com/html/movie.mp4"
        
        let user1Stories: [Story] = [
            Story(url: img1, isVideo: false, duration: 5),
            Story(url: video1, isVideo: true, duration: nil),
            Story(url: img2, isVideo: false, duration: 4)
        ]
        
        let user2Stories: [Story] = [
            Story(url: img3, isVideo: false, duration: 3),
            Story(url: video2, isVideo: true, duration: nil),
            Story(url: img1, isVideo: false, duration: 6)
        ]
//        
        users = [
            UserStories(userName: "Rakhi", stories: user1Stories),
//            UserStories(userName: "John", stories: user2Stories)
        ]
    }
    
    private func setupUI() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(close))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        // Tap on left half / right half of screen (like Instagram Stories)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupCollectionViews() {
        storiesCollectionView.isPagingEnabled = true
        storiesCollectionView.showsHorizontalScrollIndicator = false
        storiesCollectionView.isScrollEnabled = false  // We control navigation manually
        storiesCollectionView.backgroundColor = .black
        
        if let layout = storiesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.scrollDirection = .horizontal
        }
        
        topSliderCollectionView.backgroundColor = .clear
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if location.x < view.bounds.width / 2 {
            didTapLeft()
        } else {
            didTapRight()
        }
    }
    
    @IBAction func crossDidTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - Validation
    func isValidUserIndex(_ index: Int) -> Bool {
        return index >= 0 && index < users.count
    }
    
    func isValidStoryIndex(for userIndex: Int, storyIndex: Int) -> Bool {
        guard isValidUserIndex(userIndex),
              let stories = users[userIndex].stories else { return false }
        return storyIndex >= 0 && storyIndex < stories.count
    }
    
    // MARK: - Show Story
    func showStory() {
        timer?.invalidate()
        cleanupPlayer()
        
        guard let currentUser = users[safe: currentUserIndex],
              let stories = currentUser.stories,
              let story = stories[safe: currentStoryIndex] else {
            goToNextUser()
            return
        }
        
        currentProgress = 0.0
        topSliderCollectionView.reloadData()
        
        storiesCollectionView.scrollToItem(
            at: IndexPath(item: currentStoryIndex, section: 0),
            at: .centeredHorizontally,
            animated: false
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            guard let self else { return }
            if story.isVideo {
                self.playVideo(story.url)
            } else {
                self.showImage(story.url, duration: story.duration ?? 5.0)
            }
        }
    }
    
    // MARK: - Show Image
    func showImage(_ urlString: String?, duration: TimeInterval) {
        guard let urlString, let url = URL(string: urlString) else {
            goNextStory()
            return
        }
        
        guard let cell = storiesCollectionView.cellForItem(at: IndexPath(item: currentStoryIndex, section: 0)) as? StorieDetailsCollectionViewCell else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? Data(contentsOf: url), let img = UIImage(data: data) {
                DispatchQueue.main.async {
                    cell.mainImageView.image = img
                    cell.mainImageView.contentMode = .scaleAspectFill
                }
            }
        }
        
        startProgress(duration: duration)
    }
    
    // MARK: - Play Video
    func playVideo(_ urlString: String?) {
        guard let urlString, let videoURL = URL(string: urlString) else {
            goNextStory()
            return
        }
        
        guard let cell = storiesCollectionView.cellForItem(at: IndexPath(item: currentStoryIndex, section: 0)) as? StorieDetailsCollectionViewCell else {
            goNextStory()
            return
        }
        
        cleanupPlayer()
        
        player = AVPlayer(url: videoURL)
        let layer = AVPlayerLayer(player: player)
        layer.frame = cell.mainImageView.bounds
        layer.videoGravity = .resizeAspectFill
        playerLayer = layer
        
        cell.mainImageView.layer.addSublayer(layer)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(videoEnded),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
        
        player?.play()
        
        let duration = player?.currentItem?.asset.duration.seconds ?? 8.0
        startProgress(duration: duration)
    }
    
    private func cleanupPlayer() {
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        player = nil
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    // MARK: - Progress Bar
    func startProgress(duration: TimeInterval) {
        timer?.invalidate()
        currentProgress = 0.0
        topSliderCollectionView.reloadData()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.currentProgress += CGFloat(0.016 / duration)
            
            if self.currentProgress >= 1.0 {
                self.currentProgress = 1.0
                self.goNextStory()
            }
            
            self.topSliderCollectionView.reloadData()
        }
    }
    
    // MARK: - Navigation
    @objc func didTapLeft() {
        timer?.invalidate()
        if currentStoryIndex > 0 {
            currentStoryIndex -= 1
        } else if currentUserIndex > 0 {
            currentUserIndex -= 1
            currentStoryIndex = (users[currentUserIndex].stories?.count ?? 1) - 1
        } else {
            return
        }
        showStory()
    }
    
    @objc func didTapRight() {
        timer?.invalidate()
        goNextStory()
    }
    
    func goNextStory() {
        currentStoryIndex += 1
        
        if !isValidStoryIndex(for: currentUserIndex, storyIndex: currentStoryIndex) {
            goToNextUser()
            return
        }
        
        showStory()
    }
    
    func goToNextUser() {
        currentUserIndex += 1
        currentStoryIndex = 0
        
        if !isValidUserIndex(currentUserIndex) {
            dismiss(animated: true)
            return
        }
        
        showStory()
    }
    
    @objc func videoEnded() {
        goNextStory()
    }
    
    @objc func close() {
        dismiss(animated: true)
    }
    
    deinit {
        cleanupPlayer()
        timer?.invalidate()
    }
}

// MARK: - CollectionView DataSource & Delegate
extension StoryViewerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users[currentUserIndex].stories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == topSliderCollectionView {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "StorieTopSliderCollectionViewCell",
                for: indexPath
            ) as! StorieTopSliderCollectionViewCell
            
            let isActive = indexPath.item == currentStoryIndex
            let progress: CGFloat = isActive ? currentProgress : (indexPath.item < currentStoryIndex ? 1.0 : 0.0)
            
            cell.configure(isActive: isActive, progress: progress)
            return cell
        }
        
        // Story cell
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "StorieDetailsCollectionViewCell",
            for: indexPath
        ) as! StorieDetailsCollectionViewCell
        
        // Clear previous content
        cell.mainImageView.image = nil
        cell.mainImageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        if collectionView == topSliderCollectionView {
            let count = CGFloat(users[currentUserIndex].stories?.count ?? 1)
            let spacing: CGFloat = 6.0
            let width = (view.bounds.width - (spacing * (count - 1))) / count
            return CGSize(width: max(width, 20), height: 4)
        }
        
        // Full screen story view
        return CGSize(width: storiesCollectionView.bounds.width,
                      height: storiesCollectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView == topSliderCollectionView ? 6 : 0
    }
}

// MARK: - Safe Array Subscript
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
