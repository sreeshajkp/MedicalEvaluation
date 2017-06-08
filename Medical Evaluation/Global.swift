//
//  Global.swift
//  Medical Evaluation
//
//  Created by Veena on 08/06/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import Foundation
import UIKit

//MARK :- UIlabel attributed text
func setAttributedText(fontToBold : UIFont,fontToLight : UIFont,label : UILabel,constantTex :String){
    let boldAttribute = [NSFontAttributeName: fontToBold]
    let regularAttribute = [NSFontAttributeName: fontToLight]
    let beginningAttributedString = NSAttributedString(string: hi, attributes: boldAttribute )
    let boldAttributedString = NSAttributedString(string: label.text!, attributes: boldAttribute)
    let endAttributedString = NSAttributedString(string: constantTex, attributes: regularAttribute )
    let fullString =  NSMutableAttributedString()
    
    fullString.appendAttributedString(beginningAttributedString)
    fullString.appendAttributedString(boldAttributedString)
    fullString.appendAttributedString(endAttributedString)
    label.attributedText = fullString
}
