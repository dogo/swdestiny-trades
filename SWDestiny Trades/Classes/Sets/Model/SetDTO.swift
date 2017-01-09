//
//  SetDTO.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import Foundation
import ObjectMapper

class SetDTO: Mappable {

    var name: String = ""
    var code: String = ""

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        name <- map["name"]
        code <- map["code"]
    }
}
