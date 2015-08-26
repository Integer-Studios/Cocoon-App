//
//  Definitions.swift
//  Cocoon
//
//  Created by Quinn Finney on 8/6/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import Foundation

struct SycamoreConstants {
    
    static let kCallbackURI = "Cocoon://token_received"
    static let kClientID = "55ae9eaa68c65"
    static let kClientSecret = "22e4cc122f9a128a46308515f856538f"
    
    static let kStudentScopes = "general individual"
    static let kFamilyScopes = "general individual"
    static let kEmployeeScopes = "classes families superuser general individual"
    
    static func kAuthURL(encoded_scopes: String, encoded_callback: String) -> String {
        
        return "https://app.sycamoreeducation.com/oauth/authorize.php?client_id=\(kClientID)&redirect_uri=\(encoded_callback)&scope=\(encoded_scopes)&response_type=token"
        
    }

    
}