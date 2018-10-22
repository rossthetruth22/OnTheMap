//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Royce Reynolds on 3/15/18.
//  Copyright © 2018 Royce Reynolds. All rights reserved.
//

import UIKit

class UdacityClient: NSObject {
    
    //Shared session
    let session = URLSession.shared
    
    //Authentication state
    var sessionId : String? = nil
    var userID : String? = nil
    
    var firstName : String? = nil
    var lastName : String? = nil
    
    
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        //Set up parameters
        let parametersForAPI = parameters
        
        //1. Build the URL and configure the request
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api" + method)!)
        
        //2. Make the request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            //Is there an error with the request?
            guard (error == nil) else{
                print("There was an error in the get request: \(String(describing: error))")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else{
                print("There was no statusCode returned")
                return
            }
            
            guard let data = data else{
                print("There was no data for your request")
                return
            }
            
            let newData = data.subdata(in: 5..<data.count)
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        task.resume()
        
        return task
        
    }
    
    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask{
        
        let parametersForAPI = parameters
        
        //1. Build the URL and configure the request
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        
        //print(request)
        
        //print(jsonBody)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: (request as URLRequest)) { (data, response, error) in
            //Is there an error with the request?
            guard (error == nil) else{
                print("There was an error in the post request: \(String(describing: error))")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else{
                print("There was no statusCode returned")
                return
            }
            
            print(statusCode)
            guard let data = data else{
                print("There was no data for your request")
                return
            }
            
            //let range = NSMakeRange(5, data.count - 5)
            //let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            let newData = data.subdata(in: 5..<data.count)
            
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
        }
        task.resume()
        
        return task
    }
    
    func taskForDELETEMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForDELETE: @escaping (_ result: AnyObject?, _ error: NSError?)-> Void) -> URLSessionDataTask{
        
        let parametersForAPI = parameters
        
        //1. Build the URL and configure the request
        let request = NSMutableURLRequest(url: udacityURLFromParameters(parametersForAPI, withPathExtension: method))
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            //Is there an error with the request?
            guard (error == nil) else{
                print("There was an error in the delete request: \(String(describing: error))")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else{
                print("There was no statusCode returned")
                return
            }
            
            
            guard let data = data else{
                print("There was no data for your request")
                return
            }
            
            let newData = data.subdata(in: 5..<data.count)
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForDELETE)
        }
        
        task.resume()
        
        return task
    }
    
    // MARK: Helpers
    
    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    
    // create a URL from parameters
    private func udacityURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        components.path = UdacityClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        print(components.url!)
        return components.url!
    }
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }

}
