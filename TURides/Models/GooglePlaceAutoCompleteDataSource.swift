//
//  GooglePlaceAutoCompleteDataSource.swift
//  TURides
//
//  Created by Dennis Hui on 20/05/15.
//
//

import UIKit

class GooglePlaceAutoCompleteDataSource: NSObject, MLPAutoCompleteTextFieldDataSource {
 
    func autoCompleteTextField(textField: MLPAutoCompleteTextField!, possibleCompletionsForString string: String!) -> [AnyObject]! {
        return nil
    }
    
    func autoCompleteTextField(textField: MLPAutoCompleteTextField!, possibleCompletionsForString string: String!, completionHandler handler: (([AnyObject]!) -> Void)!) {
        
    }
    
}
