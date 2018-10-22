//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Royce Reynolds on 3/15/18.
//  Copyright © 2018 Royce Reynolds. All rights reserved.
//

import Foundation

extension ParseClient {
    
    struct Constants {
        
        //MARK: PARSE Api constants
        static let ParseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
    }
    
    struct ApiHeaders {
        static let ParseAppID = "X-Parse-Application-Id"
        static let RESTAPIKey = "X-Parse-REST-API-Key"
    }
    
    struct Methods {
        static let StudentLocation = "/StudentLocation"
        static let PutStudentLocation = "/StudentLocation/{objectId}"
    }
    
    struct URLKeys {
        static let ObjectID = "objectId"
    }
    
    struct ParameterKeys{
        
        //Single Student
        static let Where = "where"
        
        //List of Students
        static let FetchLimit = "limit"
        static let Skip = "skip"
        static let ReturnOrder = "order"
    }
    
    struct JSONParameterKeys{
        
        static let Results = "results"
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
        
    }
    
    struct JSONResponseKeys{
        
        static let Results = "results"
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
    }
}
