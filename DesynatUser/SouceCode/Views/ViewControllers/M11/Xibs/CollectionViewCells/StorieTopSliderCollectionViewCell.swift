//
//  StorieTopSliderCollectionViewCell.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 27/03/26.
//

import UIKit

class StorieTopSliderCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var progressBackgroundView: UIView!
    @IBOutlet weak var progressFillView: UIView!
    @IBOutlet weak var progressFillWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private var totalWidth: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update total width when layout changes (important for rotation or size changes)
        totalWidth = progressBackgroundView.bounds.width
    }
    
    private func setupUI() {
        // Background (inactive / remaining part)
        progressBackgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.35)
        progressBackgroundView.layer.cornerRadius = 1.5
        progressBackgroundView.clipsToBounds = true
        
        // Progress fill (white like Instagram)
        progressFillView.backgroundColor = .white
        progressFillView.layer.cornerRadius = 1.5
    }
    
    // MARK: - Configure
    func configure(isActive: Bool, progress: CGFloat) {
        
        // Reset constraint if needed
        if totalWidth == 0 {
            totalWidth = progressBackgroundView.bounds.width
        }
        
        if !isActive {
            // Previous stories - fully filled
            progressFillWidthConstraint.constant = totalWidth
            progressFillView.backgroundColor = .white
        } else {
            // Current playing story
            progressFillView.backgroundColor = .white
            let fillWidth = totalWidth * max(0.0, min(1.0, progress))
            progressFillWidthConstraint.constant = fillWidth
        }
        
        // Force immediate layout update for smooth progress
        layoutIfNeeded()
    }
    
    // Optional: Reset cell when reused
    override func prepareForReuse() {
        super.prepareForReuse()
        progressFillWidthConstraint.constant = 0
    }
}
