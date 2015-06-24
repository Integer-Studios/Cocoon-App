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
        var request = NSMutableURLRequest(URL: NSURL(string: endpoint)!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        var error: NSError?
        println("Sending Request: " + requestURL)
        if (Cocoon.user != nil) {
            if (Cocoon.user!.facebook) {
                parameters["facebook-id"] = Cocoon.user!.authentication.username;
                parameters["facebook-token"] = Cocoon.user!.authentication.accessToken;
            } else {
                parameters["username"] = Cocoon.user!.authentication.username;
                parameters["access-token"] = Cocoon.user!.authentication.accessToken;
                
            }

        }
        
        let requestBody = NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: &error)
        if (requestBody == nil) {
            
            //error with json
            
        }
        
        request.HTTPBody = requestBody
        var errorHandlerFunction:((Error) -> ());
       
        if (errorHandler != nil) {
            
            errorHandlerFunction = errorHandler!
            
        } else {
            
            errorHandlerFunction = self.handleError
            
        }
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(),
            
            completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                self.handleResponse(requestURL, responseURL: response, data: data, error: error, debug: debug, responseHandler: responseHandler, errorHandler: errorHandlerFunction)
            })
        
    }
    
    func handleResponse(requestURL: String, responseURL: NSURLResponse!, data: NSData!, error: NSError!, debug: Bool, responseHandler: (Response) -> (), errorHandler: (Error) -> ()) {
        var error: Error?;
        var response: Response?;

        if error != nil {

            println("Error calling POST request")
            error = Error(error: 900)
        
        } else {
            var dataString = NSString(data: data, encoding:NSUTF8StringEncoding)
            var jsonError: NSError?
            let returnData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as! NSDictionary
            if jsonError != nil {
                // got an error while parsing the data, need to handle it
                if debug {
                    println("Error Parsing JSON from response string: \(dataString)")
                } else {
                    println("Error Parsing JSON From Response")
                }
                error = Error(error: 800)
                
            } else  {
                
                if let status: Int = (returnData["status"] as! String).toInt() {

                    let errorHeader: String? = (returnData["error-header"] as? String)

                    if let content: NSDictionary = (returnData["content"] as? NSDictionary) {
                        
                        if (status == 200) {
                            response = Response(contentData: content)
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                responseHandler(response!)
                            }
                        } else {
                            
                            error = Error(error: status, header: errorHeader, contentData: content)
                            
                        }
                    } else {
                        
                        if (status == 200) {
                            response = Response()
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                responseHandler(response!)
                            }
                        } else {
                            
                            error = Error(error: status, header: errorHeader)
                            
                        }
                        
                    }
                    
                } else {
                    
                    error = Error(error: 600)
                    
                }
            }
        }
        
        if (error == nil && response == nil) {
            error = Error(error:700)
            
        }
        
        if (error != nil) {
            NSOperationQueue.mainQueue().addOperationWithBlock {
                errorHandler(error!)
            }
        }
        
    }
    
    func handleError(error: Error) {
        
        println("Received Error: \(error.errorCode)")
        
    }
    
}

struct Error {
    
    var errorHeader: String?;
    var content: NSDictionary?;
    var errorCode: Int;
    
    init (error: Int, header: String? = nil) {
        
        content = nil
        errorCode = error
        errorHeader = header
        
    }
    
    init (error: Int, header: String?, contentData: NSDictionary) {
        
        if (contentData.count == 0) {
            content = nil
        } else {
            content = contentData
        }
        errorCode = error
        errorHeader = header
        
    }

}

struct Response {
    
    var content: NSDictionary?;

    init() {
        
        content = nil
        
    }
    
    init (contentData: NSDictionary) {
        
        if (contentData.count == 0) {
            content = nil
        } else {
            content = contentData
        }
        
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
