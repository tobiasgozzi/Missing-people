//
//  Person.swift
//  MissingPersons
//
//  Created by Tobias Gozzi on 21.08.16.
//  Copyright © 2016 Tobias Gozzi. All rights reserved.
//

import UIKit
import ProjectOxfordFace

class Person {
    var personID: String?
    var personImage: UIImage?
    var personImageURL: String?
    
    init(personUrl: String) {
        self.personImageURL = personUrl
    }
    
    func downloadFaceID() {
        if let img = personImage, let data = UIImageJPEGRepresentation(img, 0.8) {
            FaceService.instance.client.detectWithData(data, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces: [MPOFace]!, error: NSError!) in
                
                var faceID: String!
                if error == nil {
                    for face in faces {
                        faceID = face.faceId
                        print("Face id: \(faceID)")
                        break
                    }
                    self.personID = faceID
                }
                
            })
        }
    }
}
