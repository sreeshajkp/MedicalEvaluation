//
//  SectionEvaluationTableViewCell.swift
//  Medical Evaluation
//
//  Created by Veena on 12/06/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import UIKit

class SectionEvaluationTableViewCell: UITableViewCell ,UITextFieldDelegate,PickerDelegate{
    
    @IBOutlet weak var colourView: UIView!
        @IBOutlet weak var typingTextField: UITextField!
        @IBOutlet weak var yesOrNoPicker: Picker!
        @IBOutlet weak var questionLabel: UILabel!
    var choiceIds : [String] = [""]{
        didSet{
            self.loadPickerArrayValues()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        yesOrNoPicker.delegate = self
        yesOrNoPicker.pickerType = .Picker
        typingTextField.delegate = self
    }
    
    
    func loadPickerArrayValues(){
        
        if choiceIds.count > 0{
            yesOrNoPicker.pickerTextField.text = choiceIds[0]
            yesOrNoPicker.pickerInputItems(choiceIds)
            }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        colourView.backgroundColor = UIColor.METextFieldColor()
    }
    func textFieldDidEndEditing(textField: UITextField) {
         colourView.backgroundColor = UIColor.lightGrayColor()
    }
     func textFieldShouldReturn(textField: UITextField) -> Bool{
        typingTextField.resignFirstResponder()
        return true
    }
    
}
