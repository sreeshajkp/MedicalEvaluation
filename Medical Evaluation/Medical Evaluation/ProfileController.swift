//
//  ProfileController.swift
//  Medical Evaluation
//
//  Created by Sreeshaj Kp on 07/01/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import UIKit

enum RoleType: Int{
    case User = 1
    case Student = 2
    case Member = 3
}

class ProfileController: UIViewController ,MEDelegate{
    
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var detailTable: UITableView!
    
    var titles = [String]()
    let images = ["Id","Student","Group","Call"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewProporties()
        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        getProfileDetails()
    }
    
    func setTableViewProporties(){
        detailTable.estimatedRowHeight = 60.00
        detailTable.rowHeight = UITableViewAutomaticDimension
        detailTable.tableFooterView = UIView()
        
    }
    
    func getProfileDetails(){
        startLoadingAnimation(true)
        NetworkManager.sharedManager.delegate = self
        if let accessToken = DBManager.sharedManager.fetchValueForKey(MEAccessToken) as? String{
            if accessToken != ""{
                let url = String(format: MEApiUrls().MEGetProfile.getProfileUrl, accessToken)
                NetworkManager.sharedManager.getDetails(MEmethodNames().meMethodNames.MEGetProfileMethod, appendUrl: url)
            }
        }
    }
    
    func populateProfileDetailsWthAPI(profile:MEProfileModel){
        
        if let _ = profile.fullName{
           titles.append(profile.fullName!)
            introductionLabel.text = " Hi \(profile.fullName!), I hope you're doing well."
        }
        if let _ = profile.userName{
            titles.append(profile.userName!)
        }
        
        if let role = profile.role{
            switch role {
            case RoleType.User.rawValue:
                titles.append("User")
                break;
            case RoleType.User.rawValue:
                titles.append("Student")
                break;
            case RoleType.User.rawValue:
                titles.append("Member")
                break;
            default:
                break;
            }
        }
        if let _ = profile.contactNumber{
            titles.append(profile.contactNumber!)
        }
           print(titles)
        detailTable.reloadData()
    }
   
    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailTableViewCell") as! DetailTableViewCell
        if titles.count > 0{
            cell.titleLabel.text = titles[indexPath.row] as? String
        }
        cell.icon.image = UIImage(named:images[indexPath.row])
        
        return cell
    }

    @IBAction func logOutAcction(sender: AnyObject) {
        if let accessToken = DBManager.sharedManager.fetchValueForKey(MEAccessToken) as? String{
            if accessToken != "" {
                let url = String(format: MEApiUrls().MELogout.logOutUrl, accessToken)
                startLoadingAnimation(true)
                NetworkManager.sharedManager.delegate = self
                NetworkManager.sharedManager.postDetails([:], methodName: MEmethodNames().meMethodNames.MELogoutMethod, appendUrl: url)
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK:- MEDelgate Methods
    
    func networkAPIResultFetched(result: AnyObject, message: String, methodName: String) {
    
        if let dataObj = result  as? NSDictionary{
                if methodName == MEmethodNames().meMethodNames.MELogoutMethod{
            if let successStatus = dataObj["Result"] as? Bool{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.stopLoadingAnimation()
                if successStatus {
                    
                DBManager.sharedManager.removeValueForKey(MEAccessToken)
                self.showAlertController(MEAppName, message: logOutMsg, cancelButton: MEAlertOK, otherButtons: [], handler: { (buttonIndex) in
                    switch buttonIndex{
                    case 0:
                        self.moveTheLoginPage()
                        break
                    default:
                        break;
                    }
                })
                }
                })
            }
            }
                else if methodName == MEmethodNames().meMethodNames.MEGetProfileMethod{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                         let profileDetails = ModelClassManager.sharedManager.createModelArray([result], modelType: ModelType.MEProfileModel) as? [MEProfileModel]
                        self.populateProfileDetailsWthAPI(profileDetails![0])
                        self.stopLoadingAnimation()
                    })
            }
        }
      
    }
    func networkAPIResultFetchedWithError(error: AnyObject, methodName: String, status: Int) {
          dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.stopLoadingAnimation()
        self.showAlertController(MEAppName, message: error as! String, cancelButton: MEAlertOK, otherButtons: [], handler: nil)
        })
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func moveTheLoginPage(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let appDeligate = UIApplication.sharedApplication().delegate as! AppDelegate
        let loginVC = mainStoryboard.instantiateViewControllerWithIdentifier("startNav") as! UINavigationController
        appDeligate.window?.rootViewController = loginVC
        appDeligate.window?.makeKeyAndVisible()
    }
}

class DetailTableViewCell : UITableViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
}
