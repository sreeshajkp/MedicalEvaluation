//
//  Picker.swift
//  DoxMed
//
//  Created by Veena on 8/26/15.
//  Copyright (c) 2015 inapp. All rights reserved.
//

import UIKit
import Foundation

enum PickerType : NSInteger {
    case Picker
    case DatePicker
    case TimePicker
    case TextField
}

@objc protocol PickerDelegate {
    optional func pickerSelector(selectedRow:Int)
    optional func pickerSelected(picker: Picker)
    optional func pickerEditingDidBegin(picker:Picker)
    optional func pickerEditingDidEnd(picker:Picker)
    optional func selectedRow(picker:Picker)
    optional func noDataFounded()
}

protocol DidSelectCategoryProtocol
{
    func didSelectCategoryAction(category : String,tag:NSInteger)
}

@IBDesignable
class Picker: UIView , UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
  
    var delegate : PickerDelegate?
    var delegateCatgeory : DidSelectCategoryProtocol?
    var selectedIndex : Int?
    var inputIdArray =  [Int]()
    var selectedValue = meNilString
    var selectedTagValue = 0

    @IBOutlet weak var normalTextField: UITextField!
    @IBOutlet weak var pickerContainer: UIView!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var pickerButton: UIButton!
    @IBOutlet weak var pickerTextField: DropDownTextField!

    
    var maximumDate : NSDate? {
        didSet{
           setMaximumDate()
        }
    }
    
    var minimumDate : NSDate? {
        didSet{
            setMinimumDate()
        }
    }

    
    var dropDownItemsArray = []
    var pickerType : PickerType = .Picker{
        didSet{
            setTextField()
        }
    }
    var isPicker:Bool = true{
        didSet{
            pickerButton.hidden = !isPicker
        }
    }
    
    @IBInspectable var placeholder:String = meNilString{
        didSet{
            if pickerType == .TextField{
                normalTextField.placeholder = placeholder
            }
            else{
                pickerTextField.placeholder = placeholder
            }
        }
    }
    @IBInspectable var showDropdown:Bool = true{
        didSet{
            pickerButton.hidden = !showDropdown
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewForXib()        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViewForXib()
    }
    
    func setupViewForXib()
    {
        containerView = loadFromNib()
        containerView.frame = bounds
        containerView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(containerView)
        createBorderLine()
    }
    func loadFromNib() ->UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "Picker", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    class func instanceFromNib() ->UIView {
        let nib = UINib(nibName: "Picker", bundle: nil)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    override func awakeFromNib() {
        setTextField()
        
    }
    
    @IBAction func pickerTextFieldAction(sender: DropDownTextField) {
    
    }
    @IBAction func pickerAction(sender: UIButton) {
        if pickerTextField.isFirstResponder(){
//            pickerTextField.resignFirstResponder()
        }
        else{
            pickerTextField.becomeFirstResponder()
        }
    }
    func createBorderLine(){
        let border = CALayer()
        border.borderColor = UIColor.lightGrayColor().CGColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - 1, width:  self.frame.size.width, height: 0.5)
        
        border.borderWidth = 0.5
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true


    }
    
    
    func setTextField() {
        normalTextField.hidden = true
        pickerContainer.hidden = false
        
        if pickerType == .Picker {
            setPicker()
        }
        else if pickerType == .DatePicker {
            setDatePicker()
        }
        else if pickerType == .TimePicker {
            setTimePicker()
        }
        else if pickerType == .TextField{
            setNormalTextField()
        }
    }
    func setMaximumDate(){
        if let datePicker = pickerTextField.inputView as? UIDatePicker {
           datePicker.maximumDate =  maximumDate
        }
    }
    
    func setMinimumDate(){
        
        if let datePicker = pickerTextField.inputView as? UIDatePicker {
            datePicker.minimumDate =  minimumDate
        }
    }
    
    func setNormalTextField(){
        normalTextField.delegate = self
        normalTextField.hidden = false
        pickerContainer.hidden = true
        
    }
    func setPicker(){
        
        
        let picker = UIPickerView()
        picker.delegate = self
        picker.tintColor = UIColor.whiteColor()
        picker.backgroundColor = UIColor.whiteColor()
        
        let toolBar = UIToolbar (frame: CGRectMake(0, 0, self.frame.width, 30))
        toolBar.barStyle = UIBarStyle.Default   
        toolBar.tintColor = UIColor.blackColor()
        toolBar.barTintColor = UIColor.whiteColor()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(Picker.doneAction))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
     
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        pickerTextField.delegate = self
        pickerTextField.inputView = picker
        pickerTextField.inputAccessoryView = toolBar
    }
    
    func doneAction(){
        if pickerType == .Picker{
            if selectedValue != meNilString{
                pickerTextField.text = selectedValue
                pickerTextField.tag = selectedTagValue
                delegate?.pickerSelected?(self)
            }
        }
        pickerTextField.resignFirstResponder()
    }
    
    
    //MARK:- DatePicker
    func setDatePicker(){
        let datePickerView  = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        pickerTextField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(Picker.handleDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        
    }
    
    
    //MARK:- TimePicker
    func setTimePicker(){
        let timePickerView  = UIDatePicker()
        timePickerView.datePickerMode = UIDatePickerMode.Time
        timePickerView.locale = NSLocale(localeIdentifier: "en_US")
        pickerTextField.inputView = timePickerView
        timePickerView.addTarget(self, action: #selector(Picker.handleTimePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func pickerInputItems(pickerArray :NSArray) {
        
        if pickerArray.count > 0{
            dropDownItemsArray = pickerArray as! [String]
            let picker = pickerTextField.inputView as? UIPickerView
            picker!.reloadAllComponents()
        }
    }
    
    func pickerInputIDitems(idArray : [Int])
    {
        if idArray.count > 0
        {
            inputIdArray = idArray
        }
    }

    //Mark:- Picker Delegates Methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dropDownItemsArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dropDownItemsArray[row] as? String
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if dropDownItemsArray.count > 0{
            if inputIdArray.count > 0
            {
                selectedTagValue = inputIdArray[row]
            }
            selectedValue = dropDownItemsArray[row] as! String
            selectedIndex = row
//            delegate?.selectedRow!(self)
        }
    }
    
    //MARK:- DatePicker
    func handleDatePicker(sender : UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.dateFormat = "MM-dd-yyyy"
        pickerTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    //MARK:- TimePicker
    func handleTimePicker(sender : UIDatePicker) {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        pickerTextField.text = timeFormatter.stringFromDate(sender.date)
    }
    
    //MARK:- TextField Delegate
    
    func textFieldDidBeginEditing(textField: UITextField){
        if pickerType != .TextField{
            if pickerType != PickerType.DatePicker && pickerType != PickerType.TimePicker && dropDownItemsArray.count == 0 && isPicker{
                    pickerTextField.resignFirstResponder()
            }
            
                if dropDownItemsArray.count != 0 {
                    if pickerType == .Picker{
                        textField.text = dropDownItemsArray[0] as? String
                        
                        if inputIdArray.count > 0{
                            textField.tag = inputIdArray[0]
                            textField.text = dropDownItemsArray[0] as? String
                        }
                    }
                }
                else if let datePicker = textField.inputView as? UIDatePicker{
                    if pickerType == .DatePicker{
                        handleDatePicker(datePicker)
                    }
                    else if pickerType == .TimePicker{
                        handleTimePicker(datePicker)
                    }
                }else{
                    
//                    return
                }
        }
        delegate?.pickerEditingDidBegin?(self)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        delegate?.pickerEditingDidEnd?(self)
    }
    
}
class DropDownTextField:UITextField {
    override internal func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {        
        switch action {
        case #selector(NSObject.paste(_:)),#selector(NSObject.select(_:)), #selector(NSObject.selectAll(_:)),#selector(NSObject.copy(_:)),#selector(NSObject.cut(_:)) : return false
        default :break
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    override func caretRectForPosition(position: UITextPosition) -> CGRect {
        return CGRectZero
    }
    override func selectionRectsForRange(range: UITextRange) -> [AnyObject] {
        return []
    }
}