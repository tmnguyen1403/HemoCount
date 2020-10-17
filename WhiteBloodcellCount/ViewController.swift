//
//  ViewController.swift
//  WhiteBloodcellCount
//
//  Created by Tom Riddle on 10/17/20.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

  @IBOutlet var imageView: UIImageView!
  @IBOutlet var chooseButton: UIButton!
  var imagePicker = UIImagePickerController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  @IBAction func btnClicked() {
    if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
      print("Button Cpature")
      imagePicker.delegate = self
      imagePicker.sourceType = .savedPhotosAlbum
      imagePicker.allowsEditing = false
      present(imagePicker, animated: true, completion: nil)
    }
  }
  
  @IBAction func countBloodCellClicked(_ sender: Any) {
    //retrieve image
    //convert image to b64
    //upload image to server
    //wait for the result
    //render graph
    print("Count Blood Cell pressed")
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    self.dismiss(animated: true) {
      print("Finish picking images")
    }
    if let image = info[.originalImage] {
      imageView.image = image as! UIImage
    } else {
      print("Error when picking image ")
    }
  }

}

