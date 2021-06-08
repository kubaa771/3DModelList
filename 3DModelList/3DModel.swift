//
//  3DModel.swift
//  3DModelList
//
//  Created by Jakub Iwaszek on 01/06/2021.
//

import Foundation
import SceneKit

class TDModel {
    var fileName: String
    var url: URL
    var scene: SCNScene?
    
    init(fileName: String, url: URL) {
        self.fileName = fileName
        self.url = url
    }
    
}
