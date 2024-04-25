//
//  RangeSeekSlider.swift
//  RangeSeekSlider
//
//  Created by Keisuke Shoji on 2017/03/09.
//
//

import UIKit

@IBDesignable open class RangeSeekSlider: UIControl {
    
    // MARK: 滑动条高度
    @IBInspectable open var lineHeight: CGFloat = 2.0 {
        didSet {
            updateLineHeight()
        }
    }
    
    /// 需显示左侧指定标题
    @IBInspectable open var shouldShowLeftSpecifyTitle: Bool = false {
        didSet {
            refresh()
        }
    }
    
    /// 需显示右侧指定标题
    @IBInspectable open var shouldShowRightSpecifyTitle: Bool = false {
        didSet {
            refresh()
        }
    }
    
    /// 两侧边距
    @IBInspectable open var insetPadding: CGFloat = 4.5 {
        didSet {
            refresh()
        }
    }
    
    /// 总宽度
    @IBInspectable open var fullWidth: CGFloat = 226 {
        didSet {
            refresh()
        }
    }
    
    /// 指定的左侧值
    @IBInspectable open var leftSpecifyValue: Int = -1 {
        didSet {
            refresh()
        }
    }
    
    /// 指定的右侧值
    @IBInspectable open var rightSpecifyValue: Int = -1 {
        didSet {
            refresh()
        }
    }
    
    /// 指定的左侧文本
    @IBInspectable open var leftSpecifyTitle: String = "" {
        didSet {
            refresh()
        }
    }
    
    /// 指定的右侧文本
    @IBInspectable open var rightSpecifyTitle: String = "" {
        didSet {
            refresh()
        }
    }

    /// The minimum possible value to select in the range
    @IBInspectable open var minValue: CGFloat = 0.0 {
        didSet {
            refresh()
        }
    }

    /// The maximum possible value to select in the range
    @IBInspectable open var maxValue: CGFloat = 100.0 {
        didSet {
            refresh()
        }
    }

    /// 选中的左侧整数值
    open var selectedMinInt: Int {
        get {
            let value = Int(numberFormatter.string(from: selectedMinValue as NSNumber)!)!
            return value
        }
    }

    /// 选中的右侧整数值
    open var selectedMaxInt: Int {
        get {
            let value = Int(numberFormatter.string(from: selectedMaxValue as NSNumber)!)!
            return value
        }
    }
    
    /// The preselected minumum value
    /// (note: This should be less than the selectedMaxValue)
    @IBInspectable open var selectedMinValue: CGFloat = 0.0 {
        didSet {
            if selectedMinValue < minValue {
                selectedMinValue = minValue
            }
        }
    }

    /// The preselected maximum value
    /// (note: This should be greater than the selectedMinValue)
    @IBInspectable open var selectedMaxValue: CGFloat = 100.0 {
        didSet {
            if selectedMaxValue > maxValue {
                selectedMaxValue = maxValue
            }
        }
    }

    /// Handle slider with custom image, you can set custom image for your handle
    @IBInspectable open var handleImage: UIImage? {
        didSet {
            guard let image = handleImage else {
                return
            }
            
            var handleFrame = CGRect.zero
            handleFrame.size = image.size
            
            leftThumb.frame = handleFrame
            leftThumb.contents = image.cgImage

            rightThumb.frame = handleFrame
            rightThumb.contents = image.cgImage
        }
    }

    let thumbHeight = 80.0
    
    /// 圆球大小 //TODO: 解决触摸范围过小的问题
    @IBInspectable open var thumbWidth: CGFloat = 40.0 {
        didSet {
            leftThumb.frame = CGRect(x: 0.0, y: 0.0, width: thumbWidth, height: thumbHeight)
            rightThumb.frame = CGRect(x: 0.0, y: 0.0, width: thumbWidth, height: thumbHeight)
        }
    }

    /// Selected handle diameter multiplier (default 1.0)
    @IBInspectable open var selectedHandleDiameterMultiplier: CGFloat = 1.0

    /// Handle border width (default 0.0)
    @IBInspectable open var handleBorderWidth: CGFloat = 0.0 {
        didSet {
            leftThumb.borderWidth = handleBorderWidth
            rightThumb.borderWidth = handleBorderWidth
        }
    }

