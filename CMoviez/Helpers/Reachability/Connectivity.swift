//
//  Connectivity.swift
//  CMoviez
//
//  Created by Jobins John on 4/19/18.
//  Copyright © 2018 Jobins John. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
