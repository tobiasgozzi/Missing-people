//
//  FaceService.swift
//  MissingPersons
//
//  Created by Tobias Gozzi on 21.08.16.
//  Copyright © 2016 Tobias Gozzi. All rights reserved.
//

import Foundation
import ProjectOxfordFace

class FaceService {
    static let instance = FaceService()
    
    let client = MPOFaceServiceClient(subscriptionKey: "93c2cc10cca04ba6a5508bbc27a9a774")
    
    
}