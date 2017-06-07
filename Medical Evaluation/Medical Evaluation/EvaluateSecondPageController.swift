//
//  EvaluateSecondPageController.swift
//  Medical Evaluation
//
//  Created by Sreeshaj Kp on 07/01/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import UIKit

class EvaluateSecondPageController: UIViewController {

    @IBOutlet weak var nursePicker: Picker!
    @IBOutlet weak var studentPicker: Picker!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentPicker.pickerTextField.text = "Ali"
        studentPicker.pickerInputItems(["Ali","Timmy","Lim","Hong"])
        
        nursePicker.pickerTextField.text = "Ali"
        nursePicker.pickerInputItems(["Ali","Timmy","Lim","Hong"])


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
