//
//  ViewController.swift
//  StatusKit
//
//  Created by xaoxuu on 09/11/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
//        StatusKit.customStatusBar.layer.backgroundColor = UIColor.yellow.cgColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        StatusKit.customStatusBar.layer.showColorAnimation(color: .red, duration: 1, repeatCount: 10)
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        StatusKit.customStatusBar.layer.hideColorAnimation()
//    }

    @IBAction func btn(_ sender: UIButton) {
        switch sender.tag {
        case 10:
            StatusKit.showStatusBarMessage(message: (sender.titleLabel?.text)!, textColor: .black, backgroundColor: .yellow, duration: 3)
        case 11:
            StatusKit.showStatusBarMessage(message: (sender.titleLabel?.text)!, textColor: .white, backgroundColor: .red, duration: 5)
        case 12:
            StatusKit.showStatusBarMessage(message: (sender.titleLabel?.text)!, textColor: .white, backgroundColor: .red, duration: 10)
        case 13:
            StatusKit.showStatusBarProgressMessage(message: (sender.titleLabel?.text)!, textColor: .black, backgroundColor: .white, duration: 3)
        case 21:
            StatusKit.customStatusBar.layer.showColorAnimation(color: .red, duration: 1, repeatCount: 10)
        case 22:
            StatusKit.customStatusBar.layer.showColorAnimation(color: .yellow, duration: 1, repeatCount: 10)
        case 23:
            StatusKit.customStatusBar.layer.hideColorAnimation()
            
        default:
            StatusKit.showStatusBarProgressMessage(message: (sender.titleLabel?.text)!, textColor: .black, backgroundColor: .white, duration: 3)
        }
    }
    
    
}

