//
//  AMPFloatingTextField.swift
//  Pods
//
//  Created by Kuliza-282 on 13/09/17.
//
//

import UIKit

/**
 A beautiful textfield implementation with support for top title label, bottom error message and placeholder.
 */

@IBDesignable
open class AMPFloatingTextField: UITextField { // swiftlint:disable:this type_body_length
   
   
    var  counter = 0

    fileprivate func updateTextAligment() {
            textAlignment = .left
            titleLabel.textAlignment = .left
    }
    
    // MARK: Animation timing
    
    /// The value of the title appearing duration
    dynamic open var titleFadeInDuration: TimeInterval = 0.2
    /// The value of the title disappearing duration
    dynamic open var titleFadeOutDuration: TimeInterval = 0.3
    
    // MARK: Colors
    
    fileprivate var cachedTextColor: UIColor?
    private let borderLayer = CALayer()
    // This property applies a thickness to the border of the control. The default value for this property is 2 points.
    @IBInspectable open var borderSize: CGFloat = 2.0 {
        didSet {
            updateBorder()
        }
    }
    
    // The color of the border when it has content. By default, there will be no color
    @IBInspectable dynamic open var activeBorderColor: UIColor = .clear {
        didSet {
            updateBorder()
            updateBackground()
            //updatePlaceholder()
        }
    }
    
    
    // The color of the border when it has no content. By default, there will be no color
    @IBInspectable dynamic open var inactiveBorderColor: UIColor = .clear {
        didSet {
            updateBorder()
            updateBackground()
//            updatePlaceholder()
        }
    }
    
    // The color of the input's background when it has content. When it's not focused it reverts to the color of the `inactiveBorderColor`.
    @IBInspectable dynamic open var activeBackgroundColor: UIColor = .clear {
        didSet {
            updateBackground()
        }
    }
    
    // The scale of the placeholder font. This property determines the size of the placeholder label relative to the font size of the text field.
    @IBInspectable dynamic open var placeholderFontScale: CGFloat = 0.7 {
        didSet {
            updatePlaceholder()
        }
    }
    
    /// A UIColor value that determines the text color of the editable text
    @IBInspectable
    override dynamic open var textColor: UIColor? {
        set {
            cachedTextColor = newValue
            updateControl(false)
        }
        get {
            return cachedTextColor
        }
    }
    
    /// A UIColor value that determines text color of the placeholder label
    @IBInspectable dynamic open var placeholderColor: UIColor = UIColor.lightGray {
        didSet {
            updatePlaceholder()
        }
    }
    
    /// A UIFont value that determines text color of the placeholder label
    @IBInspectable dynamic open var placeholderFont: UIFont? {
        didSet {
            updatePlaceholder()
        }
    }
    
