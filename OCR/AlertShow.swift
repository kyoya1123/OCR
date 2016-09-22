//
//  AlertController.swift
//  OCR
//
//  Created by Family Account on 2016/09/18.
//  Copyright © 2016年 Family Account. All rights reserved.
//

import UIKit

class AlertShow {

    var OKAlert: UIAlertController!
    
    init(okTitle: String, message: String) {
     
        OKAlert = UIAlertController(title: okTitle, message:message, preferredStyle: UIAlertControllerStyle.alert)
        OKAlert.addAction(UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: {action in}
        ))
    }
    
    init(cancelTitle: String, message: String) {
        
        OKAlert = UIAlertController(title: cancelTitle, message:message, preferredStyle: UIAlertControllerStyle.alert)
        OKAlert.addAction(UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.cancel,
            handler: {action in}
        ))
    }
    
}
