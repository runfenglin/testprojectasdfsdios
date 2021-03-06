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
        static let URL = "user/activity.json"
    }
    
    init(delegate: GetActivityServiceDelegate) {
        self.delegate = delegate;
        self.acitvitiesArray = Array()
    }
    
    func dispathWithParams(params: NSDictionary) {
        Command(params: params, delegate: self, url: mConstant.URL).get()
    }
    
    private func extractResult(json: JSON) {
        if let activityArray = json.array {
            for activityDict in activityArray {
                var id: NSNumber! = activityDict["id"].number
                
                let userID: NSNumber! = (activityDict["user"]["id"]).number
                let userName: String! = (activityDict["user"]["name"]).string
                let user = User(id: userID.stringValue, name: userName, email: userName, profileIcon: UIImage())
                
                if let userAvatar = (activityDict["user"]["avatar"]).string {
                    let decodedData = NSData(base64EncodedString: userAvatar, options: NSDataBase64DecodingOptions(rawValue: 0))
                    user.profileIcon =  UIImage(data: decodedData!)!
                }
                
                let googlePlaceID: String! = activityDict["checkin_reference"].string
                let googlePlaceName: String! = activityDict["checkin_name"].string
                let googlePlaceAddress: String! = activityDict["checkin_name"].string
                    
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
