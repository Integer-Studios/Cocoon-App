//
//  ResponseManager.swift
//  Cocoon
//
//  Created by Quinn Finney on 6/24/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import Foundation

class ResponseManager {
    
    func handleResponse(request: Request, responseURL: NSURLResponse!, data: NSData!, error: NSError!) {
        var error: Error?;
        var response: Response?;
        
        if error != nil {
            
            println("Error calling POST request")
            error = Error(requestObject: request, error: 900)
            
        } else {
            var dataString = NSString(data: data, encoding:NSUTF8StringEncoding)
//            println(dataString)
            var jsonError: NSError?
            let returnData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as! NSDictionary
            if jsonError != nil {
                // got an error while parsing the data, need to handle it
                if request.debug {
                    println("Error Parsing JSON from response string: \(dataString)")
                } else {
                    println("Error Parsing JSON From Response")
                }
                error = Error(requestObject: request, error: 800)
                
            } else  {
                
                if let status: Int = (returnData["status"] as! String).toInt() {
                    
                    let errorHeader: String? = (returnData["error-header"] as? String)
                    
                    if let content: NSDictionary = (returnData["content"] as? NSDictionary) {
                        
                        if (status == 200) {
                            response = Response(requestObject: request, contentData: content)
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                request.responseHandler(response!)
                            }
                        } else {
                            
                            error = Error(requestObject: request, error: status, header: errorHeader, contentData: content)
                            
                        }
                    } else {
                        
                        if (status == 200) {
                            response = Response(requestObject: request)
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                request.responseHandler(response!)
                            }
                        } else {
                            
                            error = Error(requestObject: request, error: status, header: errorHeader)
                            
                        }
                        
                    }
                    
                } else {
                    
                    error = Error(requestObject: request, error: 600)
                    
                }
            }
        }
        
        if (error == nil && response == nil) {
            error = Error(requestObject: request, error:700)
            
        }
        
        if (error != nil) {
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.handleError(request, error: error!)
            }
        }
        
    }
    
    func handleError(request: Request, error: Error) {
        
        println("Received Error: \(error.errorCode)")
        
        if (request.errorHandler != nil) {
            
            request.errorHandler!(error)
            
        } else {
            
            println("Not Handled...")
            
        }
        
    }
    
}

struct Error {
    
    var errorHeader: String?;
    var content: NSDictionary?;
    var errorCode: Int;
    var request: Request;
    
    init (requestObject: Request, error: Int, header: String? = nil) {
        
        content = nil
        errorCode = error
        errorHeader = header
        request = requestObject
    }
    
    init (requestObject: Request, error: Int, header: String?, contentData: NSDictionary) {
        
        if (contentData.count == 0) {
            content = nil
        } else {
            content = contentData
        }
        errorCode = error
        errorHeader = header
        request = requestObject
        
    }
    
}

struct Response {
    
    var content: NSDictionary?;
    var request: Request;
    
    init(requestObject: Request) {
        
        content = nil
        request = requestObject

    }
    
    init (requestObject: Request, contentData: NSDictionary) {
        
        if (contentData.count == 0) {
            content = nil
        } else {
            content = contentData
        }
        request = requestObject
        
    }
    
}
