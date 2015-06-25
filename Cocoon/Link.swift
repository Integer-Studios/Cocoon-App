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
    
    func open(viewController: UIViewController) {
        switch type {
        case "kid":
            break
        case "family":
            break
        case "friend":
            break
        case "group":
            break
        case "menu":
            handleMenuLink(viewController)
            break
        case "family.menu":
            handleFamilyLink(viewController)
            break
        default:
            break
        }
    }
    
    func handleMenuLink(viewController: UIViewController) {
        viewController.performSegueWithIdentifier("push\(id)", sender: nil)
    }
    
    func handleFamilyLink(viewController: UIViewController) {
        switch id {
        case 0:
            //add kid
            (viewController.navigationController as! NavigationController).pushView("registerKid")
            println("so you want to add a kid...")
            break
        default:
            break
        }
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