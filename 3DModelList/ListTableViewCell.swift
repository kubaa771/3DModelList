//
//  ListTableViewCell.swift
//  3DModelList
//
//  Created by Jakub Iwaszek on 01/06/2021.
//

import UIKit
import SceneKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var renderImageView: UIImageView!
    @IBOutlet weak var fileNameLabel: UILabel!
    
    var scene: SCNScene!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    var model: TDModel! {
        didSet {
            customize(model: model)
        }
    }
    
    func customize(model: TDModel) {
        fileNameLabel.text = model.fileName
        do {
            let scene = try SCNScene(url: model.url, options: nil)
            renderImageView.image = getSnapshotFromScene(scene: scene)
            model.scene = scene
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func getSnapshotFromScene(scene: SCNScene) -> UIImage {
        let sceneView = SCNView(frame: renderImageView.frame)
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
        lightNode.position = SCNVector3(0, 10, 25)
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
        
        self.scene = scene
        
        return sceneView.snapshot()
    }
}
