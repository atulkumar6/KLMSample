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
        let cntrl = storyboard.instantiateViewController(withIdentifier:str)
        return cntrl
    }
}
