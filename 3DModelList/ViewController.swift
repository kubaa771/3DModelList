//
//  ViewController.swift
//  3DModelList
//
//  Created by Jakub Iwaszek on 01/06/2021.
//

import UIKit
import SceneKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: SCNView!
    
    var element: TDModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSceneFile()
        loadLabel()
    }
    
    func getSceneFile() {
        do {
            let scene = try SCNScene(url: element.url, options: nil)
            self.configureScene(scene: scene)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func configureScene(scene: SCNScene) {
        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        camera.orthographicScale = 9
        camera.zNear = 0
        camera.zFar = 100
        let cameraNode = SCNNode()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 50)
        cameraNode.camera = camera
        let cameraOrbit = SCNNode()
        cameraOrbit.addChildNode(cameraNode)
        scene.rootNode.addChildNode(cameraOrbit)

        cameraOrbit.eulerAngles.x -= Float.pi / 4
        cameraOrbit.eulerAngles.y -= Float.pi / 4 * 3
        
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(GLKMathDegreesToRadians(360)), z: 0, duration: 8)
        let forever = SCNAction.repeatForever(action)
        cameraOrbit.runAction(forever)
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(0, 10, 35)
        scene.rootNode.addChildNode(lightNode)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        
        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = .white
        sceneView.cameraControlConfiguration.allowsTranslation = false
    
        sceneView.scene = scene
    }
    
    func loadLabel() {
        let textLabel = UILabel(frame: CGRect(x: 0, y: sceneView.frame.height / 1.5, width: sceneView.frame.size.width, height: 50))
        textLabel.text = element.fileName
        textLabel.textColor = .black
        textLabel.textAlignment = .center
        self.view.addSubview(textLabel)
    }
    
    func degToRad(deg: Float) -> Float{
        return (deg / 180 * .pi)
    }

}