    /// Set padding between label and handle (default 8.0)
    @IBInspectable open var labelPadding: CGFloat = 8.0 {
        didSet {
            updateLabelPositions()
        }
    }


    // MARK: - private stored properties

    private enum HandleTracking { case none, left, right }
    private var handleTracking: HandleTracking = .none

    private let sliderLine: CALayer = CALayer()
    private let sliderLineBetweenHandles: CALayer = CALayer()

    private let leftThumb: CALayer = CALayer()
    private let rightThumb: CALayer = CALayer()

    let topMinView = UIView()// 左侧顶部图片
    let topMinLabel: UILabel = UILabel()// 左侧顶部文字
    let bottomMinLabel = UILabel()// 左侧底部文字
    
    let topMaxView = UIView()// 右侧顶部图片
    let topMaxLabel: UILabel = UILabel()// 右侧顶部文字
    let bottomMaxLabel = UILabel()// 右侧底部文字

    private var minLabelTextSize: CGSize = .zero
    private var maxLabelTextSize: CGSize = .zero

    // UIFeedbackGenerator
    private var previousStepMinValue: CGFloat?
    private var previousStepMaxValue: CGFloat?
    
    // MARK: - private methods
    
    let topMinViewWidth = 27.0
    let topMinViewHeight = 23.0
    let minLabelWidth = 27.0
    let minLabelHeight = 23.0
    
    let topMaxViewWidth = 27.0
    let topMaxViewHeight = 23.0
    let maxLabelWidth = 27.0
    let maxLabelHeight = 23.0
    
    // MARK: 初始化
    private func setup() {
        isAccessibilityElement = false
        accessibleElements = [leftHandleAccessibilityElement, rightHandleAccessibilityElement]

        layer.addSublayer(sliderLine)
        layer.addSublayer(sliderLineBetweenHandles)
//        leftHandle.cornerRadius = thumbWidth / 2.0
        leftThumb.borderWidth = handleBorderWidth
        layer.addSublayer(leftThumb)
//        rightHandle.cornerRadius = thumbWidth / 2.0
        rightThumb.borderWidth = handleBorderWidth
        layer.addSublayer(rightThumb)

        let handleFrame: CGRect = CGRect(x: 0.0, y: 0.0, width: thumbWidth, height: thumbHeight)
        leftThumb.frame = handleFrame
        rightThumb.frame = handleFrame

        // 数值显示范围
        let viewFrame: CGRect = CGRect(x: 0.0, y: 0.0, width: topMinViewWidth, height: topMinViewHeight)
        topMinView.frame = viewFrame
        addSubview(topMinView)
//        topMinView.backgroundColor = .red
        
//        let sliderValueImage = UIImage(named: "t4c_slider_value_bg")
//        let backgroundImageView = UIImageView(frame: topMinView.bounds)
//        backgroundImageView.image = sliderValueImage // 设置背景图片
//        backgroundImageView.contentMode = .scaleAspectFit
//        topMinView.addSubview(backgroundImageView)
        
        topMinLabel.textAlignment = .center
        topMinLabel.frame = CGRectMake(0, 0, minLabelWidth, minLabelHeight)
        topMinLabel.font = minLabelBoldFont
        topMinLabel.isUserInteractionEnabled = true
        topMinLabel.adjustsFontSizeToFitWidth = true
        topMinView.addSubview(topMinLabel)
        
        topMaxView.frame = viewFrame
        addSubview(topMaxView)
//        topMaxView.backgroundColor = .purple
        
//        let backgroundImageView2 = UIImageView(frame: topMinView.bounds)
//        backgroundImageView2.image = sliderValueImage // 设置背景图片
//        backgroundImageView2.contentMode = .scaleAspectFit
//        topMaxView.addSubview(backgroundImageView2)
        
        topMaxLabel.textAlignment = .center
        topMaxLabel.frame = CGRectMake(0, 0, maxLabelWidth, maxLabelHeight)
        topMaxLabel.font = minLabelBoldFont
        topMaxLabel.isUserInteractionEnabled = true
        topMaxLabel.adjustsFontSizeToFitWidth = true
        topMaxView.addSubview(topMaxLabel)
        
        let realSliderWidth = (fullWidth-insetPadding*2.0)// 滑动条实际宽度
        bottomMinLabel.frame = CGRect(x: insetPadding, y: 50, width: realSliderWidth/2, height: 16)
        bottomMinLabel.font = UIFont(name: "PingFangSC-Regular", size: 10)
        bottomMinLabel.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47,alpha:1)
        addSubview(bottomMinLabel)
        bottomMinLabel.isHidden = true
        
