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
        case "post":
            openPost(viewController)
            break
        case "menu":
            handleMenuLink(viewController)
            break
        case "family.menu":
            handleFamilyLink(viewController)
            break
        case "groups.menu":
            handleGroupsLink(viewController)
            break
        default:
            print("No handler for link type: ", terminator: "")
            print(self.type)
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
            print("so you want to add a kid...")
            break
        case 1:
            //add car
            (viewController.navigationController as! NavigationController).pushView("registerVehicle")
            print("so you want to add a car...")
            break
        default:
            break
        }
    }
    
    func handleGroupsLink(viewController: UIViewController) {
        switch id {
        case 0:
            //create a group
            (viewController.navigationController as! NavigationController).pushView("registerGroup")
            print("so you want to make a group...")
            break
        default:
            break
        }
    }
    
    func openKid(viewController: UIViewController) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewControllerWithIdentifier("kid") 
        let vc = nav.childViewControllers[0] as! KidViewController
        vc.setKid(id)
        viewController.presentViewController(nav, animated: true, completion: nil)
        
    }
    
    func openFamily(viewController: UIViewController) {
        print("open family stub")
        //reload family page with new family data
    }
    
    func openFriend(viewController: UIViewController) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewControllerWithIdentifier("user") 
        let vc = nav.childViewControllers[0] as! UserViewController
        vc.setUser(id)
        viewController.presentViewController(nav, animated: true, completion: nil)
        
    }
    
    func openGroup(viewController: UIViewController) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewControllerWithIdentifier("group") 
        let vc = nav.childViewControllers[0] as! GroupViewController
        vc.setGroup(id)
        viewController.presentViewController(nav, animated: true, completion: nil)
        
    }
    
    func openVehicle(viewController: UIViewController) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewControllerWithIdentifier("vehicle") 
        let vc = nav.childViewControllers[0] as! VehicleViewController
        vc.setVehicle(id)
        viewController.presentViewController(nav, animated: true, completion: nil)
        
    }
    
    func openPost(viewController: UIViewController) {
        
        print("No view controller for posts yet!")
        
    }
    
    
    static func unwrapKid(kid : NSMutableDictionary) -> Link {
        return Link(id: Int((kid["id"] as! String))!, type: "kid", displayName: kid["first-name"] as! String)
    }
    
    static func unwrapFamily(fam : NSMutableDictionary) -> Link {
        return Link(id: Int((fam["id"] as! String))!, type: "family", displayName: fam["name"] as! String)
    }
    
    static func unwrapFriend(friend : NSMutableDictionary) -> Link {
        return Link(id: Int((friend["id"] as! String))!, type: "friend", displayName: friend["name"] as! String)
    }
    
    static func unwrapGroup(group : NSMutableDictionary) -> Link {
        return Link(id: Int((group["id"] as! String))!, type: "group", displayName: group["name"] as! String)
    }
    
    static func unwrapVehicle(vehicle : NSMutableDictionary) -> Link {
        return Link(id: Int((vehicle["id"] as! String))!, type: "vehicle", displayName: vehicle["name"] as! String)
    }
}

class DetailedLink : Link {
    
    var info: [String]
    
    init(id : Int, type : String, info: [String]) {
        
        self.info = info
        super.init(id: id, type: type, displayName: "")
        
    }
    
    static func unwrapEvent(event : NSMutableDictionary) -> DetailedLink {
        return DetailedLink(id: Int((event["id"] as! String))!, type: "event", info: [event["title"] as! String, event["date"] as! String])
    }
    
}