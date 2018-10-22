//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Royce Reynolds on 3/16/18.
//  Copyright © 2018 Royce Reynolds. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    
    func createSession(_ username: String, _ password: String, completionHandlerForSession: @escaping (_ success: Bool,  _ error: NSError? ) -> Void){
        
        /* 1. Specify parameters, the API method, and the HTTP body (if POST) */
        
        let parameters = [String:AnyObject]()
        
        let apiMethod = UdacityClient.Methods.Default
        
        let jsonBody =  "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        /* 2. Make the request */
        let _ = taskForPOSTMethod(apiMethod, parameters: parameters, jsonBody: jsonBody) { (result, error) in
            /* 3. Send the desired value(s) to completion handler */
            if let error = error{
                completionHandlerForSession(false, error)
            }else{
                
                //print(result)
                if let results = result?[UdacityClient.JSONResponseKeys.Account] as? [String:AnyObject]{
                    if let accountId = results[UdacityClient.JSONResponseKeys.AccountKey] as? String{
                        self.sessionId = accountId
                        
                        //print(self.sessionId)
                        self.getUserData(completionHandlerForUser: { (success, first, last, error) in
                            if success{
                                if let first = first, let last = last{
                                    self.firstName = first
                                    self.lastName = last
                                }
                                completionHandlerForSession(success, error)
                            }else{
                                completionHandlerForSession(success, error)
                            }
                        })
                    }
                }else{
                    completionHandlerForSession(false, NSError(domain: "createSession parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse createSession"]))
                    
                }
            }
        }
    }
    
    func logout(completionHandlerForLogout: @escaping (_ success: Bool, _ sessionId: String?, _ error: NSError?) -> Void){
        
        let parameters = [String:AnyObject]()
        
        let apiMethod = UdacityClient.Methods.Default
        
        let _ = taskForDELETEMethod(apiMethod, parameters: parameters) { (result, error) in
            if let error = error{
                completionHandlerForLogout(false, nil, error)
            }else{
                if let results = result?[UdacityClient.JSONResponseKeys.Session] as? [String:AnyObject]{
                    if let sessionId = results[UdacityClient.JSONResponseKeys.SessionID] as? String{
                        completionHandlerForLogout(true, sessionId, nil)
                    }
                }else{
                    completionHandlerForLogout(false, nil, NSError(domain: "logout parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse logout"]))
                }
            }
        }
    }
    
    func getUserData(completionHandlerForUser: @escaping (_ success: Bool, _ first: String?, _ last: String?, _ error: NSError?) -> Void){
        
        let parameters = [String:AnyObject]()
        
        let apiMethod = UdacityClient.Methods.UserData
        
        print("Session ID is: \(UdacityClient.sharedInstance().sessionId!)")
        
        let _ = taskForGETMethod(substituteKeyInMethod(apiMethod, key: UdacityClient.URLKeys.UserId, value: UdacityClient.sharedInstance().sessionId!)!, parameters: parameters) { (result, error) in
            if let error = error{
                completionHandlerForUser(false, nil, nil, error)
            }else{
                guard let results = result?[UdacityClient.JSONResponseKeys.User] as? [String:AnyObject] else{
                    print("Messed up")
                    return
                }
                
                guard let firstName = results[UdacityClient.JSONResponseKeys.FirstName] as? String else{
                    print("messed up ferstname")
                    return
                }
                
                guard let lastName = results[UdacityClient.JSONResponseKeys.LastName] as? String else{
                    print("messed up lastname")
                    return
                }
                
                completionHandlerForUser(true, firstName, lastName, nil)
            }
        }
    }
}
