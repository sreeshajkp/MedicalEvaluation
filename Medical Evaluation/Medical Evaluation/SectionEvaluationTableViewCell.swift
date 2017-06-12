//
//  SectionEvaluationTableViewCell.swift
//  Medical Evaluation
//
//  Created by Veena on 12/06/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import UIKit

class SectionEvaluationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var colourView: UIView!
        @IBOutlet weak var typingTextField: UITextField!
        @IBOutlet weak var yesOrNoPicker: Picker!
        @IBOutlet weak var questionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        yesOrNoPicker.pickerInputItems(["Yes","No"])
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
