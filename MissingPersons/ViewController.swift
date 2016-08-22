//
//  ViewController.swift
//  MissingPersons
//
//  Created by Tobias Gozzi on 20.08.16.
//  Copyright © 2016 Tobias Gozzi. All rights reserved.
//

import UIKit
import ProjectOxfordFace

let baseURL = "http://localhost:6069/img/"

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var selectedImg: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedPerson: Person?
    var hasSelectedImage = false
    let selectedCellIndexPath: Int = 0
    
    let imagePicker = UIImagePickerController()
    
    let missingPeople1 = [
        "person1.jpg",
        "person2.jpg",
        "person3.jpg",
        "person4.jpg",
        "person5.jpg",
        "person6.png"
    ]
    let missingPeople = [
        Person(personUrl: "person1.jpg"),
        Person(personUrl: "person2.jpg"),
        Person(personUrl: "person3.jpg"),
        Person(personUrl: "person4.jpg"),
        Person(personUrl: "person5.jpg"),
        Person(personUrl: "person6.jpg")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        imagePicker.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(loadPicker(_:)))
        tap.numberOfTapsRequired = 1
        selectedImg.addGestureRecognizer(tap)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return missingPeople.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PersonCell", forIndexPath: indexPath) as? PersonCell {
            
            let person = missingPeople[indexPath.row]
            cell.configureCell(person)
            return cell
        } else {
            print("standard cell created")
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedPerson = missingPeople[indexPath.row]
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PersonCell
        //cell.configureCell(selectedPerson!)
        
        cell.setSelected()

    }
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PersonCell
        
        cell.unselectOldCell()
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedimage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImg.image = pickedimage
            hasSelectedImage = true
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadPicker(gesture: UITapGestureRecognizer) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func showErrAlert() {
        let alert = UIAlertController(title: "Select person and photo", message: "Please select a person and a photo from your album", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func checkMatch(sender: AnyObject) {
        if selectedPerson == nil || hasSelectedImage == false {
            showErrAlert()
        } else {
            if let image = selectedImg.image, let data = UIImageJPEGRepresentation(image, 0.8) {
                FaceService.instance.client.detectWithData(data, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces: [MPOFace]!, err: NSError!) in
                    if err == nil {
                        var faceID:  String?
                        for face in faces {
                            faceID = face.faceId
                            break
                        }
                        
                        if faceID != nil {
                            FaceService.instance.client.verifyWithFirstFaceId(self.selectedPerson!.personID, faceId2: faceID, completionBlock: { (result: MPOVerifyResult!, err: NSError!) in
                                if err == nil && result != nil {
                                    print("It's the same person: \(result.isIdentical)")
                                    print(result.confidence)
                                    print(result.debugDescription)
                                } else {
                                    print(err.debugDescription)
                                }
                            })
                        }
                    }
                })
            }
        }
    }
    
}

