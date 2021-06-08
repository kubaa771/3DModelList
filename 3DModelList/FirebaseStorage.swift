//
//  FirebaseStorage.swift
//  3DModelList
//
//  Created by Jakub Iwaszek on 01/06/2021.
//

import Foundation
import FirebaseStorage

class FirebaseStorage {
    static var shared = FirebaseStorage()
    let storage = Storage.storage()
    
    func getModel(fileName: String, completion: @escaping((URL) -> Void)) {
        let modelRef = storage.reference().child(fileName)
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let scenePath = documentsURL.appendingPathComponent(fileName)
        
        modelRef.write(toFile: scenePath) { (url, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let url = url else { return }
                completion(url)
            }
        }
    }
    
    
    func getListedElements(completion: @escaping([TDModel]) -> Void) {
        var elements: [TDModel] = []
        let group = DispatchGroup()
        storage.reference().listAll { (listResult, error) in
            for item in listResult.items {
                let fileName = item.name
                group.enter()
                self.getModel(fileName: fileName) { (url) in
                    if fileName.hasSuffix(".obj") {
                        let model = TDModel(fileName: fileName, url: url)
                        elements.append(model)
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                completion(elements)
            }
        }
    }
}
