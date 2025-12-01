//
//  RangeSliderView.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//


//import UIKit
//
//class RangeSliderView: UIControl {
//    
//    // MARK: - Public Values
//    var minValue: CGFloat = 0 {
//        didSet { setNeedsLayout(); updateLabels() }
//    }
//    var maxValue: CGFloat = 10000 {
//        didSet { setNeedsLayout(); updateLabels() }
//    }
//    
//    var initialValue: CGFloat = 0 { didSet { setNeedsLayout(); updateLabels() } } // left thumb
//    var currentValue: CGFloat = 500 { didSet { setNeedsLayout(); updateLabels() } } // right thumb
//    
//    // MARK: - Layers
//    private let unselectedTrack = CALayer()
//    private let selectedTrack = CALayer() // between left and right
//    private let leftThumb = CALayer()
//    private let centerThumb = CALayer()
//    
//    // MARK: - Labels
//    private let minLabel = UILabel()
//    private let currentLabel = UILabel()
//    
//    // Thumb size
//    private let thumbSize: CGFloat = 24
//    
//    // Colors
//    private let mainColor = UIColor.brown
//    private let fadedColor = UIColor.brown.withAlphaComponent(0.2)
//    
//    // Touch tracking
//    private var isTrackingLeftThumb = false
//    private var isTrackingCenterThumb = false
//    private var touchOffset: CGFloat = 0
//    private let touchExpansion: CGFloat = 10
//    
//    // MARK: - Init
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        commonInit()
//    }
//    private func commonInit() {
//        setupLayers()
//        setupLabels()
//    }
//    
//    private func setupLayers() {
//        unselectedTrack.backgroundColor = fadedColor.cgColor
//        layer.addSublayer(unselectedTrack)
//        
//        selectedTrack.backgroundColor = mainColor.cgColor
//        layer.addSublayer(selectedTrack)
//        
//        leftThumb.backgroundColor = mainColor.cgColor
//        leftThumb.cornerRadius = thumbSize / 2
//        leftThumb.masksToBounds = true
//        layer.addSublayer(leftThumb)
//        
//        centerThumb.backgroundColor = mainColor.cgColor
//        centerThumb.cornerRadius = thumbSize / 2
//        centerThumb.masksToBounds = true
//        layer.addSublayer(centerThumb)
//    }
//    
//    private func setupLabels() {
//        [minLabel, currentLabel].forEach { lbl in
//            lbl.font = UIFont.systemFont(ofSize: 12, weight: .medium)
//            lbl.textColor = .black
//            lbl.textAlignment = .center
//            addSubview(lbl)
//        }
//        updateLabels()
//    }
//    
//    private func updateLabels() {
//        minLabel.text = "\(Int(initialValue)) KD"
//        currentLabel.text = "\(Int(currentValue)) KD"
//    }
//    
//    // MARK: - Layout
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        let trackHeight: CGFloat = 4
//        let trackY = (bounds.height - thumbSize - 20) / 2 + (thumbSize - trackHeight) / 2
//        
//        unselectedTrack.frame = CGRect(x: 0, y: trackY, width: bounds.width, height: trackHeight)
//        unselectedTrack.cornerRadius = trackHeight / 2
//        
//        let leftX = valueToX(initialValue)
//        let centerX = valueToX(currentValue)
//        
//        selectedTrack.frame = CGRect(x: leftX, y: trackY, width: max(1, centerX - leftX), height: trackHeight)
//        selectedTrack.cornerRadius = trackHeight / 2
//        
//        let thumbY = (bounds.height - thumbSize - 18) / 2
//        leftThumb.frame = CGRect(x: leftX - thumbSize/2, y: thumbY, width: thumbSize, height: thumbSize)
//        centerThumb.frame = CGRect(x: centerX - thumbSize/2, y: thumbY, width: thumbSize, height: thumbSize)
//        
//        let labelHeight: CGFloat = 16
//        let labelY = thumbY + thumbSize + 4
//        minLabel.frame = CGRect(x: leftX - 30, y: labelY, width: 60, height: labelHeight)
//        currentLabel.frame = CGRect(x: centerX - 30, y: labelY, width: 60, height: labelHeight)
//    }
//    
//    private func valueToX(_ value: CGFloat) -> CGFloat {
//        guard maxValue != minValue else { return 0 }
//        let pct = (value - minValue) / (maxValue - minValue)
//        return pct * bounds.width
//    }
//    
//    private func xToValue(_ x: CGFloat) -> CGFloat {
//        let pct = max(0, min(1, x / bounds.width))
//        return minValue + pct * (maxValue - minValue)
//    }
//    
//    // MARK: - Touch Handling
//    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
//        let point = touch.location(in: self)
//        
//        if leftThumb.frame.insetBy(dx: -touchExpansion, dy: -touchExpansion).contains(point) {
//            isTrackingLeftThumb = true
//            touchOffset = point.x - leftThumb.position.x
//            return true
//        }
//        
//        if centerThumb.frame.insetBy(dx: -touchExpansion, dy: -touchExpansion).contains(point) {
//            isTrackingCenterThumb = true
//            touchOffset = point.x - centerThumb.position.x
//            return true
//        }
//        
//        return false
//    }
//    
//    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
//        let point = touch.location(in: self)
//        
//        if isTrackingLeftThumb {
//            var newX = point.x - touchOffset
//            let rightLimit = valueToX(currentValue)
//            newX = max(0, min(newX, rightLimit))
//            
//            leftThumb.position.x = newX
//            initialValue = xToValue(newX)
//            
//            selectedTrack.frame.origin.x = newX
//            selectedTrack.frame.size.width = centerThumb.position.x - newX
//            
//            updateLabels()
//            sendActions(for: .valueChanged)
//            return true
//        }
//        
//        if isTrackingCenterThumb {
//            var newX = point.x - touchOffset
//            let leftLimit = valueToX(initialValue)
//            let rightLimit = bounds.width
//            newX = max(leftLimit, min(newX, rightLimit))
//            
//            centerThumb.position.x = newX
//            currentValue = xToValue(newX)
//            
//            selectedTrack.frame.origin.x = valueToX(initialValue)
//            selectedTrack.frame.size.width = newX - valueToX(initialValue)
//            
//            updateLabels()
//            sendActions(for: .valueChanged)
//            return true
//        }
//        
//        return false
//    }
//    
//    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
//        isTrackingLeftThumb = false
//        isTrackingCenterThumb = false
//    }
//    
//    override func cancelTracking(with event: UIEvent?) {
//        isTrackingLeftThumb = false
//        isTrackingCenterThumb = false
//    }
//}
//
//