    fileprivate func updatePlaceholder() {
        if let placeholder = placeholder, let font = placeholderFont ?? font {
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSForegroundColorAttributeName: placeholderColor, NSFontAttributeName: font]
            )
        }
    }
    
    /// A UIFont value that determines the text font of the title label
    @IBInspectable dynamic open var titleFont: UIFont = .systemFont(ofSize: 13) {
        didSet {
            updateTitleLabel()
        }
    }
    
    /// A UIColor value that determines the text color of the title label when in the normal state
    @IBInspectable dynamic open var titleColor: UIColor = .gray {
        didSet {
            updateTitleColor()
        }
    }
    
    /// A UIColor value that determines the color of the bottom line when in the normal state
    @IBInspectable dynamic open var lineColor: UIColor = .lightGray {
        didSet {
            updateLineView()
        }
    }
    
    /// A UIColor value that determines the color used for the title label and line when the error message is not `nil`
    @IBInspectable dynamic open var errorColor: UIColor = .red {
        didSet {
            updateColors()
        }
    }
    
    /// A UIColor value that determines the text color of the title label when editing
    @IBInspectable dynamic open var selectedTitleColor: UIColor = .blue {
        didSet {
            updateTitleColor()
        }
    }
    
    /// A UIColor value that determines the color of the line in a selected state
    @IBInspectable dynamic open var selectedLineColor: UIColor = .black {
        didSet {
            updateLineView()
        }
    }
    
    // MARK: Line height
    
    /// A CGFloat value that determines the height for the bottom line when the control is in the normal state
    @IBInspectable dynamic open var lineHeight: CGFloat = 0.5 {
        didSet {
            updateLineView()
            setNeedsDisplay()
        }
    }
    
    /// A CGFloat value that determines the height for the bottom line when the control is in a selected state
    @IBInspectable dynamic open var selectedLineHeight: CGFloat = 1.0 {
        didSet {
            updateLineView()
            setNeedsDisplay()
        }
    }
    
    // MARK: View components
    
    /// The internal `UIView` to display the line below the text input.
    open var lineView: UIView!
    
    /// The internal `UILabel` that displays the selected, deselected title or error message based on the current state.
    open var titleLabel: UILabel!
    
    open var errorLabel: UILabel!
    
    // MARK: Properties
    
    /**
     The formatter used before displaying content in the title label.
     This can be the `title`, `selectedTitle` or the `errorMessage`.
     The default implementation converts the text to uppercase.
     */
    
    private func updateBorder() {
        borderLayer.frame = CGRect( x: bounds.origin.x, y: titleHeight(), width: bounds.size.width,
            height: bounds.size.height - titleHeight() * 2 - selectedLineHeight
        )
        borderLayer.borderWidth = borderSize
        borderLayer.borderColor = (isFirstResponder || !(text!.isEmpty)) ? activeBorderColor.cgColor : inactiveBorderColor.cgColor
    }
    
    private func updateBackground() {
        if isFirstResponder || !(text!.isEmpty) {
            borderLayer.backgroundColor = activeBackgroundColor.cgColor
        } else {
            borderLayer.backgroundColor = inactiveBorderColor.cgColor
        }
    }
    
    open var titleFormatter: ((String) -> String) = { (text: String) -> String in
        return text.uppercased()
    }
    
    /**
     Identifies whether the text object should hide the text being entered.
     */
    override open var isSecureTextEntry: Bool {
        set {
            super.isSecureTextEntry = newValue
            fixCaretPosition()
        }
        get {
            return super.isSecureTextEntry
        }
    }
    
    /// A String value for the error message to display.
    open var errorMessage: String? {
        didSet {
            updateControl(true)
        }
    }
    
    /// The backing property for the highlighted property
    fileprivate var _highlighted: Bool = false
    
    /**
     A Boolean value that determines whether the receiver is highlighted.
     When changing this value, highlighting will be done with animation
     */
    override open var isHighlighted: Bool {
        get {
            return _highlighted
        }
        set {
            _highlighted = newValue
            updateTitleColor()
            updateLineView()
        }
    }
    
    /// A Boolean value that determines whether the textfield is being edited or is selected.
    open var editingOrSelected: Bool {
        return super.isEditing || isSelected
    }
    
    /// A Boolean value that determines whether the receiver has an error message.
    open var hasErrorMessage: Bool {
        return errorMessage != nil && errorMessage != ""
    }
    
    fileprivate var _renderingInInterfaceBuilder: Bool = false
    
    /// The text content of the textfield
    @IBInspectable
    override open var text: String? {
        didSet {
            updateControl(false)
        }
    }
    
    /**
     The String to display when the input field is empty.
     The placeholder can also appear in the title label when both `title` `selectedTitle` and are `nil`.
     */
    @IBInspectable
    override open var placeholder: String? {
        didSet {
            setNeedsDisplay()
            updatePlaceholder()
            updateTitleLabel()
        }
    }
    
    /// The String to display when the textfield is editing and the input is not empty.
    @IBInspectable open var selectedTitle: String? {
        didSet {
            updateControl()
        }
    }
    
    /// The String to display when the textfield is not editing and the input is not empty.
    @IBInspectable open var title: String? {
        didSet {
            updateControl()
        }
    }
    
    // Determines whether the field is selected. When selected, the title floats above the textbox.
    open override var isSelected: Bool {
        didSet {
            updateControl(true)
        }
    }
    
    // MARK: - Initializers
    
    /**
     Initializes the control
     - parameter frame the frame of the control
     */
    override public init(frame: CGRect) {
        super.init(frame: frame)
        init_AMPFloatingTextField()
    }
    
    /**
     Intialzies the control by deserializing it
     - parameter coder the object to deserialize the control from
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        init_AMPFloatingTextField()
    }
    
    fileprivate final func init_AMPFloatingTextField() {
        borderStyle = .none
        createTitleLabel()
        createLineView()
        createErrorLabel()
        layer.addSublayer(borderLayer)
        updateColors()
        addEditingChangedObserver()
        updateTextAligment()
    }
    
    
    
    
    fileprivate func addEditingChangedObserver() {
        self.addTarget(self, action: #selector(AMPFloatingTextField.editingChanged), for: .editingChanged)
        self.addTarget(self, action: #selector(AMPFloatingTextField.editingBegin), for: .editingDidBegin)
    }
    
    open func editingBegin() {
        _titleVisible = true
        self.placeholder = ""
        updateTitleLabel(true)
        updateBorder()
        updateBackground()
    }
    
    
    /**
     Invoked when the editing state of the textfield changes. Override to respond to this change.
     */
    open func editingChanged() {
        updateControl(true)
        updateTitleLabel(true)
    }
    
    // MARK: create components
    
    fileprivate func createTitleLabel() {
        let titleLabel = UILabel()
        titleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        titleLabel.font = titleFont
        titleLabel.alpha = 0.0
        titleLabel.textColor = titleColor
        
        addSubview(titleLabel)
        self.titleLabel = titleLabel
    }
    
    fileprivate func createErrorLabel() {
        let titleLabel = UILabel()
        titleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        titleLabel.font = titleFont
        titleLabel.alpha = 0.0
        titleLabel.textColor = titleColor
        addSubview(titleLabel)
        self.errorLabel = titleLabel
    }
    
    
    
    
    fileprivate func createLineView() {
        
        if lineView == nil {
            let lineView = UIView()
            lineView.isUserInteractionEnabled = false
            self.lineView = lineView
            configureDefaultLineHeight()
        }
        
        lineView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        addSubview(lineView)
    }
    
    fileprivate func configureDefaultLineHeight() {
        let onePixel: CGFloat = 1.0 / UIScreen.main.scale
        lineHeight = 2.0 * onePixel
        selectedLineHeight = 2.0 * self.lineHeight
    }
    
    // MARK: Responder handling
    
    /**
     Attempt the control to become the first responder
     - returns: True when successfull becoming the first responder
     */
    @discardableResult
    override open func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        updateControl(true)
        return result
    }
    
    /**
     Attempt the control to resign being the first responder
     - returns: True when successfull resigning being the first responder
     */
    @discardableResult
    override open func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        if !hasText {
            self.placeholder = titleLabel.text
            _titleVisible = false
        }
        updateControl(true)
        return result
    }
    
    // MARK: - View updates
    
    fileprivate func updateControl(_ animated: Bool = false) {
        updateColors()
        updateLineView()
        
        updateTitleLabel(animated)
        updateErrorLabel(animated)
    }
    
    fileprivate func updateLineView() {
        if let lineView = lineView {
            lineView.frame = lineViewRectForBounds(bounds, editing: editingOrSelected)
        }
        updateLineColor()
    }
    
    // MARK: - Color updates
    
    /// Update the colors for the control. Override to customize colors.
    open func updateColors() {
        updateLineColor()
        updateTitleColor()
        updateTextColor()
        updateErrorLabelColor()
        updateBackground()
    }
    
    fileprivate func updateLineColor() {
        if hasErrorMessage {
            lineView.backgroundColor = errorColor
        } else {
            lineView.backgroundColor = editingOrSelected ? selectedLineColor : lineColor
        }
    }
    
    fileprivate func updateTitleColor() {
        if editingOrSelected || isHighlighted {
            titleLabel.textColor = selectedTitleColor
        } else {
            titleLabel.textColor = titleColor
        }
        
    }
    
    fileprivate func updateErrorLabelColor() {
        if hasErrorMessage {
            errorLabel.textColor = errorColor
        }
    }
    
    
    fileprivate func updateTextColor() {
        if hasErrorMessage {
            super.textColor = errorColor
        } else {
            super.textColor = cachedTextColor
        }
    }
    
    // MARK: - Title handling
    
    fileprivate func updateTitleLabel(_ animated: Bool = false) {
        
        var titleText: String? = nil
        
        if editingOrSelected {
            titleText = selectedTitleOrTitlePlaceholder()
            if titleText == nil {
                titleText = titleOrPlaceholder()
            }
        } else {
            titleText = titleOrPlaceholder()
        }
        titleLabel.text = titleText
        titleLabel.font = titleFont
        
        updateTitleVisibility(animated)
    }
    
    
    fileprivate func updateErrorLabel(_ animated: Bool = false) {
        
        var titleText: String? = nil
        if hasErrorMessage {
            titleText = titleFormatter(errorMessage!)
        }
        errorLabel.text = titleText
        errorLabel.font = titleFont
        
        updateErrorVisibility(animated)
        
    }
    
    fileprivate var _titleVisible: Bool = false
    
    /*
     *   Set this value to make the title visible
     */
    open func setTitleVisible(
        _ titleVisible: Bool,
        animated: Bool = false,
        animationCompletion: ((_ completed: Bool) -> Void)? = nil
        ) {
        if _titleVisible == titleVisible {
            return
        }
        _titleVisible = titleVisible
        updateTitleColor()
        updateTitleVisibility(animated, completion: animationCompletion)
    }
    
    /**
     Returns whether the title is being displayed on the control.
     - returns: True if the title is displayed on the control, false otherwise.
     */
    open func isTitleVisible() -> Bool {
        return hasText || _titleVisible
    }
    
    open func isErrorVisible() -> Bool {
        return  hasErrorMessage
    }
    
    fileprivate func updateTitleVisibility(_ animated: Bool = false, completion: ((_ completed: Bool) -> Void)? = nil) {
        let alpha: CGFloat = isTitleVisible() ? 1.0 : 0.0
        let frame: CGRect = titleLabelRectForBounds(bounds, editing: isTitleVisible())
        let updateBlock = { () -> Void in
            self.titleLabel.alpha = alpha
            self.titleLabel.frame = frame
        }
        if animated {
            let animationOptions: UIViewAnimationOptions = .curveEaseOut
            let duration = isTitleVisible() ? titleFadeInDuration : titleFadeOutDuration
            UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: { () -> Void in
                updateBlock()
            }, completion: completion)
        } else {
            updateBlock()
            completion?(true)
        }
    }
    
    
    fileprivate func updateErrorVisibility(_ animated: Bool = false, completion: ((_ completed: Bool) -> Void)? = nil) {
        let alpha: CGFloat = isErrorVisible() ? 1.0 : 0.0
        let frame: CGRect = errorLabelRectForBounds(bounds, editing: isTitleVisible())
        let updateBlock = { () -> Void in
            self.errorLabel.alpha = alpha
            self.errorLabel.frame = frame
        }
        if animated {
            let animationOptions: UIViewAnimationOptions = .curveEaseOut
            let duration = isTitleVisible() ? titleFadeInDuration : titleFadeOutDuration
            UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: { () -> Void in
                updateBlock()
            }, completion: completion)
        } else {
            updateBlock()
            completion?(true)
        }
    }
    
    // MARK: - UITextField text/placeholder positioning overrides
    
    /**
     Calculate the rectangle for the textfield when it is not being edited
     - parameter bounds: The current bounds of the field
     - returns: The rectangle that the textfield should render in
     */
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.textRect(forBounds: bounds)
        
        
        let rect = CGRect(
            x: superRect.origin.x,
            y: titleHeight(),
            width: superRect.size.width,
            height: superRect.size.height - ( titleHeight() * 2 ) - selectedLineHeight
        )
        
        
        return rect
    }
    
    /**
     Calculate the rectangle for the textfield when it is being edited
     - parameter bounds: The current bounds of the field
     - returns: The rectangle that the textfield should render in
     */
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.editingRect(forBounds: bounds)
        let titleHeight = self.titleHeight()
        
        let rect = CGRect(
            x: superRect.origin.x,
            y: titleHeight,
            width: superRect.size.width,
            height: superRect.size.height - titleHeight * 2 - selectedLineHeight
        )
        return rect
    }
    
    /**
     Calculate the rectangle for the placeholder
     - parameter bounds: The current bounds of the placeholder
     - returns: The rectangle that the placeholder should render in
     */
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let rect = CGRect(
            x: 0,
            y: titleHeight(),
            width: bounds.size.width,
            height: bounds.size.height - titleHeight() * 2 - selectedLineHeight
        )
        return rect
    }
    
    // MARK: - Positioning Overrides
    
    /**
     Calculate the bounds for the title label. Override to create a custom size title field.
     - parameter bounds: The current bounds of the title
     - parameter editing: True if the control is selected or highlighted
     - returns: The rectangle that the title label should render in
     */
    open func titleLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        if editing {
            return CGRect(x: 0, y: 0, width: bounds.size.width, height: titleHeight())
        }
        
        return CGRect(x: 0, y: titleHeight(), width: bounds.size.width, height: titleHeight())
    }
    
    open func errorLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        
        if editing {
            let height = bounds.size.height - titleHeight() + 2
            return CGRect(x: 0, y: height, width: bounds.size.width, height: titleHeight())
        }
        
        let height = bounds.size.height - titleHeight() * 2
        
        return CGRect(x: 0, y: height, width: bounds.size.width, height: titleHeight())
    }
    
    
    /**
     Calculate the bounds for the bottom line of the control.
     Override to create a custom size bottom line in the textbox.
     - parameter bounds: The current bounds of the line
     - parameter editing: True if the control is selected or highlighted
     - returns: The rectangle that the line bar should render in
     */
    open func lineViewRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        
        if editing {
            let height = editing ? selectedLineHeight : lineHeight
            let yPosition = bounds.size.height - titleHeight()
            return CGRect(x: 0, y: yPosition, width: bounds.size.width, height: height)
        }
        
        //return CGRect(x: 0, y: 40, width: bounds.size.width, height: titleHeight())
        
        //        let height = editing ? selectedLineHeight : lineHeight
        //        return CGRect(x: 0, y: 39, width: bounds.size.width, height: height)
        return CGRect.zero
    }
    
    /**
     Calculate the height of the title label.
     -returns: the calculated height of the title label. Override to size the title with a different height
     */
    open func titleHeight() -> CGFloat {
        if let titleLabel = titleLabel,
            let font = titleLabel.font {
            return font.lineHeight
        }
        return 15.0
    }
    
    /**
     Calcualte the height of the textfield.
     -returns: the calculated height of the textfield. Override to size the textfield with a different height
     */
    open func textHeight() -> CGFloat {
        return self.font!.lineHeight + 7.0
    }
    
    // MARK: - Layout
    
    /// Invoked when the interface builder renders the control
    override open func prepareForInterfaceBuilder() {
        if #available(iOS 8.0, *) {
            super.prepareForInterfaceBuilder()
        }
        
        borderStyle = .none
        
        isSelected = true
        _renderingInInterfaceBuilder = true
        updateControl(false)
        invalidateIntrinsicContentSize()
    }
    
    /// Invoked by layoutIfNeeded automatically
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = titleLabelRectForBounds(bounds, editing: isTitleVisible() || _renderingInInterfaceBuilder)
        
        errorLabel.frame = errorLabelRectForBounds(bounds, editing: isErrorVisible() || _renderingInInterfaceBuilder)
        
        lineView.frame = lineViewRectForBounds(bounds, editing: editingOrSelected || _renderingInInterfaceBuilder)
    }
    
    /**
     Calculate the content size for auto layout
     
     - returns: the content size to be used for auto layout
     */
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.size.width, height: titleHeight() + textHeight())
    }
    
    // MARK: - Helpers
    
    fileprivate func titleOrPlaceholder() -> String? {
        guard let title = title ?? placeholder else {
            return nil
        }
        return titleFormatter(title)
    }
    
    fileprivate func selectedTitleOrTitlePlaceholder() -> String? {
        guard let title = selectedTitle ?? title ?? placeholder else {
            return nil
        }
        return titleFormatter(title)
    }
} // swiftlint:disable:this file_length
