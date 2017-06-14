//
//  SectionEvaluationTableViewCell.swift
//  Medical Evaluation
//
//  Created by Veena on 12/06/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import UIKit

class SectionEvaluationTableViewCell: UITableViewCell ,UITextFieldDelegate{
    
    @IBOutlet weak var colourView: UIView!
        @IBOutlet weak var typingTextField: UITextField!
        @IBOutlet weak var yesOrNoPicker: UITextField!
        @IBOutlet weak var questionLabel: UILabel!
    var choiceIds : [String] = [""]{
        didSet{
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        typingTextField.delegate = self
        yesOrNoPicker.loadDropdownData([MEAlertYes,MEAlertNo], selectedValue: MEAlertNo, isReuired: true, selectionType: meNilString) {_,_ in
            print(meNilString)
        }
    }
    
    func loadPickerArrayValues(){
        
        
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
    
}
