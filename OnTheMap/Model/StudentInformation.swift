//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Royce Reynolds on 3/14/18.
//  Copyright © 2018 Royce Reynolds. All rights reserved.
//

import UIKit
import MapKit

struct StudentInformation {
    
    var objectId: String
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
    var createdAt: String
    var updatedAt: String
    var studentLocation: CLLocationCoordinate2D!
    
    
    //Initializer for StudentInformation Struct
    init(dictionary: [String: AnyObject]) {
        print(dictionary)
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        latitude = dictionary["latitude"] as! Double
        longitude = dictionary["longitude"] as! Double
        mapString = dictionary["mapString"] as! String
        objectId = dictionary["objectId"] as! String
        uniqueKey = dictionary["uniqueKey"] as! String
        mediaURL = dictionary["mediaURL"] as! String
        createdAt = dictionary["createdAt"] as! String
        updatedAt = dictionary["updatedAt"] as! String
        
        studentLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

    }
    
    var wholeName: String{
        return firstName + " " + lastName
    }
    
    static func addStudentFromAPI(_ dictionary: [[String:AnyObject]]) -> [StudentInformation]{
        
        var students = [StudentInformation]()
        
        for student in dictionary{
            students.append(StudentInformation(dictionary: student))
        }
        
        return students
    }
    
}
