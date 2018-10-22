//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Royce Reynolds on 3/15/18.
//  Copyright © 2018 Royce Reynolds. All rights reserved.
//

import UIKit

class ParseClient: NSObject {
    
    let session = URLSession.shared
    
    var studentInformation: [StudentInformation]
    
    
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        //Set up parameters
        let parametersForAPI = parameters
        
        let apiMethod = method
        
        //1. Build the URL and configure the request
        let request = NSMutableURLRequest(url: parseURLFromParameters(parametersForAPI, withPathExtension: apiMethod))
        
        request.addValue(ParseClient.Constants.ParseAppID, forHTTPHeaderField: ParseClient.ApiHeaders.ParseAppID)
        request.addValue(ParseClient.Constants.RESTAPIKey, forHTTPHeaderField: ParseClient.ApiHeaders.RESTAPIKey)
        
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
            
            //let newData = data.subdata(in: 5..<data.count)
            
            //print("SCREAM")
            
            //print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        task.resume()
        
        return task
        
    }
    
    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask{
        
        let parametersForAPI = parameters
        
        //1. Build the URL and configure the request
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        
        //print(request)
        
        //print(jsonBody)
        
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
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
    private func parseURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = ParseClient.Constants.ApiScheme
        components.host = ParseClient.Constants.ApiHost
        components.path = ParseClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        print(components.url!)
        return components.url!
    }
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
    override init() {
        
        studentInformation = [StudentInformation]()
        super.init()
    }


}
