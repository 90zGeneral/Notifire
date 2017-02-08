//
//  ViewController.swift
//  Notifire
//
//  Created by Roydon Jeffrey on 2/4/17.
//  Copyright © 2017 Italyte. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register notifications when view loads
        FIRMessaging.messaging().subscribe(toTopic: "/topics/news")
    }
}

