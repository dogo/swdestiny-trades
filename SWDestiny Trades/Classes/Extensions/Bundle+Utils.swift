//
//  Bundle+Utils.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 11/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation

extension Bundle {
    
    var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as! String
    }
 
    var buildVersionNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }
}
