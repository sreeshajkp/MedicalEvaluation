//
//  ListController.swift
//  Medical Evaluation
//
//  Created by Sreeshaj Kp on 07/01/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import UIKit


class ListController: UIViewController ,MEDelegate{

    @IBOutlet weak var listTable: UITableView!
    var userList = [MEProfileModel]()
    var filterType = 1
    var skip = 0
    var take = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewProporties()
         // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        getUsersList()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUsersList(){
        if let accessToken = DBManager.sharedManager.fetchValueForKey(MEAccessToken) as? String{
            if accessToken != "" {
                let url = String(format: MEApiUrls().MEGetUsersProfile.getUsersProfile, accessToken,take,skip,filterType)
                NetworkManager.sharedManager.delegate = self
                NetworkManager.sharedManager.apiCallHandler([:], methodName: MEmethodNames().meMethodNames.MEGetUsersMethod, appendUrl: url)
            }
        }
    }
    func setTableViewProporties(){
        
        listTable.estimatedRowHeight = 60.00
        listTable.rowHeight = UITableViewAutomaticDimension
        listTable.tableFooterView = UIView()
        
    }
    //MARK:- Get RoleName from role
    
    func getRoleValueFromApi(role: Int) -> String{
        var roleValue = String()
        enum RoleType: Int{
            case User = 1
            case Student = 2
            case Member = 3
            case Nurse = 4
            case Teacher = 5
        }
        switch role {
        case RoleType.User.rawValue:
            roleValue = eUser
            return roleValue
            
        case RoleType.Student.rawValue:
            roleValue = eStudent
            return roleValue
            
        case RoleType.Member.rawValue:
            roleValue = eMember
            return roleValue
            
        case RoleType.Nurse.rawValue:
            roleValue = eNurse
            return roleValue
            
        case RoleType.Teacher.rawValue:
            roleValue = eTeacher
            return roleValue
        default:
            break
           
        }
         return ""
    }
    
    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(METableViewCells().meTableViewCells.meListTableViewCell) as! ListTableViewCell
        if let fullName = userList[indexPath.row].fullName{
        cell.nameLabel.text = fullName
        }
        else{
            cell.nameLabel.text = userList[indexPath.row].userName //Sometimes they didnt give the fullname in api..so i take username insted(for sake)
        }
        cell.roleLabel.text =  getRoleValueFromApi(userList[indexPath.row].role!)
        if let isEvaluated = userList[indexPath.row].isEvaluated{
            print(isEvaluated)
            if isEvaluated{ cell.tickImageView.image = UIImage(named: "GreenTick") }
            else{ cell.tickImageView.image = UIImage(named: "")}
        }
        return cell
    }

    //MARK:- MEDelegate Methods
    func networkAPIResultFetched(result: AnyObject, message: String, methodName: String) {
            if   result  is NSArray {
            if methodName == MEmethodNames().meMethodNames.MEGetUsersMethod{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    let profileDetails = ModelClassManager.sharedManager.createModelArray(result as! NSArray, modelType: ModelType.MEProfileModel) as? [MEProfileModel]
                    self.userList = profileDetails!
                   
                    self.stopLoadingAnimation()
                     self.listTable.reloadData()
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

}

class ListTableViewCell : UITableViewCell{
    @IBOutlet weak var tickImageView: UIImageView!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
}

