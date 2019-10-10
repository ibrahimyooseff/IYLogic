//
//  extensions.swift
//  IYLogic
//
//  Created by RMS on 2019/10/7.
//  Copyright © 2019 IYLogic. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    
    static let username = DefaultsKey<String?>("username", defaultValue: "")
    static let email = DefaultsKey<String?>("email", defaultValue: "")
    static let pwd = DefaultsKey<String?>("pwd", defaultValue: "")
    
}

extension String {
    
    public var trimmed: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

}
