//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Royce Reynolds on 3/15/18.
//  Copyright © 2018 Royce Reynolds. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    struct Constants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        
    }
    
    //MARK: Methods
    struct Methods {
        
        // MARK: Account
        static let Default = "/session"
        static let UserData = "/users/{id}"
    }
    
    //MARK: URLKeys
    struct URLKeys {
        static let UserId = "id"
    }
    
    //MARK:
    struct ParameterKeys {
        
        // MARK: Create Session
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        
        // Facebook Keys
        static let FacebookMobile = "facebook_mobile"
        static let Token = "access_token"
        
    }
    
    //MARK: Body Keys
    struct JSONBodyKeys{
        
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        
    }
    
    //MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        //Delete Session Account Keys
        static let Account = "account"
        static let AccountRegistered = "registered"
        static let AccountKey = "key"

        //Create Session Keys
        static let Session = "session"
        static let SessionID = "id"
        static let Expiration = "expiration"
        
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
        
        
    }
}
