//
//  RangeSliderView.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//


import UIKit

class RangeSliderView: UIControl {
    
    // MARK: - Public Values
    var minValue: CGFloat = 0 {
        didSet { setNeedsLayout(); updateLabels() }
    }
    var maxValue: CGFloat = 100 {
        didSet { setNeedsLayout(); updateLabels() }
    }
    
    // Left fixed, center movable, right fixed
    var initialValue: CGFloat = 0 { didSet { setNeedsLayout(); updateLabels() } }
    var currentValue: CGFloat = 50 { didSet { setNeedsLayout(); updateLabels() } }
    var endValue: CGFloat = 100 { didSet { setNeedsLayout(); updateLabels() } }
    
    // MARK: - Layers
    private let unselectedTrack = CALayer()
    private let selectedTrack = CALayer() // between left and center
    private let leftThumb = CALayer()
    private let centerThumb = CALayer()
//    private let rightThumb = CALayer()
    
    // MARK: - Labels
    private let minLabel = UILabel()
    private let currentLabel = UILabel()
    private let maxLabel = UILabel()
    
    // Thumb size
    private let thumbSize: CGFloat = 24
    
    // Colors
    private let mainColor = UIColor(hex: "#6E4527")
    private let fadedColor = UIColor(hex: "#6E4527").withAlphaComponent(0.2)
    
    // Touch tracking
    private var isTrackingCenterThumb = false
    
    // Expand touch area for easier grabbing
    private let touchExpansion: CGFloat = 10
    private var touchOffset: CGFloat = 0

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    private func commonInit() {
        setupLayers()
        setupLabels()
    }
    
    // MARK: - Setup
    private func setupLayers() {
        // Unselected track (full)
        unselectedTrack.backgroundColor = fadedColor.cgColor
        layer.addSublayer(unselectedTrack)
        
        // Selected track (left..center)
        selectedTrack.backgroundColor = mainColor.cgColor
        layer.addSublayer(selectedTrack)
        
        // Left thumb (fixed)
        leftThumb.backgroundColor = mainColor.cgColor
        leftThumb.cornerRadius = thumbSize / 2
        leftThumb.masksToBounds = true
        layer.addSublayer(leftThumb)
        
        // Center thumb (movable)
        centerThumb.backgroundColor = mainColor.cgColor
        centerThumb.cornerRadius = thumbSize / 2
        centerThumb.masksToBounds = true
        layer.addSublayer(centerThumb)
        
        // Right thumb (fixed)
//        rightThumb.backgroundColor = mainColor.cgColor
//        rightThumb.cornerRadius = thumbSize / 2
//        rightThumb.masksToBounds = true
//        layer.addSublayer(rightThumb)
    }
    
    private func setupLabels() {
        [minLabel, currentLabel, maxLabel].forEach { lbl in
            lbl.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            lbl.textColor = UIColor.black
            lbl.textAlignment = .center
            lbl.numberOfLines = 1
            addSubview(lbl)
        }
        updateLabels()
    }
    
    private func formatKD(_ value: CGFloat) -> String {
        return "KD \(Int(value))"
    }

    
    private func updateLabels() {
        // Use formatting you prefer (Int for now)
//        minLabel.text = "\(Int(initialValue))"
//        currentLabel.text = "\(Int(currentValue))"
//        maxLabel.text = "\(Int(endValue))"
        minLabel.text = formatKD(initialValue)
        currentLabel.text = formatKD(currentValue)
        maxLabel.text = formatKD(endValue)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Make sure control has enough height to show thumb fully + labels below.
        // thumbSize + label height + spacing should fit in bounds.height
        let trackHeight: CGFloat = 4
        let trackY = (bounds.height - thumbSize - 20) / 2 + (thumbSize - trackHeight) / 2 // center track relative to thumbs
        
        // Full (unselected) track
        unselectedTrack.frame = CGRect(x: 0, y: trackY, width: bounds.width, height: trackHeight)
        unselectedTrack.cornerRadius = trackHeight/2
        
        // X positions
        let leftX = valueToX(initialValue)
        let centerX = valueToX(currentValue)
        let rightX = valueToX(endValue)
        
        // Selected track from left -> center
        let selX = min(leftX, centerX)
        let selW = max(1, abs(centerX - leftX))
        selectedTrack.frame = CGRect(x: selX, y: trackY, width: selW, height: trackHeight)
        selectedTrack.cornerRadius = trackHeight/2
        
        // Thumb Y (fully visible)
        let thumbY = (bounds.height - thumbSize - 18) / 2 // leave room for labels below (~18)
        
        leftThumb.frame = CGRect(x: leftX - thumbSize/2, y: thumbY, width: thumbSize, height: thumbSize)
        centerThumb.frame = CGRect(x: centerX - thumbSize/2, y: thumbY, width: thumbSize, height: thumbSize)
//        rightThumb.frame = CGRect(x: rightX - thumbSize/2, y: thumbY, width: thumbSize, height: thumbSize)
        
        // Labels below thumbs (adjust to stay within bounds)
        let labelHeight: CGFloat = 16
        let labelY = thumbY + thumbSize + 4
        minLabel.frame = CGRect(x: leftX - 30, y: labelY, width: 60, height: labelHeight)
        currentLabel.frame = CGRect(x: centerX - 30, y: labelY, width: 60, height: labelHeight)
        maxLabel.frame = CGRect(x: rightX - 30, y: labelY, width: 60, height: labelHeight)
    }
    
