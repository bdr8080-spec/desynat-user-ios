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
    var maxValue: CGFloat = 10000 {
        didSet { setNeedsLayout(); updateLabels() }
    }
    
    var initialValue: CGFloat = 0 { didSet { setNeedsLayout(); updateLabels() } } // left thumb
    var currentValue: CGFloat = 500 { didSet { setNeedsLayout(); updateLabels() } } // right thumb
    
    // MARK: - Layers
    private let unselectedTrack = CALayer()
    private let selectedTrack = CALayer() // between left and right
    private let leftThumb = CALayer()
    private let centerThumb = CALayer()
    
    // MARK: - Labels
    private let minLabel = UILabel()
    private let currentLabel = UILabel()
    
    // Thumb size
    private let thumbSize: CGFloat = 24
    
    // Colors
    private let mainColor = UIColor.brown
    private let fadedColor = UIColor.brown.withAlphaComponent(0.2)
    
    // Touch tracking
    private var isTrackingLeftThumb = false
    private var isTrackingCenterThumb = false
    private var touchOffset: CGFloat = 0
    private let touchExpansion: CGFloat = 10
    
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
    
    private func setupLayers() {
        unselectedTrack.backgroundColor = fadedColor.cgColor
        layer.addSublayer(unselectedTrack)
        
        selectedTrack.backgroundColor = mainColor.cgColor
        layer.addSublayer(selectedTrack)
        
        leftThumb.backgroundColor = mainColor.cgColor
        leftThumb.cornerRadius = thumbSize / 2
        leftThumb.masksToBounds = true
        layer.addSublayer(leftThumb)
        
        centerThumb.backgroundColor = mainColor.cgColor
        centerThumb.cornerRadius = thumbSize / 2
        centerThumb.masksToBounds = true
        layer.addSublayer(centerThumb)
    }
    
    private func setupLabels() {
        [minLabel, currentLabel].forEach { lbl in
            lbl.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            lbl.textColor = .black
            lbl.textAlignment = .center
            addSubview(lbl)
        }
        updateLabels()
    }
    
    private func updateLabels() {
        minLabel.text = "KD \(Int(initialValue))"
        currentLabel.text = "KD \(Int(currentValue))"
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let trackHeight: CGFloat = 4
        let trackY = (bounds.height - thumbSize - 20) / 2 + (thumbSize - trackHeight) / 2
        
        unselectedTrack.frame = CGRect(x: 0, y: trackY, width: bounds.width, height: trackHeight)
        unselectedTrack.cornerRadius = trackHeight / 2
        
        let leftX = valueToX(initialValue)
        let centerX = valueToX(currentValue)
        
        selectedTrack.frame = CGRect(x: leftX, y: trackY, width: max(1, centerX - leftX), height: trackHeight)
        selectedTrack.cornerRadius = trackHeight / 2
        
        let thumbY = (bounds.height - thumbSize - 18) / 2
        leftThumb.frame = CGRect(x: leftX - thumbSize/2, y: thumbY, width: thumbSize, height: thumbSize)
        centerThumb.frame = CGRect(x: centerX - thumbSize/2, y: thumbY, width: thumbSize, height: thumbSize)
        
        let labelHeight: CGFloat = 16
        let labelY = thumbY + thumbSize + 4
        minLabel.frame = CGRect(x: leftX - 30, y: labelY, width: 60, height: labelHeight)
        currentLabel.frame = CGRect(x: centerX - 30, y: labelY, width: 60, height: labelHeight)
    }
    
    private func valueToX(_ value: CGFloat) -> CGFloat {
        guard maxValue != minValue else { return 0 }
        let pct = (value - minValue) / (maxValue - minValue)
        return pct * bounds.width
    }
    
    private func xToValue(_ x: CGFloat) -> CGFloat {
        let pct = max(0, min(1, x / bounds.width))
        return minValue + pct * (maxValue - minValue)
    }
    
    // MARK: - Touch Handling
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point = touch.location(in: self)
        
        if leftThumb.frame.insetBy(dx: -touchExpansion, dy: -touchExpansion).contains(point) {
            isTrackingLeftThumb = true
            touchOffset = point.x - leftThumb.position.x
            return true
        }
        
        if centerThumb.frame.insetBy(dx: -touchExpansion, dy: -touchExpansion).contains(point) {
            isTrackingCenterThumb = true
            touchOffset = point.x - centerThumb.position.x
            return true
        }
        
        return false
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point = touch.location(in: self)
        
        if isTrackingLeftThumb {
            var newX = point.x - touchOffset
            let rightLimit = valueToX(currentValue)
            newX = max(0, min(newX, rightLimit))
            
            leftThumb.position.x = newX
            initialValue = xToValue(newX)
            
            selectedTrack.frame.origin.x = newX
            selectedTrack.frame.size.width = centerThumb.position.x - newX
            
            updateLabels()
            sendActions(for: .valueChanged)
            return true
        }
        
        if isTrackingCenterThumb {
            var newX = point.x - touchOffset
            let leftLimit = valueToX(initialValue)
            let rightLimit = bounds.width
            newX = max(leftLimit, min(newX, rightLimit))
            
            centerThumb.position.x = newX
            currentValue = xToValue(newX)
            
            selectedTrack.frame.origin.x = valueToX(initialValue)
            selectedTrack.frame.size.width = newX - valueToX(initialValue)
            
            updateLabels()
            sendActions(for: .valueChanged)
            return true
        }
        
        return false
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        isTrackingLeftThumb = false
        isTrackingCenterThumb = false
    }
    
    override func cancelTracking(with event: UIEvent?) {
        isTrackingLeftThumb = false
        isTrackingCenterThumb = false
    }
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
