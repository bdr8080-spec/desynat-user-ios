//
//  RangeSliderView.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//


import UIKit

class RangeSliderView: UIControl {
    
    // MARK: - Public Values
    var minValue: CGFloat = 0
    var maxValue: CGFloat = 100
    
    var initialValue: CGFloat = 0 { didSet { setNeedsLayout() } }
    var currentValue: CGFloat = 50 { didSet { setNeedsLayout() } }
    var endValue: CGFloat = 100 { didSet { setNeedsLayout() } }
    
    // MARK: - Layers
    private let trackLayer = CALayer()
    private let leftThumb = CALayer()
    private let rightThumb = CALayer()
    private let centerThumb = CALayer()
    
    // Thumb size
    private let thumbSize: CGFloat = 24
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        // Track
        trackLayer.backgroundColor = UIColor.lightGray.cgColor
        layer.addSublayer(trackLayer)
        
        // Left fixed thumb
        leftThumb.backgroundColor = UIColor.darkGray.cgColor
        leftThumb.cornerRadius = thumbSize / 2
        layer.addSublayer(leftThumb)
        
        // Movable center thumb
        centerThumb.backgroundColor = UIColor.red.cgColor
        centerThumb.cornerRadius = thumbSize / 2
        layer.addSublayer(centerThumb)
        
        // Right fixed thumb
        rightThumb.backgroundColor = UIColor.darkGray.cgColor
        rightThumb.cornerRadius = thumbSize / 2
        layer.addSublayer(rightThumb)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let trackHeight: CGFloat = 4
        let trackY = (bounds.height - trackHeight) / 2
        
        // Track full width
        trackLayer.frame = CGRect(x: 0, y: trackY, width: bounds.width, height: trackHeight)
        
        // Positions
        let leftX = valueToX(initialValue)
        let centerX = valueToX(currentValue)
        let rightX = valueToX(endValue)
        
        leftThumb.frame = CGRect(x: leftX - thumbSize/2, y: centerY(), width: thumbSize, height: thumbSize)
        centerThumb.frame = CGRect(x: centerX - thumbSize/2, y: centerY(), width: thumbSize, height: thumbSize)
        rightThumb.frame = CGRect(x: rightX - thumbSize/2, y: centerY(), width: thumbSize, height: thumbSize)
    }
    
    private func centerY() -> CGFloat {
        return (bounds.height - thumbSize) / 2
    }
    
    // Convert slider value to x-position
    private func valueToX(_ value: CGFloat) -> CGFloat {
        let percentage = (value - minValue) / (maxValue - minValue)
        return percentage * bounds.width
    }
    
    // Convert x-position to slider value
    private func xToValue(_ x: CGFloat) -> CGFloat {
        let percentage = x / bounds.width
        return minValue + percentage * (maxValue - minValue)
    }
    
    // MARK: - Touch handling (only center thumb)
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point = touch.location(in: self)
        return centerThumb.frame.contains(point)
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let x = touch.location(in: self).x
        
        let leftLimit = valueToX(initialValue)
        let rightLimit = valueToX(endValue)
        
        let clampedX = max(leftLimit, min(x, rightLimit))
        currentValue = xToValue(clampedX)
        
        sendActions(for: .valueChanged)
        return true
    }
}