        bottomMaxLabel.frame = CGRect(x: CGRectGetMaxX(bottomMinLabel.frame), y: CGRectGetMinY(bottomMinLabel.frame), width: CGFloat(realSliderWidth/2), height: CGRectGetHeight(bottomMinLabel.frame))
        bottomMaxLabel.font = UIFont(name: "PingFangSC-Regular", size: 10)
        bottomMaxLabel.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47,alpha:1)
        bottomMaxLabel.textAlignment = .right
        addSubview(bottomMaxLabel)
        bottomMaxLabel.isHidden = true
        
        let thumbImage = UIImage(named: "key_setting_slider_thumb")
        let thumbSize = CGSize(width: 9, height: 20)
        let resizedThumbImage = thumbImage?.resizeTo(size: thumbSize)
        handleImage = resizedThumbImage
        
        setupStyle()

        refresh()
    }
    
    // MARK: - initializers

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    public required override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public convenience init(frame: CGRect = .zero, completion: ((RangeSeekSlider) -> Void)? = nil) {
        self.init(frame: frame)
        completion?(self)
    }


    // MARK: - open stored properties

    open weak var delegate: RangeSeekSliderDelegate?
    
    /// The font of the minimum value text label. If not set, the default is system font size 12.0.
    open var minLabelFont: UIFont = UIFont(name: "PingFangSC-Regular", size: 12)! {
        didSet {
            topMinLabel.font = minLabelFont
        }
    }

    /// The font of the maximum value text label. If not set, the default is system font size 12.0.
    open var maxLabelFont: UIFont = UIFont(name: "PingFangSC-Regular", size: 12)! {
        didSet {
            topMaxLabel.font = maxLabelFont
        }
    }
    
    open var minLabelBoldFont: UIFont = UIFont(name: "PingFangSC-Medium", size: 12)! {
        didSet {
            topMinLabel.font = minLabelFont
        }
    }

    open var maxLabelBoldFont: UIFont = UIFont(name: "PingFangSC-Medium", size: 12)! {
        didSet {
            topMaxLabel.font = maxLabelFont
        }
    }

    /// Each handle in the slider has a label above it showing the current selected value. By default, this is displayed as a decimal format.
    /// You can update this default here by updating properties of NumberFormatter. For example, you could supply a currency style, or a prefix or suffix.
    open var numberFormatter: NumberFormatter = {
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    /// Hides the labels above the slider controls. true = labels will be hidden. false = labels will be shown. Default is false.
    @IBInspectable open var hideLabels: Bool = false {
        didSet {
            topMinLabel.isHidden = hideLabels
            topMaxLabel.isHidden = hideLabels
        }
    }

    /// fixes the labels above the slider controls. true: labels will be fixed to both ends. false: labels will move with the handles. Default is false.
    @IBInspectable open var labelsFixed: Bool = false

    /// The minimum distance the two selected slider values must be apart. Default is 0.
    @IBInspectable open var minDistance: CGFloat = 1.0 {
        didSet {
            if minDistance < 1.0 {
                minDistance = 1.0
            }
        }
    }

    /// The maximum distance the two selected slider values must be apart. Default is CGFloat.greatestFiniteMagnitude.
    @IBInspectable open var maxDistance: CGFloat = .greatestFiniteMagnitude {
        didSet {
            if maxDistance < 0.0 {
                maxDistance = .greatestFiniteMagnitude
            }
        }
    }

    /// The color of the minimum value text label. If not set, the default is the tintColor.
    @IBInspectable open var minLabelColor: UIColor?

    /// The color of the maximum value text label. If not set, the default is the tintColor.
    @IBInspectable open var maxLabelColor: UIColor?

    /// Handle slider with custom color, you can set custom color for your handle
    @IBInspectable open var handleColor: UIColor?

    /// Handle slider with custom border color, you can set custom border color for your handle
    @IBInspectable open var handleBorderColor: UIColor?

    /// Set slider line tint color between handles
    @IBInspectable open var colorBetweenHandles: UIColor? = UIColor(red: 244/255.0, green: 54/255.0, blue: 76/255.0, alpha: 1)

    /// The color of the entire slider when the handle is set to the minimum value and the maximum value. Default is nil.
    @IBInspectable open var initialColor: UIColor?

    /// If true, the control will mimic a normal slider and have only one handle rather than a range.
    /// In this case, the selectedMinValue will be not functional anymore. Use selectedMaxValue instead to determine the value the user has selected.
    @IBInspectable open var disableRange: Bool = false {
        didSet {
            leftThumb.isHidden = disableRange
            topMinLabel.isHidden = disableRange
        }
    }

    /// If true the control will snap to point at each step between minValue and maxValue. Default is false.
    @IBInspectable open var enableStep: Bool = false

    /// The step value, this control the value of each step. If not set the default is 0.0.
    /// (note: this is ignored if <= 0.0)
    @IBInspectable open var step: CGFloat = 0.0


    /// The label displayed in accessibility mode for minimum value handler. If not set, the default is empty String.
    @IBInspectable open var minLabelAccessibilityLabel: String?

    /// The label displayed in accessibility mode for maximum value handler. If not set, the default is empty String.
    @IBInspectable open var maxLabelAccessibilityLabel: String?

    /// The brief description displayed in accessibility mode for minimum value handler. If not set, the default is empty String.
    @IBInspectable open var minLabelAccessibilityHint: String?

    /// The brief description displayed in accessibility mode for maximum value handler. If not set, the default is empty String.
    @IBInspectable open var maxLabelAccessibilityHint: String?

    // strong reference needed for UIAccessibilityContainer
    // see http://stackoverflow.com/questions/13462046/custom-uiview-not-showing-accessibility-on-voice-over
    private var accessibleElements: [UIAccessibilityElement] = []


    // MARK: - private computed properties

    private var leftHandleAccessibilityElement: UIAccessibilityElement {
        let element: RangeSeekSliderLeftElement = RangeSeekSliderLeftElement(accessibilityContainer: self)
        element.isAccessibilityElement = true
        element.accessibilityLabel = minLabelAccessibilityLabel
        element.accessibilityHint = minLabelAccessibilityHint
        element.accessibilityValue = topMinLabel.text
        element.accessibilityFrame = convert(leftThumb.frame, to: nil)
        element.accessibilityTraits = UIAccessibilityTraits.adjustable
        return element
    }

    private var rightHandleAccessibilityElement: UIAccessibilityElement {
        let element: RangeSeekSliderRightElement = RangeSeekSliderRightElement(accessibilityContainer: self)
        element.isAccessibilityElement = true
        element.accessibilityLabel = maxLabelAccessibilityLabel
        element.accessibilityHint = maxLabelAccessibilityHint
        element.accessibilityValue = topMaxLabel.text
        element.accessibilityFrame = convert(rightThumb.frame, to: nil)
        element.accessibilityTraits = UIAccessibilityTraits.adjustable
        return element
    }


    // MARK: - UIView

    open override func layoutSubviews() {
        super.layoutSubviews()

        if handleTracking == .none {
            updateLineHeight()
            updateLabelValues()
            updateColors()
            updateHandlePositions()
            updateLabelPositions()
        }
    }

    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 65.0)
    }


    // MARK: - UIControl

    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchLocation: CGPoint = touch.location(in: self)
        let insetExpansion: CGFloat = -30.0
        let isTouchingLeftHandle: Bool = leftThumb.frame.insetBy(dx: insetExpansion, dy: insetExpansion).contains(touchLocation)
        let isTouchingRightHandle: Bool = rightThumb.frame.insetBy(dx: insetExpansion, dy: insetExpansion).contains(touchLocation)

        guard isTouchingLeftHandle || isTouchingRightHandle else { return false }


        // the touch was inside one of the handles so we're definitely going to start movign one of them. But the handles might be quite close to each other, so now we need to find out which handle the touch was closest too, and activate that one.
        let distanceFromLeftHandle: CGFloat = touchLocation.distance(to: leftThumb.frame.center)
        let distanceFromRightHandle: CGFloat = touchLocation.distance(to: rightThumb.frame.center)

        if distanceFromLeftHandle < distanceFromRightHandle && !disableRange {
            handleTracking = .left
        } else if selectedMaxValue == maxValue && leftThumb.frame.midX == rightThumb.frame.midX {
            handleTracking = .left
        } else {
            handleTracking = .right
        }
        let handle: CALayer = (handleTracking == .left) ? leftThumb : rightThumb
        animate(handle: handle, selected: true)

        delegate?.didStartTouches(in: self)

        return true
    }

    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        guard handleTracking != .none else { return false }

        let location: CGPoint = touch.location(in: self)

        // find out the percentage along the line we are in x coordinate terms (subtracting half the frames width to account for moving the middle of the handle, not the left hand side)
        let percentage: CGFloat = (location.x - sliderLine.frame.minX - thumbWidth / 2.0) / (sliderLine.frame.maxX - sliderLine.frame.minX)

        // multiply that percentage by self.maxValue to get the new selected minimum value
        let selectedValue: CGFloat = percentage * (maxValue - minValue) + minValue

        switch handleTracking {
        case .left:
            selectedMinValue = min(selectedValue, selectedMaxValue)
        case .right:
            // don't let the dots cross over, (unless range is disabled, in which case just dont let the dot fall off the end of the screen)
            if disableRange && selectedValue >= minValue {
                selectedMaxValue = selectedValue
            } else {
                selectedMaxValue = max(selectedValue, selectedMinValue)
            }
        case .none:
            // no need to refresh the view because it is done as a side-effect of setting the property
            break
        }

        refresh()

        return true
    }

    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        let handle: CALayer = (handleTracking == .left) ? leftThumb : rightThumb
        animate(handle: handle, selected: false)
        handleTracking = .none

        delegate?.didEndTouches(in: self)
    }


    // MARK: - UIAccessibility

    open override func accessibilityElementCount() -> Int {
        return accessibleElements.count
    }

    open override func accessibilityElement(at index: Int) -> Any? {
        return accessibleElements[index]
    }

    open override func index(ofAccessibilityElement element: Any) -> Int {
        guard let element = element as? UIAccessibilityElement else { return 0 }
        return accessibleElements.firstIndex(of: element) ?? 0
    }


    // MARK: - open methods

    /// When subclassing **RangeSeekSlider** and setting each item in **setupStyle()**, the design is reflected in Interface Builder as well.
    open func setupStyle() {}


    
    private func percentageAlongLine(for value: CGFloat) -> CGFloat {
        // stops divide by zero errors where maxMinDif would be zero. If the min and max are the same the percentage has no point.
        guard minValue < maxValue else { return 0.0 }

        // get the difference between the maximum and minimum values (e.g if max was 100, and min was 50, difference is 50)
        let maxMinDif: CGFloat = maxValue - minValue

        // now subtract value from the minValue (e.g if value is 75, then 75-50 = 25)
        let valueSubtracted: CGFloat = value - minValue

        // now divide valueSubtracted by maxMinDif to get the percentage (e.g 25/50 = 0.5)
        return valueSubtracted / maxMinDif
    }

    private func xPositionAlongLine(for value: CGFloat) -> CGFloat {
        // first get the percentage along the line for the value
        let percentage: CGFloat = percentageAlongLine(for: value)

        // get the difference between the maximum and minimum coordinate position x values (e.g if max was x = 310, and min was x=10, difference is 300)
        let maxMinDif: CGFloat = sliderLine.frame.maxX - sliderLine.frame.minX

        // now multiply the percentage by the minMaxDif to see how far along the line the point should be, and add it onto the minimum x position.
        let offset: CGFloat = percentage * maxMinDif

        return sliderLine.frame.minX + offset
    }
    
    private func updateLineHeight() {
        let yMiddle: CGFloat = frame.height / 2.0
        let lineLeftSide: CGPoint = CGPoint(x: CGFloat(insetPadding), y: yMiddle)
        let lineRightSide: CGPoint = CGPoint(x: frame.width - CGFloat(insetPadding),
                                             y: yMiddle)
        sliderLine.frame = CGRect(x: lineLeftSide.x,
                                  y: lineLeftSide.y,
                                  width: lineRightSide.x - lineLeftSide.x,
                                  height: lineHeight)
//        sliderLine.cornerRadius = lineHeight / 2.0
        sliderLineBetweenHandles.cornerRadius = sliderLine.cornerRadius
    }

    // MARK: 更新选择的最大最小值
    private func updateLabelValues() {
        topMinView.isHidden = hideLabels || disableRange
        topMaxLabel.isHidden = hideLabels
        
        if let replacedString = delegate?.rangeSeekSlider(self, stringForMinValue: selectedMinValue) {
            topMinLabel.text = replacedString
        } else {
            let string = numberFormatter.string(from: selectedMinValue as NSNumber)!
            topMinLabel.text = string
            
            if leftSpecifyTitle.lengthOfBytes(using: .utf8) > 0 &&
                Int(string) == leftSpecifyValue {
                bottomMinLabel.textColor = UIColor(red: 0.96, green: 0.21, blue: 0.3, alpha: 1)
                bottomMinLabel.font = minLabelBoldFont
                
                if shouldShowLeftSpecifyTitle {
                    topMinLabel.text = leftSpecifyTitle
                }
            }
            else {
                bottomMinLabel.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47,alpha:1)
                bottomMinLabel.font = minLabelFont
            }
        }

        if let replacedString = delegate?.rangeSeekSlider(self, stringForMaxValue: selectedMaxValue) {
            topMaxLabel.text = replacedString
        } else {
            let string = numberFormatter.string(from: selectedMaxValue as NSNumber)!
            topMaxLabel.text = string
            
            if rightSpecifyTitle.lengthOfBytes(using: .utf8) > 0 &&
                Int(string) == rightSpecifyValue {
                bottomMaxLabel.textColor = UIColor(red: 0.96, green: 0.21, blue: 0.3, alpha: 1)
                bottomMaxLabel.font = maxLabelBoldFont
                
                if shouldShowRightSpecifyTitle {
                    topMaxLabel.text = rightSpecifyTitle
                }
            }
            else {
                bottomMaxLabel.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47,alpha:1)
                bottomMaxLabel.font = maxLabelFont
            }
        }

        minLabelTextSize = CGSizeMake(minLabelWidth, minLabelHeight)
        maxLabelTextSize = CGSizeMake(maxLabelWidth, maxLabelHeight)
    }

    private func updateColors() {
        let isInitial: Bool = selectedMinValue == minValue && selectedMaxValue == maxValue
        if let initialColor = initialColor?.cgColor, isInitial {
            topMinLabel.textColor = .white
            topMaxLabel.textColor = .white
            sliderLineBetweenHandles.backgroundColor = initialColor
            sliderLine.backgroundColor = initialColor

            let color: CGColor = (handleImage == nil) ? initialColor : UIColor.clear.cgColor
            leftThumb.backgroundColor = color
            leftThumb.borderColor = color
            rightThumb.backgroundColor = color
            rightThumb.borderColor = color
        } else {
            let tintCGColor: CGColor = tintColor.cgColor
            topMinLabel.textColor = .white
            topMaxLabel.textColor = .white
            sliderLineBetweenHandles.backgroundColor = colorBetweenHandles?.cgColor ?? tintCGColor
            sliderLine.backgroundColor = tintCGColor

            let color: CGColor
            if let _ = handleImage {
                color = UIColor.clear.cgColor
            } else {
                color = handleColor?.cgColor ?? tintCGColor
            }
            leftThumb.backgroundColor = color
            leftThumb.borderColor = handleBorderColor.map { $0.cgColor }
            rightThumb.backgroundColor = color
            rightThumb.borderColor = handleBorderColor.map { $0.cgColor }
        }
    }

    private func updateAccessibilityElements() {
        accessibleElements = [leftHandleAccessibilityElement, rightHandleAccessibilityElement]
    }

    private func updateHandlePositions() {
        leftThumb.position = CGPoint(x: xPositionAlongLine(for: selectedMinValue),
                                      y: sliderLine.frame.midY)

        rightThumb.position = CGPoint(x: xPositionAlongLine(for: selectedMaxValue),
                                       y: sliderLine.frame.midY)

        // positioning for the dist slider line
        sliderLineBetweenHandles.frame = CGRect(x: leftThumb.position.x,
                                                y: sliderLine.frame.minY,
                                                width: rightThumb.position.x - leftThumb.position.x,
                                                height: lineHeight)
    }
    
    private func updateLabelPositions() {
        // the center points for the labels are X = the same x position as the relevant handle. Y = the y position of the handle minus half the height of the text label, minus some padding.

//        topMinView.frame.size = minLabelTextSize
//        topMaxView.frame.size = maxLabelTextSize

        if labelsFixed {
            updateFixedLabelPositions()
            return
        }

        let minSpacingBetweenLabels: CGFloat = 2.0

        // 控制topMinView、topMaxView的位置，Y值在这设置
        let newMinViewCenter: CGPoint = CGPoint(x: leftThumb.frame.midX,
                                                 y: leftThumb.frame.maxY - (minLabelTextSize.height) - labelPadding - 5)

        let newMaxViewCenter: CGPoint = CGPoint(x: rightThumb.frame.midX,
                                                 y: rightThumb.frame.maxY - (maxLabelTextSize.height) - labelPadding - 5)
        
        let newLeftMostXInMaxLabel: CGFloat = newMaxViewCenter.x - maxLabelTextSize.width / 2.0
        let newRightMostXInMinLabel: CGFloat = newMinViewCenter.x + minLabelTextSize.width / 2.0
        let newSpacingBetweenTextLabels: CGFloat = newLeftMostXInMaxLabel - newRightMostXInMinLabel

        if disableRange || newSpacingBetweenTextLabels > minSpacingBetweenLabels {
            topMinView.center = newMinViewCenter
            topMaxView.center = newMaxViewCenter

            // 最左边位置
            if topMinView.frame.minX < -topMinViewWidth/2.0 {
                topMinView.frame.origin.x = -topMinViewWidth/2.0
            }

            if topMaxView.frame.maxX > frame.width+topMaxViewWidth/2.0 {
                topMaxView.frame.origin.x = frame.width - topMaxViewWidth/2.0
            }
        } else {
            let increaseAmount: CGFloat = minSpacingBetweenLabels - newSpacingBetweenTextLabels
            topMinView.center = CGPoint(x: newMinViewCenter.x - increaseAmount / 2.0, y: newMinViewCenter.y)
            topMaxView.center = CGPoint(x: newMaxViewCenter.x + increaseAmount / 2.0, y: newMaxViewCenter.y)

            // Update x if they are still in the original position
            if topMinView.center.x == topMaxView.center.x {
                topMinView.center.x = leftThumb.frame.midX
                topMaxView.center.x = leftThumb.frame.midX + topMaxView.frame.width / 2.0 + minSpacingBetweenLabels + topMaxLabel.frame.width / 2.0
            }

            if topMinView.frame.minX < -topMinViewWidth/2.0 {
                topMinView.frame.origin.x = -topMinViewWidth/2.0
                topMaxView.frame.origin.x = topMinView.frame.maxX + minSpacingBetweenLabels
            }

            if topMaxView.frame.maxX > frame.width {
                topMaxView.frame.origin.x = frame.width - topMaxViewWidth/2.0
                topMinView.frame.origin.x = topMaxView.frame.origin.x - minSpacingBetweenLabels - topMinView.frame.width
            }
        }
    }

    private func updateFixedLabelPositions() {
        topMinView.center = CGPoint(x: xPositionAlongLine(for: minValue),
                                    y: sliderLine.frame.minY - (minLabelTextSize.height / 2.0) - (thumbWidth / 2.0) - labelPadding)
        topMaxView.center = CGPoint(x: xPositionAlongLine(for: maxValue),
                                    y: sliderLine.frame.minY - (maxLabelTextSize.height / 2.0) - (thumbWidth / 2.0) - labelPadding)
        if topMinView.frame.minX < -topMinViewWidth/2.0 {
            topMinView.frame.origin.x = -topMinViewWidth/2.0
        }

        if topMaxView.frame.maxX > frame.width+topMaxViewWidth/2.0 {
            topMaxView.frame.origin.x = frame.width - topMaxViewWidth/2.0
        }
    }

    fileprivate func refresh() {
        if enableStep && step > 0.0 {
            selectedMinValue = CGFloat(roundf(Float(selectedMinValue / step))) * step
            if let previousStepMinValue = previousStepMinValue, previousStepMinValue != selectedMinValue {
                TapticEngine.selection.feedback()
            }
            previousStepMinValue = selectedMinValue

            selectedMaxValue = CGFloat(roundf(Float(selectedMaxValue / step))) * step
            if let previousStepMaxValue = previousStepMaxValue, previousStepMaxValue != selectedMaxValue {
                TapticEngine.selection.feedback()
            }
            previousStepMaxValue = selectedMaxValue
        }

        let diff: CGFloat = selectedMaxValue - selectedMinValue

        if diff < minDistance {
            switch handleTracking {
            case .left:
                selectedMinValue = selectedMaxValue - minDistance
            case .right:
                selectedMaxValue = selectedMinValue + minDistance
            case .none:
                break
            }
        } else if diff > maxDistance {
            switch handleTracking {
            case .left:
                selectedMinValue = selectedMaxValue - maxDistance
            case .right:
                selectedMaxValue = selectedMinValue + maxDistance
            case .none:
                break
            }
        }

        // ensure the minimum and maximum selected values are within range. Access the values directly so we don't cause this refresh method to be called again (otherwise changing the properties causes a refresh)
        if selectedMinValue < minValue {
            selectedMinValue = minValue
        }
        if selectedMaxValue > maxValue {
            selectedMaxValue = maxValue
        }
        
//        minValueLabel.text = String(format: "%.0f", minValue)
//        maxValueLabel.text = String(format: "%.0f", maxValue)
        if leftSpecifyTitle.lengthOfBytes(using: .utf8) > 0 {
            bottomMinLabel.text = leftSpecifyTitle
        }
        else {
            bottomMinLabel.text = String(format: "%.0f", minValue)
        }
        
        if rightSpecifyTitle.lengthOfBytes(using: .utf8) > 0 {
            bottomMaxLabel.text = rightSpecifyTitle
        }
        else {
            bottomMaxLabel.text = String(format: "%.0f", maxValue)
        }

        // update the frames in a transaction so that the tracking doesn't continue until the frame has moved.
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        updateHandlePositions()
        updateLabelPositions()
        CATransaction.commit()

        updateLabelValues()
        updateColors()
        updateAccessibilityElements()

        // update the delegate
        // TODO: 最小值和最大值分开通知。
        if let delegate = delegate, handleTracking != .none {
            delegate.rangeSeekSlider(self, didChange: selectedMinValue, maxValue: selectedMaxValue)
        }
    }

    private func animate(handle: CALayer, selected: Bool) {
        let transform: CATransform3D
        if selected {
            transform = CATransform3DMakeScale(selectedHandleDiameterMultiplier, selectedHandleDiameterMultiplier, 1.0)
        } else {
            transform = CATransform3DIdentity
        }

        CATransaction.begin()
        CATransaction.setAnimationDuration(0.3)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
        handle.transform = transform

        // the label above the handle will need to move too if the handle changes size
        updateLabelPositions()

        CATransaction.commit()
    }
}


