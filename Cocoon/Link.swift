//
//  Link.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/24/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import Foundation

class Link {
    
    var id: Int
    var type: String
    var displayName: String
    
    init(id : Int, type : String, displayName: String) {
        
        self.id = id
        self.type = type
        self.displayName = displayName
        
    }
    
    static func unwrapKid(kid : NSMutableDictionary) -> Link {
        return Link(id: (kid["id"] as! String).toInt()!, type: "kid", displayName: kid["first-name"] as! String)
    }
    
    static func unwrapFamily(fam : NSMutableDictionary) -> Link {
        return Link(id: (fam["id"] as! String).toInt()!, type: "family", displayName: fam["name"] as! String)
    }
    
    static func unwrapFriend(friend : NSMutableDictionary) -> Link {
        return Link(id: (friend["id"] as! String).toInt()!, type: "friend", displayName: friend["name"] as! String)
    }
    
    static func unwrapGroup(group : NSMutableDictionary) -> Link {
        return Link(id: (group["id"] as! String).toInt()!, type: "group", displayName: group["name"] as! String)
    }
}