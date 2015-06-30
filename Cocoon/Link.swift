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
            openKid(viewController)
            break
        case "family":
            openFamily(viewController)
            break
        case "friend":
            openFriend(viewController)
            break
        case "group":
            openGroup(viewController)
            break
        case "vehicle":
            openVehicle(viewController)
            break
        case "menu":
            handleMenuLink(viewController)
            break
        case "family.menu":
            handleFamilyLink(viewController)
            break
        default:
            print("No handler for link type: ")
            println(self.type)
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
        case 1:
            //add car
            (viewController.navigationController as! NavigationController).pushView("registerVehicle")
            println("so you want to add a car...")
            break
        default:
            break
        }
    }
    
    func openKid(viewController: UIViewController) {
        present(viewController, identifier: "kid")
    }
    
    func openFamily(viewController: UIViewController) {
        println("open family stub")
        //reload family page with new family data
    }
    
    func openFriend(viewController: UIViewController) {
        present(viewController, identifier: "user")
    }
    
    func openGroup(viewController: UIViewController) {
        present(viewController, identifier: "group")
    }
    
    func openVehicle(viewController: UIViewController) {
        present(viewController, identifier: "vehicle")
    }
    
    func present(viewController: UIViewController, identifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var vc = storyboard.instantiateViewControllerWithIdentifier(identifier) as! UIViewController
        viewController.presentViewController(vc, animated: true, completion: nil)
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
    
    static func unwrapVehicle(vehicle : NSMutableDictionary) -> Link {
        return Link(id: (vehicle["id"] as! String).toInt()!, type: "vehicle", displayName: vehicle["name"] as! String)
    }
}