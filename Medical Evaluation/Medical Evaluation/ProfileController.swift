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
    case Staff = 2
    case Member = 3
    case Lecturer = 4
    case Student = 5
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
    
    func getGroupListForRole(){
     //   callApiCallForProfile(MEmethodNames().meMethodNames.MEGetGroupListMethod)
    }
    
    func getProfileDetails(){
         titles = []
        callApiCallForProfile(MEmethodNames().meMethodNames.MEGetProfileMethod)
    }
    
    func callApiCallForProfile(method: String){
        var url = ""
        startLoadingAnimation(false)
        NetworkManager.sharedManager.delegate = self
        if let accessToken = DBManager.sharedManager.fetchValueForKey(MEAccessToken) as? String{
        if accessToken != ""{
            if method == MEmethodNames().meMethodNames.MEGetProfileMethod{
                url = String(format: MEApiUrls().MEGetProfile.getProfileUrl, accessToken)
            }
            else{
                let take = 15
                let skip = 0
                 url = String(format: MEApiUrls().MEGetGroupList.getGroupList, accessToken,take,skip)
            }

            NetworkManager.sharedManager.apiCallHandler(meEmptyDics, methodName: method, appendUrl: url)
        }
        }
    }
    func populateProfileDetailsWthAPI(profile:MEProfileModel){
        
        if let _ = profile.userName{
           titles.append(profile.userName!)
           
        }
        if let _ = profile.fullName{
           // titles .append(profile.fullName!)
            setAttributedText(UIFont.meBoldFont(), fontToLight: UIFont.systemFontOfSize(13), text: profile.fullName!, constantTex: staticText, label: introductionLabel)
        }
        
        if let role = profile.role{
            switch role {
            case RoleType.User.rawValue:
                titles.append(eAdmin)
                break;
            case RoleType.Student.rawValue:
                titles.append(eStudent)
                break;
            case RoleType.Member.rawValue:
                titles.append(eLecturer)
                break;
            case RoleType.Lecturer.rawValue:
                titles.append(eNurse)
            case RoleType.Staff.rawValue:
                titles.append(eTeacher)
            default:
                break;
            }
        }
        if let _ = profile.group?.name{
            titles.append((profile.group?.name)!)
        }
        if let _ = profile.contactNumber{
            titles.append(profile.contactNumber!)
        }
           print(titles)
      // detailTable.reloadData()
    }
   
    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(METableViewCells().meTableViewCells.meDetailTableViewCell) as! DetailTableViewCell
        if titles.count > 0{
            print(titles)
            cell.titleLabel.text = titles[indexPath.row] as? String
            cell.icon.image = UIImage(named:images[indexPath.row])
        }
        return cell
    }

    @IBAction func logOutAcction(sender: AnyObject) {
        if let accessToken = DBManager.sharedManager.fetchValueForKey(MEAccessToken) as? String{
            if accessToken != "" {
                let url = String(format: MEApiUrls().MELogout.logOutUrl, accessToken)
                startLoadingAnimation(false)
                NetworkManager.sharedManager.delegate = self
                NetworkManager.sharedManager.apiCallHandler(meEmptyDic, methodName: MEmethodNames().meMethodNames.MELogoutMethod, appendUrl: url)
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
            if let successStatus = dataObj[jResult] as? Bool{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.stopLoadingAnimation()
                if successStatus {
                    
                DBManager.sharedManager.removeValueForKey(MEAccessToken)
                DBManager.sharedManager.removeValueForKey(myId)
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
                        self.detailTable.reloadData()
                        self.stopLoadingAnimation()
                    })
            }
            
        }

        }
      
    func networkAPIResultFetchedWithError(error: AnyObject, methodName: String) {
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
       
        let appDeligate = UIApplication.sharedApplication().delegate as! AppDelegate
        let loginVC = mainStoryboard.instantiateViewControllerWithIdentifier(MEStoryBoardIds().meStoryBoardIds.meStartNav) as! UINavigationController
        appDeligate.window?.rootViewController = loginVC
        appDeligate.window?.makeKeyAndVisible()
    }
}

class DetailTableViewCell : UITableViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
}
