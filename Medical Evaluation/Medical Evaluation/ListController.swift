//
//  ListController.swift
//  Medical Evaluation
//
//  Created by Sreeshaj Kp on 07/01/17.
//  Copyright © 2017 Sreeshaj Kp. All rights reserved.
//

import UIKit


class ListController: UIViewController ,MEDelegate{
    
    var userList = [MEMemberListModel]()
    var skip = 0
    var take = 10
    @IBOutlet weak var groupLabel: UILabel!

    @IBOutlet weak var listTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewProporties()
    }
    
    override func viewWillAppear(animated: Bool) {
        callApiCall(MEmethodNames().meMethodNames.MEGetProfileMethod)
        callApiCall(MEmethodNames().meMethodNames.MEGetMemberListMethod)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK :- Call Api Methods
    func callApiCall(method: String){
        var url = meNilString
        if let accessToken = DBManager.sharedManager.fetchValueForKey(MEAccessToken) as? String{
            if accessToken != meNilString {
                
                if method == MEmethodNames().meMethodNames.MEGetMemberListMethod{
                 url = String(format: MEApiUrls().MEGetMemberList.getMemberList, accessToken,take,skip)
                }
                    
                else if method == MEmethodNames().meMethodNames.MEGetProfileMethod{
                    url = String(format: MEApiUrls().MEGetProfile.getProfileUrl, accessToken)
                }
                
                NetworkManager.sharedManager.delegate = self
                NetworkManager.sharedManager.apiCallHandler(meEmptyDics, methodName: method, appendUrl: url)
            }
        }
    }
    
    //MARK:- Set Tableview properties
    func setTableViewProporties(){
        listTable.estimatedRowHeight = 60.00
        listTable.rowHeight = UITableViewAutomaticDimension
        listTable.tableFooterView = UIView()
    }
    
    //MARK:- Get RoleName from role
    func getRoleValueFromApi(role: Int) -> String{
        var roleValue = String()
        enum RoleType: Int{
            case All = 1
            case Lecturer = 2
            case Staff = 3
            case Patient = 4
            case Student = 5
        }
        switch role {
        case RoleType.All.rawValue:
            roleValue = eUser
            return roleValue
            
        case RoleType.Lecturer.rawValue:
            roleValue = eLecturer
            return roleValue
            
        case RoleType.Staff.rawValue:
            roleValue = eStaff
            return roleValue
            
        case RoleType.Patient.rawValue:
            roleValue = ePatient
            return roleValue
            
        case RoleType.Student.rawValue:
            roleValue = eStudent
            return roleValue
        default:
            break
        }
         return meNilString
    }
    
    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userList.count == 0{
            return 0
        }else{
            return userList[0].member.count

        }
    }
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(METableViewCells().meTableViewCells.meListTableViewCell) as! ListTableViewCell
        cell.selectionStyle = .None
        if let fullName = userList[0].member[indexPath.row].mFullName{
        cell.nameLabel.text = fullName
        }
        else{
            cell.nameLabel.text = "Title Name"//userList[indexPath.row].userName //Sometimes they didnt give the fullname in api..so i take username insted(for sake)
        }
        cell.roleLabel.text =  getRoleValueFromApi(userList[0].member[indexPath.row].mRole!)
        if let isEvaluated = userList[0].member[indexPath.row].misEvaluated{
            print(isEvaluated)
            checkTheUserIdForAccessoryView(cell,userId: userList[0].member[indexPath.row].mUserId!, isEvaluated: isEvaluated)
        }
        return cell
    }

    
    //MARK:- Checking my userid with each menbers id
    func checkTheUserIdForAccessoryView(cell : ListTableViewCell,userId : String,isEvaluated : Bool){
        if let myIdValue = DBManager.sharedManager.fetchValueForKey(myId){
            if userId == myIdValue as! String{
                cell.tickImageView.image = UIImage(named: "User")
        }
            else{
                if isEvaluated{
                    cell.tickImageView.image = UIImage(named: "GreenTick")
                }
                else{
                     cell.tickImageView.image = UIImage(named: "Cross")
                }
            }
    }
    }
    
    //MARK:- MEDelegate Methods
    func networkAPIResultFetched(result: AnyObject, message: String, methodName: String) {
            if   result  is NSDictionary {
            if methodName == MEmethodNames().meMethodNames.MEGetMemberListMethod{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let profileDetails = ModelClassManager.sharedManager.createModelArray([result], modelType: ModelType.MEMemberListModel) as? [MEMemberListModel]
                    self.userList = profileDetails!
                    self.setTitleNavigationBar(profileDetails![0])
                    self.parseTheUsersDataToGetPickerInputs(self.userList)
                    self.stopLoadingAnimation()
                     self.listTable.reloadData()
        
                })
            }
                
              else  if methodName == MEmethodNames().meMethodNames.MEGetProfileMethod{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        DBManager.sharedManager.insertValue(result, forKey: meUserDetails)
                        _ = ModelClassManager.sharedManager.createModelArray([result], modelType: ModelType.MEProfileModel) as? [MEProfileModel]
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
    
    func setTitleNavigationBar(modelObj:MEMemberListModel){
        
        self.groupLabel.text = modelObj.group?.name
    }

    //MARK:- Seperationg the evaluationid and groupid  of each member
    func parseTheUsersDataToGetPickerInputs(model : [MEMemberListModel]) -> ([Int],[Int]){
        for each in model{
            if let group = each.group{
            groupIdArray.append((group.groupId)!)
            }
            if let evalu = each.group?.evaluation{
                evaluationIdArray.append((evalu.eEvaluationId)!)
            }
        }
        return (groupIdArray,evaluationIdArray)
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
