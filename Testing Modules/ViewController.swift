//
//  ViewController.swift
//  Testing Modules
//
//  Created by Olivier Butler on 21/09/2017.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    let motionManager = CMMotionManager()
    let screenSize = UIScreen.main.bounds
    
    @IBOutlet weak var xDataView: UIView!
    @IBOutlet weak var yDataView: UIView!
    @IBOutlet weak var zDataView: UIView!
    
    func logData(_ data:CMGyroData?, error:Error?){
        if let _ = data{
            let xData = data!.rotationRate.x
            let yData = data!.rotationRate.y
            let zData = data!.rotationRate.z
            xDataView.frame.size.width = convertToWidthFromAngle(xData)
            yDataView.frame.size.width = convertToWidthFromAngle(yData)
            zDataView.frame.size.width = convertToWidthFromAngle(zData)
        }
    }
    
    func convertToWidthFromAngle (_ angle: Double) -> CGFloat{
        var output = CGFloat(abs(angle/5))
        output = (self.screenSize.width - CGFloat(10)) * output
        print(output)
        return output + CGFloat(20)
    }
    
    func setupGyro(){
        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 0.02
            motionManager.startGyroUpdates(to: OperationQueue.main, withHandler: logData)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGyro()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

