//
//  RequestHandler.swift
//  Cocoon Test 2
//
//  Created by Quinn Finney on 6/16/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import Foundation

class RequestManager {
    
    func sendRequest(requestURL: String, parameters: NSMutableDictionary, debug: Bool = false, responseHandler: (Response) -> (), errorHandler: ((Error) -> ())?)  {
        
        let endpoint: String = "http://cocoon.integerstudios.com" + requestURL
        let parameters = authenticateParameters(parameters)
        var error: NSError?
        let urlRequest = generateRequest(endpoint, parameters: parameters)
        let request = Request(url: requestURL, responseHandler: responseHandler, errorHandler: errorHandler, debug: debug, parameters: parameters)

        print("Sending Request: " + requestURL)
        if request.debug {
            
            print("With Parameters: " + parameters.description)
            
        }
                
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue(),
            
            completionHandler: { (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
               
                Cocoon.responseManager.handleResponse(request, responseURL: response, data: data, error: error)
            })
        
    }
    
    func generateRequest(endpoint: String, parameters: NSMutableDictionary) -> NSMutableURLRequest {
        
        let request = NSMutableURLRequest(URL: NSURL(string: endpoint)!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        var error: NSError?;
        let requestJSON: NSData?
        do {
            requestJSON = try NSJSONSerialization.dataWithJSONObject(parameters, options: [])
        } catch let error1 as NSError {
            error = error1
            requestJSON = nil
        }
        if (requestJSON == nil) {
            
            //error with json
            
        }
        
        request.HTTPBody = requestJSON
        return request
        
    }
    
    func authenticateParameters(parameters: NSMutableDictionary) -> NSMutableDictionary {
        
        if (Cocoon.user != nil) {
            if (Cocoon.user!.facebook) {
                if (parameters["facebook-id"] == nil) {
                    parameters["facebook-id"] = Cocoon.user!.authentication.username;
                    parameters["facebook-token"] = Cocoon.user!.authentication.accessToken;
                }
            } else {
                if (parameters["username"] == nil) {
                    parameters["username"] = Cocoon.user!.authentication.username;
                    parameters["access-token"] = Cocoon.user!.authentication.accessToken;
                }
            }
        }
        
        return parameters
        
    }
        
}

struct Request {
    
    var url: String;
    var responseHandler: (Response) -> ();
    var errorHandler: ((Error) -> ())?;
    var debug: Bool;
    var parameters: NSMutableDictionary;
    
}

extension String {
    func sha1() -> String {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)!
        var digest = [UInt8](count:Int(CC_SHA1_DIGEST_LENGTH), repeatedValue: 0)
        CC_SHA1(data.bytes, CC_LONG(data.length), &digest)
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joinWithSeparator("")
    }
}
