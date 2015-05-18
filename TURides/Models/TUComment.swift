//
//  TUComment.swift
//  TURides
//
//  Created by Dennis Hui on 12/05/15.
//
//

import UIKit

class TUComment: NSObject {
    var commentID: String
    var commentMessage: String
    var toUserID: String
    var fromUserID: String
    var parentActivityID: String
    
    init(commentID: String, commentMessage: String, toUserID: String, fromUserID: String, parentActivityID: String) {
        self.commentID = commentID
        self.commentMessage = commentMessage
        self.toUserID = toUserID
        self.fromUserID = fromUserID
        self.parentActivityID = parentActivityID
    }
    
//    init(json: NSDictionary) {
//        self.commentID = json.objectForKey("") as! String
//        self.commentMessage = json.objectForKey("") as! String
//    }
}