import UIKit

class RangeSliderView: UIControl {

    // MARK: - Public Values
    var minValue: CGFloat = 0 {
        didSet { updateLayoutIfNeeded() }
    }
    var maxValue: CGFloat = 100000 {
        didSet { updateLayoutIfNeeded() }
    }

    var initialValue: CGFloat = 0 {
        didSet {
            initialValue = min(max(initialValue, minValue), currentValue)
            updateThumbPositions()
            updateLabelTexts()
        }
    }

    var currentValue: CGFloat = 5000 {
        didSet {
            currentValue = min(max(currentValue, initialValue), maxValue)
            updateThumbPositions()
            updateLabelTexts()
        }
    }

    // MARK: - Appearance
    private let thumbSize: CGFloat = 28
    private let trackHeight: CGFloat = 6
    private let labelOffsetY: CGFloat = 8

    private let mainColor = UIColor.brown
    private let trackColor = UIColor.brown.withAlphaComponent(0.25)

    // Layers
    private let trackLayer = CALayer()
    private let selectedTrackLayer = CALayer()
    private let leftThumbLayer = CALayer()
    private let rightThumbLayer = CALayer()

    private let minLabelLayer = CATextLayer()
    private let maxLabelLayer = CATextLayer()

    // MARK: - Touch Tracking
    private var trackingThumb: CALayer?
    private var touchOffset: CGFloat = 0
    private let touchExpansion: CGFloat = 20

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
        backgroundColor = .clear
        setupLayers()
        setupTextLayers()
    }

    // MARK: - Setup
    private func setupLayers() {
        trackLayer.backgroundColor = trackColor.cgColor
        trackLayer.cornerRadius = trackHeight / 2
        layer.addSublayer(trackLayer)

        selectedTrackLayer.backgroundColor = mainColor.cgColor
        selectedTrackLayer.cornerRadius = trackHeight / 2
        layer.addSublayer(selectedTrackLayer)

        [leftThumbLayer, rightThumbLayer].forEach { thumb in
            thumb.backgroundColor = mainColor.cgColor
            thumb.cornerRadius = thumbSize / 2
            layer.addSublayer(thumb)
        }
    }

    private func setupTextLayers() {
        let font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        [minLabelLayer, maxLabelLayer].forEach { layer in
            layer.font = CGFont(font.fontName as CFString)
            layer.fontSize = font.pointSize
            layer.foregroundColor = UIColor.darkGray.cgColor
            layer.alignmentMode = .center
            layer.contentsScale = UIScreen.main.scale
            self.layer.addSublayer(layer)
        }
        updateLabelTexts()
    }

    private func updateLabelTexts() {
        minLabelLayer.string = "\(Int(initialValue)) KD"
        maxLabelLayer.string = "\(Int(currentValue)) KD"
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayoutIfNeeded()
    }

    private func updateLayoutIfNeeded() {
        guard bounds.width > 0 else { return }

        let trackY = bounds.midY
        let thumbY = trackY

        trackLayer.frame = CGRect(x: 0, y: trackY - trackHeight/2, width: bounds.width, height: trackHeight)

        let leftX = valueToX(initialValue)
        let rightX = valueToX(currentValue)

        selectedTrackLayer.frame = CGRect(
            x: leftX,
            y: trackY - trackHeight/2,
            width: max(4, rightX - leftX),
            height: trackHeight
        )

        leftThumbLayer.position = CGPoint(x: leftX, y: thumbY)
        rightThumbLayer.position = CGPoint(x: rightX, y: thumbY)
        leftThumbLayer.bounds = CGRect(x: 0, y: -10, width: thumbSize, height: thumbSize)
        rightThumbLayer.bounds = CGRect(x: 0, y: -10, width: thumbSize, height: thumbSize)

        // Labels
        let labelY = thumbY + thumbSize/2 + labelOffsetY
        let labelWidth: CGFloat = 70
        let labelHeight: CGFloat = 24

        minLabelLayer.bounds = CGRect(x: 0, y: -10, width: labelWidth, height: labelHeight)
        maxLabelLayer.bounds = CGRect(x: 0, y: -10, width: labelWidth, height: labelHeight)

        minLabelLayer.position = CGPoint(x: leftX + 10, y: labelY)
        maxLabelLayer.position = CGPoint(x: clampedLabelX(rightX, labelWidth: labelWidth), y: labelY)
    }

    // MARK: - Thumb & Label Updates
    private func updateThumbPositions() {
        let leftX = valueToX(initialValue)
        let rightX = valueToX(currentValue)

        CATransaction.begin()
        CATransaction.setDisableActions(true)

        leftThumbLayer.position.x = leftX
        rightThumbLayer.position.x = rightX

        let trackY = bounds.midY
        selectedTrackLayer.frame = CGRect(
            x: leftX,
            y: trackY - trackHeight/2,
            width: max(4, rightX - leftX),
            height: trackHeight
        )

        let labelWidth = minLabelLayer.bounds.width
        minLabelLayer.position.x = leftX + 10//clampedLabelX(leftX, labelWidth: labelWidth)
        maxLabelLayer.position.x = clampedLabelX(rightX, labelWidth: labelWidth)

        updateLabelTexts()
        CATransaction.commit()
    }

    // MARK: - Value <-> X Conversion
    private func valueToX(_ value: CGFloat) -> CGFloat {
        let availableWidth = bounds.width - thumbSize
        let ratio = (value - minValue) / (maxValue - minValue)
        return thumbSize/2 + ratio * availableWidth
    }

    private func xToValue(_ x: CGFloat) -> CGFloat {
        let availableWidth = bounds.width - thumbSize
        let clampedX = max(thumbSize/2, min(bounds.width - thumbSize/2, x))
        let ratio = (clampedX - thumbSize/2) / availableWidth
        return minValue + ratio * (maxValue - minValue)
    }

    private func clampedLabelX(_ x: CGFloat, labelWidth: CGFloat) -> CGFloat {
        let half = labelWidth / 2
        return max(half, min(bounds.width - half, x))
    }

    // MARK: - Touch Handling
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point = touch.location(in: self)

        let leftRect = leftThumbLayer.frame.insetBy(dx: -touchExpansion, dy: -touchExpansion)
        let rightRect = rightThumbLayer.frame.insetBy(dx: -touchExpansion, dy: -touchExpansion)

        if leftRect.contains(point) {
            trackingThumb = leftThumbLayer
            touchOffset = point.x - leftThumbLayer.position.x
        } else if rightRect.contains(point) {
            trackingThumb = rightThumbLayer
            touchOffset = point.x - rightThumbLayer.position.x
        } else {
            return false
        }

        return true
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        guard let trackingThumb = trackingThumb else { return false }

        let point = touch.location(in: self)
        var newX = point.x - touchOffset
        newX = max(thumbSize/2, min(bounds.width - thumbSize/2, newX))

        let newValue = xToValue(newX)

        CATransaction.begin()
        CATransaction.setDisableActions(true)

        if trackingThumb === leftThumbLayer {
            initialValue = min(newValue, currentValue)
        } else {
            currentValue = max(newValue, initialValue)
        }

        updateThumbPositions()
        CATransaction.commit()

        sendActions(for: .valueChanged)
        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        trackingThumb = nil
    }

    override func cancelTracking(with event: UIEvent?) {
        trackingThumb = nil
    }
}
