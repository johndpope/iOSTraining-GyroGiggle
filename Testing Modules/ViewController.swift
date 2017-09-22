//
//  ViewController.swift
//  Testing Modules
//
//  Created by Olivier Butler on 21/09/2017.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

import UIKit
import CoreMotion
import SceneKit

class ViewController: UIViewController {
    let motionManager = CMMotionManager()
    var boxNode:SCNNode?
    var gyroCache = [
        "xCol": [Float](),
        "yCol": [Float](),
        "zCol": [Float](),
        ]
    var gyroTotal = [
        "xTot": Float(0),
        "yTot": Float(0),
        "zTot": Float(0),
    ]
    var tempX:Float?
    var tempY:Float?
    var tempZ:Float?
    
    var cacheCountdown:Int = 5
    @IBOutlet weak var sceneView: SCNView!
    
    
    func logData(_ data:CMGyroData?, error:Error?){
        if let _ = data{
            gyroCache["xCol"]?.insert(Float(data!.rotationRate.x), at: 0)
            gyroCache["yCol"]?.insert(Float(data!.rotationRate.y), at: 0)
            gyroCache["zCol"]?.insert(Float(data!.rotationRate.z), at: 0)
            
            if cacheCountdown > 0{
                cacheCountdown -= 1
            } else if cacheCountdown == 0 {
                gyroTotal["xTot"] = gyroCache["xCol"]?.reduce(0, +)
                gyroTotal["yTot"] = gyroCache["yCol"]?.reduce(0, +)
                gyroTotal["zTot"] = gyroCache["zCol"]?.reduce(0, +)
                cacheCountdown -= 1
            } else if cacheCountdown == -1 {
                print(gyroTotal)
                gyroTotal["xTot"]! -= gyroCache["xCol"]!.popLast()!
                gyroTotal["yTot"]! -= gyroCache["yCol"]!.popLast()!
                gyroTotal["zTot"]! -= gyroCache["zCol"]!.popLast()!
                boxNode?.eulerAngles = SCNVector3Make(
                    gyroTotal["xTot"]!/5,
                    gyroTotal["yTot"]!/5,
                    gyroTotal["zTot"]!/5
                )
            }
        }
    }
    
    func setupGyro(){
        if motionManager.isGyroAvailable {
            print("Gyro available")
            motionManager.gyroUpdateInterval = 0.02
            motionManager.startGyroUpdates(to: OperationQueue.main, withHandler: logData)
        }
    }
    
    func setupScene(){
        let scene = SCNScene()
        let boxInstructions = SCNBox(width:10.0, height:10.0, length:10.0, chamferRadius: 0.0)
        boxNode = SCNNode(geometry: boxInstructions)
        scene.background.contents = UIColor.clear
        scene.rootNode.addChildNode(boxNode!)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 25)
        scene.rootNode.addChildNode(cameraNode)
        
        sceneView.scene = scene
        sceneView.backgroundColor = UIColor.clear
        print("Scene setup done")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        setupGyro()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

