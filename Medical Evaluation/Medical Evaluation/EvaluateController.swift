//
//  EvaluateController.swift
//  Medical Evaluation
//
//  Created by Sreeshaj Kp on 07/01/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import UIKit

class EvaluateController: PagerController,PagerDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
      //  setUpPagerTabsViewControllers()

        
        // Do any additional setup after loading the view.
    }
    
    
    func setUpPagerTabsViewControllers(){
          
        let firstVc  = mainStoryboard.instantiateViewControllerWithIdentifier(MEStoryBoardIds().meStoryBoardIds.meEvaluateFirstPageController) as! EvaluateFirstPageController
        let secondVc  = mainStoryboard.instantiateViewControllerWithIdentifier(MEStoryBoardIds().meStoryBoardIds.meEvaluateSecondPageController) as! EvaluateSecondPageController
        
        let viewControllers = [firstVc,secondVc]
        
        
            self.setupPager(tabNames: ["Nurse","Patient"], tabControllers: viewControllers)
            self.reloadData()
    }

    func dismissViewControllersWithNavigation(){
    
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
