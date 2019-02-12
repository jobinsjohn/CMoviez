//
//  CFlixDefaultWrappers.swift
//  CMoviez
//
//  Created by Jobins John on 4/24/18.
//  Copyright © 2018 Jobins John. All rights reserved.
//

import UIKit

class CFlixDefaultWrappers: NSObject {
    func showAlert(info:String, viewController: UIViewController){ 
        let popUp = UIAlertController(title: APP_NAME, message: info, preferredStyle: UIAlertControllerStyle.alert)
        popUp.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {alertAction in popUp.dismiss(animated: true, completion: nil)}))
        viewController.present(popUp, animated: true, completion: nil)
    }
}
