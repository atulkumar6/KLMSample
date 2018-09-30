//
//  Helper.swift
//  KLMDemo
//
//  Created by Atul Kumar on 9/11/18.
//  Copyright © 2018 Atul Kumar. All rights reserved.
//

import Foundation
import UIKit

// This class contains static functions
class Helper {
    static func getControllerInstance(_ str: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controllerInstance = storyboard.instantiateViewController(withIdentifier:str)
        return controllerInstance
    }
    static func readPlist() -> [Dictionary<String,NSNumber>]? {
        guard let path = Bundle.main.path(forResource: "Coordinate", ofType: "plist") else {
            return nil
        }
        let itemArray = NSArray(contentsOfFile: path)
        // bridging NSArray to Swift Array
        return itemArray as? [Dictionary<String,NSNumber>]
    }
}
