//
//  Utilites.swift
//  Flash Chat
//
//  Created by NZ on 05.11.17.
//  Copyright © 2017 London App Brewery. All rights reserved.
//

import Foundation
import UIKit

class Utilites {
    
    func errorAlert (text: String, title: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alert.addAction(action)
        vc.present(alert, animated: true, completion: nil)
    }
}
