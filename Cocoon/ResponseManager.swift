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
            
            print("Error calling POST request")
            error = Error(requestObject: request, error: 900)
            
        } else {
            let dataString = NSString(data: data, encoding:NSUTF8StringEncoding)
            if (request.debug) {
                print(dataString)
            }
            let jsonError: NSError?
            do {
            let returnData: NSDictionary? = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary
            
//            if jsonError != nil {
//                // got an error while parsing the data, need to handle it
//                if request.debug {
//                    print("Error Parsing JSON from response string: \(dataString)")
//                } else {
//                    print("Error Parsing JSON From Response")
//                }
//                error = Error(requestObject: request, error: 800)
//                
//            } else  {
//                
                if request.debug {
                    
                    print("Received Response from Server: \(returnData!.description)")
                    
                }
                
                if (returnData != nil) {
                    
                if let status: Int = Int((returnData!["status"] as! String)) {
                    
                    let errorHeader: String? = (returnData!["error-header"] as? String)
                    
                    if let content: NSDictionary? = (returnData!["content"] as? NSDictionary) {
                        
                        if (status == 200) {
                            if (content != nil) {
                                response = Response(requestObject: request, contentData: content!)
                            } else {
                                response = Response(requestObject: request, contentData: NSDictionary())
                            }
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                request.responseHandler(response!)
                            }
                        } else {
                            if (content != nil) {
                                error = Error(requestObject: request, error: status, header: errorHeader, contentData: content!)
                            } else {
                                error = Error(requestObject: request, error: status, header: errorHeader, contentData: NSDictionary())
                            }
                            
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
                    
                } else {
                    
                    error = Error(requestObject: request, error: 600)
                    
                }
                
            
            } catch {
                print("Json Error")
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
        
        print("Received Error: \(error.errorCode)")
        
        if (request.errorHandler != nil) {
            
            request.errorHandler!(error)
            
        } else {
            
            print("Not Handled...")
            
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
