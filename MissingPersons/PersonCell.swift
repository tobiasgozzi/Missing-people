//
//  PersonCell.swift
//  MissingPersons
//
//  Created by Tobias Gozzi on 21.08.16.
//  Copyright © 2016 Tobias Gozzi. All rights reserved.
//

import UIKit

class PersonCell: UICollectionViewCell {
    @IBOutlet weak var personView: UIImageView!
    
    var person: Person!
    
    func configureCell(person: Person) {
        self.person = person
        if let url = NSURL(string: "\(baseURL)\(person.personImageURL!)") {
            downloadImage(url)
        }
    }
    
    private func downloadImage(url: NSURL) {
        getDataFromUrl(url) { (data, response, error) in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else {
                    return
                }
                self.personView.image = UIImage(data: data)
                self.person.personImage = self.personView.image
            }
        }
    }
    
    private func getDataFromUrl(url: NSURL, completionHandler: ((data: NSData?, response: NSURLResponse?, error: NSError?) -> Void)) {
        
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in completionHandler(data: data, response: response, error: error)
        }.resume()
    }
    
    func setSelected(){

        personView.layer.borderWidth = 2.0
        personView.layer.borderColor = UIColor.yellowColor().CGColor

        self.person.downloadFaceID()
    }
    
    func unselectOldCell(){
        personView.layer.borderWidth = 0
        personView.layer.borderColor = nil
    }
}
