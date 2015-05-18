//
//  GetActivityService.swift
//  TURides
//
//  Created by Dennis Hui on 1/05/15.
//
//

import UIKit

@objc protocol GetActivityServiceDelegate {
    func handleGetActivityServiceSuccess(activities: [CheckInActivity])
    optional func handleGetActivityServiceServiceFail()
}

class GetActivityService: Service {
 
    var delegate: GetActivityServiceDelegate
    var acitvitiesArray: [CheckInActivity]
    
    struct mConstant {
        static let url = "http://54.206.6.242/app_dev.php/en/api/v1/user/checkin.json"
    }
    
    init(delegate: GetActivityServiceDelegate) {
        self.delegate = delegate;
        self.acitvitiesArray = Array()
    }
    
    func dispathWithParams(params: NSDictionary) {
        Command(params: params, delegate: self, url: mConstant.url).get()
    }
    
    private func extractResult(json: JSON) {
        if let activityArray = json.array {
            for activityDict in activityArray {
                var id: NSNumber! = activityDict["id"].number
                
                var userID: NSNumber! = (activityDict["user"]["id"]).number
                var userName: String! = (activityDict["user"]["name"]).string
                var user = User(id: userID.stringValue, name: userName, email: userName, profileIcon: UIImage())
                
                var googlePlaceID: String! = activityDict["checkin_reference"].string
                var googlePlaceName: String! = activityDict["checkin_name"].string
                var googlePlaceAddress: String! = activityDict["checkin_name"].string
                    
                var googlePlace = GooglePlace(id: googlePlaceID, name: googlePlaceName, address: googlePlaceAddress)
                
                var numberOfLikes: NSNumber! = activityDict["like_count"].number
                
                var checkInActivity = CheckInActivity(user: user, id: id.stringValue, place: googlePlace,numberOfLikes: numberOfLikes)
                    
                if let message: String? = activityDict["comment"].string {
                    checkInActivity.message = message
                }
                
                if let commentsArray = activityDict["children"].array {
                    for commentDict in commentsArray {
                        var id: NSNumber! = commentDict["id"].number
                        var userID: NSNumber! = (commentDict["user"]["id"]).number
                        var userName: String! = (commentDict["user"]["name"]).string
                        var fromUser = User(id: id.stringValue, name: userName, email: userName, profileIcon: UIImage())
                        var message: String! = commentDict["comment"].string
                        
                        var comment = Comment(fromUser: fromUser, toUser: fromUser, message: message)
                        
                        checkInActivity.comments.append(comment)
                    }
                }
                
                acitvitiesArray.append(checkInActivity)
                
            }
        }
    }
    
    
    
    override func successCallback(responseObject: AnyObject) {
        println(responseObject)
        
        let json = JSON(responseObject)
        extractResult(json)
        
        
        delegate.handleGetActivityServiceSuccess(acitvitiesArray)
        
        
    }
    
    override func failCallback(responseObject: AnyObject) {
        
    }
}
