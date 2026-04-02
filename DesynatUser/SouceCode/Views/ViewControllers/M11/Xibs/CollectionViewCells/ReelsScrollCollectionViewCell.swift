//
//  ReelsScrollCollectionViewCell.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 01/04/26.
//

import UIKit
import AVFoundation

class ReelsScrollCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!

    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    var onPlayPauseTapped: (() -> Void)?
    var onShareTapped: (() -> Void)?
    var onLikeTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        // Tap on video to play/pause
        let tap = UITapGestureRecognizer(target: self, action: #selector(videoTapped))
        videoContainerView.addGestureRecognizer(tap)
        videoContainerView.isUserInteractionEnabled = true
    }
    
    @objc private func videoTapped() {
        togglePlayPause()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        NotificationCenter.default.removeObserver(self)
        
        player?.pause()
        player = nil
        
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = videoContainerView.bounds
    }

    func configure(with reel: Reel) {
        captionLabel.text = reel.caption ?? ""
        setupVideo(urlString: reel.videoURL)
        
    }

    private func setupVideo(urlString: String?) {
        
        guard let urlString = urlString,
              let url = URL(string: urlString) else { return }

        // 🔥 Remove old layer
        playerLayer?.removeFromSuperlayer()

        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)

        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        playerLayer?.frame = videoContainerView.bounds

        if let layer = playerLayer {
            videoContainerView.layer.addSublayer(layer)
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loopVideo),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
    }

    func playVideo() {
        player?.play()
        playPauseButton.isHidden = true
    }

    func pauseVideo() {
        player?.pause()
        playPauseButton.isHidden = false
    }

    func togglePlayPause() {
        if player?.timeControlStatus == .playing {
            pauseVideo()
        } else {
            playVideo()
        }
    }

    @objc private func loopVideo() {
        player?.seek(to: .zero)
        player?.play()
    }

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
