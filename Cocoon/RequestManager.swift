//
//  RequestHandler.swift
//  Cocoon Test 2
//
//  Created by Quinn Finney on 6/16/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import Foundation

class RequestManager {
    
    func sendRequest(requestURL: String, parameters: NSMutableDictionary, responseHandler: (AnyObject?) -> ()) {
        
        let endpoint: String = "http://cocoon.integerstudios.com" + requestURL
        var request = NSMutableURLRequest(URL: NSURL(string: endpoint)!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        var error: NSError?

        if (Cocoon.user != nil) {

            parameters["username"] = Cocoon.user!.authentication.username;
            parameters["access-token"] = Cocoon.user!.authentication.accessToken;

        }
        
        let requestBody = NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: &error)
        if (requestBody == nil) {
            
            //error with json
            
        }
        
        request.HTTPBody = requestBody
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(),
            
            completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if let anError = error {
                // got an error, need to handle it
                println("Error calling POST request")
                responseHandler([])
            } else {
                var dataString = NSString(data: data, encoding:NSUTF8StringEncoding)
//                println("Received response:" + (dataString as! String))
                var jsonError: NSError?
                let returnData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as! NSDictionary
                if let aJSONError = jsonError {
                    // got an error while parsing the data, need to handle it
                    println("Error Parsing JSON From Response")
                    responseHandler([])
                    
                } else  {

                    println(returnData.description)
                    let content: AnyObject? = returnData["content"]
                    
                    if (content != nil) {
                       
                        responseHandler(content)
                        
                    } else {
                        
                        println("No content received with response: " + returnData.description)
                    }
                    
                }
            }
        })
        
    }
    
}

extension String {
    func sha1() -> String {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)!
        var digest = [UInt8](count:Int(CC_SHA1_DIGEST_LENGTH), repeatedValue: 0)
        CC_SHA1(data.bytes, CC_LONG(data.length), &digest)
        let hexBytes = map(digest) { String(format: "%02hhx", $0) }
        return "".join(hexBytes)
    }
}
