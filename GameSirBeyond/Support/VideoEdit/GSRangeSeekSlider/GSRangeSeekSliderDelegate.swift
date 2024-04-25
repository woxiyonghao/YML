//
//  RangeSeekSliderDelegate.swift
//  RangeSeekSlider
//
//  Created by Keisuke Shoji on 2017/03/09.
//
//

import CoreGraphics

public protocol GSRangeSeekSliderDelegate: class {
    func rangeSeekSlider(_ slider: GSRangeSeekSlider, didChange minValueFrameX: CGFloat, maxValueFrameX: CGFloat)
    
    /// Called when the RangeSeekSlider values are changed
    ///
    /// - Parameters:
    ///   - slider: RangeSeekSlider
    ///   - minValue: minimum value
    ///   - maxValue: maximum value
    func rangeSeekSlider(_ slider: GSRangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat)

    /// Called when the user has started interacting with the RangeSeekSlider
    ///
    /// - Parameter slider: RangeSeekSlider
    func didStartTouches(in slider: GSRangeSeekSlider)

    /// Called when the user has finished interacting with the RangeSeekSlider
    ///
    /// - Parameter slider: RangeSeekSlider
    func didEndTouches(in slider: GSRangeSeekSlider)

    /// Called when the RangeSeekSlider values are changed. A return `String?` Value is displayed on the `minLabel`.
    ///
    /// - Parameters:
    ///   - slider: RangeSeekSlider
    ///   - minValue: minimum value
    /// - Returns: String to be replaced
    func rangeSeekSlider(_ slider: GSRangeSeekSlider, stringForMinValue minValue: CGFloat) -> String?

    /// Called when the RangeSeekSlider values are changed. A return `String?` Value is displayed on the `maxLabel`.
    ///
    /// - Parameters:
    ///   - slider: RangeSeekSlider
    ///   - maxValue: maximum value
    /// - Returns: String to be replaced
    func rangeSeekSlider(_ slider: GSRangeSeekSlider, stringForMaxValue: CGFloat) -> String?
}


// MARK: - Default implementation

public extension GSRangeSeekSliderDelegate {
    func rangeSeekSlider(_ slider: GSRangeSeekSlider, didChange minValueFrameX: CGFloat, maxValueFrameX: CGFloat) {}
    func rangeSeekSlider(_ slider: GSRangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {}
    func didStartTouches(in slider: GSRangeSeekSlider) {}
    func didEndTouches(in slider: GSRangeSeekSlider) {}
    func rangeSeekSlider(_ slider: GSRangeSeekSlider, stringForMinValue minValue: CGFloat) -> String? { return nil }
    func rangeSeekSlider(_ slider: GSRangeSeekSlider, stringForMaxValue maxValue: CGFloat) -> String? { return nil }
}
