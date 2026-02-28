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
    
    var currentValue: CGFloat = 100000 {
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
    private var lastTouchX: CGFloat = 0
    
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
        
        trackLayer.frame = CGRect(
            x: 0,
            y: trackY - trackHeight/2,
            width: bounds.width,
            height: trackHeight
        )
        
        let leftX = valueToX(initialValue)
        let rightX = valueToX(currentValue)
        
        selectedTrackLayer.frame = CGRect(
            x: leftX,
            y: trackY - trackHeight/2,
            width: max(4, rightX - leftX),
            height: trackHeight
        )
        
        leftThumbLayer.bounds = CGRect(x: 0, y: 0, width: thumbSize, height: thumbSize)
        rightThumbLayer.bounds = CGRect(x: 0, y: 0, width: thumbSize, height: thumbSize)
        
        leftThumbLayer.position = CGPoint(x: leftX, y: thumbY)
        rightThumbLayer.position = CGPoint(x: rightX, y: thumbY)
        
        // MARK: Labels
        
        let labelWidth: CGFloat = 70
        let labelHeight: CGFloat = 24
        
        minLabelLayer.bounds = CGRect(x: 0, y: 0, width: labelWidth, height: labelHeight)
        maxLabelLayer.bounds = CGRect(x: 0, y: 0, width: labelWidth, height: labelHeight)
        
        let bottomLabelY = thumbY + thumbSize/2 + labelOffsetY + labelHeight/2
        let topLabelY = max(labelHeight/2, thumbY - thumbSize/2 - labelOffsetY - labelHeight/2)
        
        // Clamp positions to stay inside view bounds
        minLabelLayer.position = CGPoint(
            x: clampedLabelX(leftX, labelWidth: labelWidth),
            y: bottomLabelY
        )
        
        maxLabelLayer.position = CGPoint(
            x: clampedLabelX(rightX, labelWidth: labelWidth),
            y: topLabelY
        )
    }
    
    // MARK: - Thumb & Label Updates
    private func updateThumbPositions() {
        let leftX = valueToX(initialValue)
        let rightX = valueToX(currentValue)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        // Move thumbs
        leftThumbLayer.position.x = leftX
        rightThumbLayer.position.x = rightX
        
        let trackY = bounds.midY
        
        // Update selected track
        selectedTrackLayer.frame = CGRect(
            x: leftX,
            y: trackY - trackHeight/2,
            width: max(4, rightX - leftX),
            height: trackHeight
        )
        
        let labelWidth = minLabelLayer.bounds.width
        let labelHeight = minLabelLayer.bounds.height
        
        // Y positions for labels
        let bottomLabelY = trackY + thumbSize/2 + labelOffsetY + labelHeight/2
        let topLabelY = max(labelHeight/2, trackY - thumbSize/2 - labelOffsetY - labelHeight/2)
        
        // Min label (bottom of left thumb), clamped to stay inside bounds
        minLabelLayer.position = CGPoint(
            x: clampedLabelX(leftX, labelWidth: labelWidth),
            y: bottomLabelY
        )
        
        // Max label (top of right thumb), clamped to stay inside bounds
        maxLabelLayer.position = CGPoint(
            x: clampedLabelX(rightX, labelWidth: labelWidth),
            y: topLabelY
        )
        
        // Update label texts
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
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point = touch.location(in: self)
        lastTouchX = point.x
        
        let leftRect = leftThumbLayer.frame.insetBy(dx: -touchExpansion, dy: -touchExpansion)
        let rightRect = rightThumbLayer.frame.insetBy(dx: -touchExpansion, dy: -touchExpansion)
        
        let leftContains = leftRect.contains(point)
        let rightContains = rightRect.contains(point)
        
        if leftContains && rightContains {
            trackingThumb = nil
        } else if leftContains {
            trackingThumb = leftThumbLayer
        } else if rightContains {
            trackingThumb = rightThumbLayer
        } else {
            return false
        }
        
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point = touch.location(in: self)
        let delta = point.x - lastTouchX
        lastTouchX = point.x
        
        // If thumbs overlap and we haven't decided yet
        if trackingThumb == nil {
            if delta > 0 {
                trackingThumb = rightThumbLayer
            } else {
                trackingThumb = leftThumbLayer
            }
        }
        
        guard let trackingThumb = trackingThumb else { return false }
        
        var newX = point.x
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