// MARK: - RangeSeekSliderLeftElement

private final class RangeSeekSliderLeftElement: UIAccessibilityElement {

    override func accessibilityIncrement() {
        guard let slider = accessibilityContainer as? RangeSeekSlider else { return }
        slider.selectedMinValue += slider.step
        accessibilityValue = slider.topMinLabel.text
    }

    override func accessibilityDecrement() {
        guard let slider = accessibilityContainer as? RangeSeekSlider else { return }
        slider.selectedMinValue -= slider.step
        accessibilityValue = slider.topMinLabel.text
    }
}


// MARK: - RangeSeekSliderRightElement

private final class RangeSeekSliderRightElement: UIAccessibilityElement {

    override func accessibilityIncrement() {
        guard let slider = accessibilityContainer as? RangeSeekSlider else { return }
        slider.selectedMaxValue += slider.step
        slider.refresh()
        accessibilityValue = slider.topMaxLabel.text
    }

    override func accessibilityDecrement() {
        guard let slider = accessibilityContainer as? RangeSeekSlider else { return }
        slider.selectedMaxValue -= slider.step
        slider.refresh()
        accessibilityValue = slider.topMaxLabel.text
    }
}


// MARK: - CGRect

private extension CGRect {

    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}


// MARK: - CGPoint

private extension CGPoint {

    func distance(to: CGPoint) -> CGFloat {
        let distX: CGFloat = to.x - x
        let distY: CGFloat = to.y - y
        return sqrt(distX * distX + distY * distY)
    }
}



extension UIImage {
    func resizeTo(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
