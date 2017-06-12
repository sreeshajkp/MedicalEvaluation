//
//  MyPickerView.swift
//  RPResidentApp
//
//  Created by Drishya on 18/04/17.
//  Copyright © 2017 INAPP. All rights reserved.
//

import Foundation
import UIKit

class MyPickerView: UIPickerView,UIPickerViewDelegate,UIPickerViewDataSource {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var pickerData : [String]!
    var pickerTextField : UITextField!
    var selectionHandler : ((selectedText: String,selectedType:String) -> Void)?
    var isCallbackRequired = Bool()
    var selectionTypeG = String()
    
    init(pickerData: [String], dropdownField: UITextField,selectedString:String,ishandlerRequired:Bool,selectionType:String,onSelect selectionHandler : (selectedText: String,selectedType:String) -> Void) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.pickerData = pickerData
        self.pickerTextField = dropdownField
        
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: self.frame.size.height/6, width: self.frame.size.width, height: 35.0))
        
        toolBar.layer.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height-20.0)
        
//        toolBar.barStyle = .blackTranslucent
        toolBar.translucent = true
        
        toolBar.tintColor = UIColor.whiteColor()
        
        toolBar.backgroundColor = UIColor.lightGrayColor()
        
        
//        let defaultButton = UIBarButtonItem(title: "Default", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MyPickerView.tappedToolBarBtn))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(MyPickerView.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width / 3, height: self.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 12)
        
        label.backgroundColor = UIColor.clearColor()
        
        label.textColor = UIColor.whiteColor()
        
//        label.text = "Pick one number"
        
        label.textAlignment = NSTextAlignment.Center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        self.pickerTextField.inputAccessoryView = toolBar

        self.pickerTextField.rightViewMode = UITextFieldViewMode.Always

        let rightImageView = UIImageView()
        rightImageView.image =  UIImage(named: "DownArrow")
        
        let rightView = UIView()
        rightView.addSubview(rightImageView)
        
        rightView.frame = CGRect(x:0, y: 0, width: 15, height: 12)
        rightImageView.frame = CGRect(x:-10, y: 0, width: 15, height: 12)
        
         pickerTextField.rightView = rightView
        
        
        self.delegate = self
        self.dataSource = self
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if pickerData.count > 0 {
                if selectedString != "" {
                    if let i = pickerData.indexOf(selectedString){
                        self.pickerTextField.text = self.pickerData[i]
                        self.selectRow(i, inComponent: 0, animated: true)
                    }
                }
                else{
//                    self.pickerTextField.text = self.pickerData[0]
                     self.pickerTextField.placeholder = "Select"
                }
                self.pickerTextField.userInteractionEnabled = true
            }
            else
            {
                self.pickerTextField.text = nil
                self.pickerTextField.userInteractionEnabled = false
            }
        })
        
        
        if ishandlerRequired == true {
        selectionTypeG = selectionType
        self.selectionHandler = selectionHandler
            if self.pickerTextField.text != nil  && self.selectionHandler != nil {
                selectionHandler(selectedText: self.pickerTextField.text!,selectedType: selectionTypeG)
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func donePressed(sender: UIBarButtonItem) {
        if let selhandlr = selectionHandler {
            selhandlr(selectedText: self.pickerTextField.text!,selectedType: selectionTypeG)
        }
        pickerTextField.resignFirstResponder()
    }
    
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        pickerTextField.text = "one"
        pickerTextField.resignFirstResponder()
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
         return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerData.count
    }
    
    
    // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerData[row]
    }
    
    // When user selects an option, this function will set the text of the text field to reflect
    // the selected option.
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)  {      pickerTextField.text = pickerData[row]
        if let selhandlr = selectionHandler {
            selhandlr(selectedText: self.pickerTextField.text!,selectedType: selectionTypeG)
        }
    }

}



extension UITextField {
    func loadDropdownData(data: [String],selectedValue:String,isReuired:Bool,selectionType:String, onSelect selectionHandler : (selectedText: String,selectedType:String) -> Void) {
        if data.count > 0 {
            self.inputView = MyPickerView(pickerData: data, dropdownField: self,selectedString:selectedValue,ishandlerRequired:isReuired,selectionType:selectionType, onSelect: selectionHandler)
            self.userInteractionEnabled =  true

        }
        else{
            self.inputView = nil
            self.rightView = nil
            self.userInteractionEnabled =  false
        }
        
    }
}