    // Convert value -> x (clamped inside bounds)
    private func valueToX(_ value: CGFloat) -> CGFloat {
        // Protect against division by zero
        guard maxValue != minValue else { return 0 }
        let pct = (value - minValue) / (maxValue - minValue)
        return pct * bounds.width
    }
    // Convert x -> value clamped to min/max
    private func xToValue(_ x: CGFloat) -> CGFloat {
        let pct = max(0, min(1, x / bounds.width))
        return minValue + pct * (maxValue - minValue)
    }
    
    // MARK: - Touch Handling (center thumb only)
//    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
//        let p = touch.location(in: self)
//        // Expand the hit area for easier grab
//        let centerHitRect = centerThumb.frame.insetBy(dx: -touchExpansion, dy: -touchExpansion)
//        if centerHitRect.contains(p) {
//            isTrackingCenterThumb = true
//            return true
//        }
//        isTrackingCenterThumb = false
//        return false
//    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point = touch.location(in: self)

        if centerThumb.frame.contains(point) {
            isTrackingCenterThumb = true
            touchOffset = point.x - centerThumb.position.x   // ⭐ ADD THIS
            return true
        }

        return false
    }

    
//    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
//        guard isTrackingCenterThumb else { return false }
//        let p = touch.location(in: self)
//        
//        // Limits: center thumb cannot go past leftThumb or rightThumb
//        let leftLimitX = valueToX(initialValue)
//        let rightLimitX = valueToX(endValue)
//        
//        // clamp to [leftLimitX, rightLimitX]
//        let clampedX = max(leftLimitX, min(p.x, rightLimitX))
//        
//        // update currentValue
//        currentValue = xToValue(clampedX)
//        
//        // send event
//        sendActions(for: .valueChanged)
//        return true
//    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        guard isTrackingCenterThumb else { return false }

        let point = touch.location(in: self)

        // New X based on finger minus stored offset
        var newCenterX = point.x - touchOffset

        // Boundaries
        let leftLimit = valueToX(initialValue)
        let rightLimit = valueToX(endValue)

        newCenterX = max(leftLimit, min(newCenterX, rightLimit))

        // Move thumb instantly without animation
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        centerThumb.position.x = newCenterX
        CATransaction.commit()

        // Update current value instantly
        currentValue = xToValue(newCenterX)

        // ⭐ Move the "current" label at the same time, NO DELAY
        currentLabel.center.x = newCenterX
        currentLabel.text = formatKD(currentValue)//"\(Int(currentValue))"

        // Update selected track instantly
        let leftX = valueToX(initialValue)
        selectedTrack.frame.origin.x = min(leftX, newCenterX)
        selectedTrack.frame.size.width = abs(newCenterX - leftX)

        sendActions(for: .valueChanged)
        return true
    }

    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        isTrackingCenterThumb = false
    }
    
    override func cancelTracking(with event: UIEvent?) {
        isTrackingCenterThumb = false
    }
    
    // Optional: make the control respond to programmatic changes by animating thumbs (not required)
}

// MARK: - Hex Color Extension
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255
        let b = CGFloat(rgb & 0x0000FF) / 255
        
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}
