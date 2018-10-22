//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Royce Reynolds on 3/21/18.
//  Copyright © 2018 Royce Reynolds. All rights reserved.
//

import Foundation
import CoreLocation

extension ParseClient {
    
    func getUserData(completionHandlerForUser: @escaping (_ success: Bool, _ error: NSError?) -> Void){
        
        let parameters = [ParseClient.ParameterKeys.FetchLimit: "15", ParseClient.ParameterKeys.ReturnOrder: "-\(ParseClient.JSONParameterKeys.CreatedAt)"] as [String:AnyObject]
        
        let apiMethod = ParseClient.Methods.StudentLocation
        
        //print("Session ID is: \(UdacityClient.sharedInstance().sessionId!)")
        
        let _ = taskForGETMethod(apiMethod, parameters: parameters) { (result, error) in
            if let error = error{
                completionHandlerForUser(false, error)
            }else{
                guard let results = result?[ParseClient.JSONResponseKeys.Results] as? [[String:AnyObject]] else{
                    print("Messed up")
                    return
                }
                
                self.studentInformation = StudentInformation.addStudentFromAPI(results)
                completionHandlerForUser(true, nil)
            }
        }
    }
    
    func postUserData(_ hyperlink: URL?, _ mapString: String?, _ placemark: CLPlacemark?, completionHandlerForPost: @escaping (_ success: Bool, _ error: NSError?) -> Void){
        
        let userData = "{\"uniqueKey\": \"\(UdacityClient.sharedInstance().sessionId!)\", \"firstName\": \"\(UdacityClient.sharedInstance().firstName!)\", \"lastName\": \"\(UdacityClient.sharedInstance().lastName!)\",\"mapString\": \"\(mapString!)\", \"mediaURL\": \"\(hyperlink!)\",\"latitude\": \(placemark!.location!.coordinate.latitude), \"longitude\": \(placemark!.location!.coordinate.longitude)}"
        
        print(userData)
        
        let apiMethod = ParseClient.Methods.StudentLocation
        let parameters = [String:AnyObject]()
        
        let _ = taskForPOSTMethod(apiMethod, parameters: parameters, jsonBody: userData) { (result, error) in
            if let error = error{
                completionHandlerForPost(false, error)
            }else{
                completionHandlerForPost(true, nil)
            }
        }
        
        //let jsonBody =  "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
    }
    
    
}
