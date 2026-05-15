//
//  ReelsScrollCollectionViewCell.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 01/04/26.
//

import UIKit
import AVFoundation

class ReelsScrollCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btnLike: UIImageView!
    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var shareButton: RTLButton!
    @IBOutlet weak var likeButton: UIButton!
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    var onPlayPauseTapped: (() -> Void)?
    var onShareTapped: (() -> Void)?
    var onLikeTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Tap gesture on video
        let tap = UITapGestureRecognizer(target: self, action: #selector(videoTapped))
        videoContainerView.addGestureRecognizer(tap)
        videoContainerView.isUserInteractionEnabled = true
    }
    
    @objc private func videoTapped() {
        togglePlayPause()
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//
//        NotificationCenter.default.removeObserver(self)
//
//        player?.pause()
//        player = nil
//
//        playerLayer?.player = nil
//        playerLayer?.removeFromSuperlayer()
//        playerLayer = nil
//    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        NotificationCenter.default.removeObserver(self)

        player?.pause()
        player?.replaceCurrentItem(with: nil)
        player = nil

        playerLayer?.player = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil

        playPauseButton.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = videoContainerView.bounds
    }
    
    func isPlaying() -> Bool {
        return player?.timeControlStatus == .playing
    }
    
    func configure(with reel: Reel) {
        captionLabel.text = reel.caption ?? ""
        setupVideo(urlString: reel.videoURL)

        // Always hide play/pause button on new cell
        playPauseButton.isHidden = true

        btnLike.image = reel.isWhishlisted == 1 ? .selectedHeart : .besSellLike
    }
    
    // MARK: - VIDEO SETUP
    private func setupVideo(urlString: String?) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else { return }
        
        // Avoid duplicate layer stacking
        playerLayer?.removeFromSuperlayer()
        
        // Build new Player
        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        playerLayer?.frame = videoContainerView.bounds
        
        if let layer = playerLayer {
            videoContainerView.layer.insertSublayer(layer, at: 0)
        }
        
        // Loop video
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loopVideo),
            name: .AVPlayerItemDidPlayToEndTime,
            object: item
        )
    }
    
    // MARK: - PLAY / PAUSE CONTROL
    func playVideo() {

        guard let player = player else { return }

        player.play()

        playPauseButton.isHidden = true
    }

//    func pauseVideo() {
//        player?.pause()
//        playPauseButton.isHidden = false
//    }
    
    func pauseVideo(showPlayIcon: Bool = false) {

        player?.pause()

        playPauseButton.isHidden = !showPlayIcon
    }
    
//    func togglePlayPause() {
//        guard let player = player else { return }
//        
//        if player.timeControlStatus == .playing {
//            pauseVideo()
//        } else {
//            playVideo()
//        }
//    }
    
    func togglePlayPause() {

        guard let player = player else { return }

        if player.timeControlStatus == .playing {

            pauseVideo(showPlayIcon: true)

        } else {

            playVideo()
        }
    }
    
    @objc private func loopVideo() {
        player?.seek(to: .zero)
        player?.play()
    }
    
    // MARK: - BUTTON ACTIONS
    @IBAction func playPauseTapped(_ sender: UIButton) {
        togglePlayPause()
        onPlayPauseTapped?()
    }
    
    @IBAction func shareTapped(_ sender: UIButton) {
        onShareTapped?()
    }
    
    @IBAction func likeTapped(_ sender: UIButton) {
        onLikeTapped?()
    }
}
