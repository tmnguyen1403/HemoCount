//
//  MultipleImagesViewController.swift
//  WhiteBloodcellCount
//
//  Created by Tom Riddle on 10/18/20.
//

import UIKit
import DKImagePickerController
import DKPhotoGallery
import DKCamera

class MultipleImagesViewController: UIViewController, DKImageAssetExporterObserver{
  
    let pickerController = DKImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     
      pickerController.didSelectAssets = { (assets: [DKAsset]) in
        print("didSelectAssets")
        print(assets)
        for item in assets {
          print("hello assets ")
          print(item.fileSize)
          if let image = item.image {
            print("Image info:  \(image.description)")
          }
        }
        let data = [ BloodCell(name: "Eosinophil", amount: 13),
                                 BloodCell(name: "Lymphocyte", amount: 6),
                                 BloodCell(name: "Monocyte", amount: 4),
                                 BloodCell(name: "Neutrophil", amount: 10)]
        MacawChartView.setData(data);
       
        self.performSegue(withIdentifier: "showBarChartSegue", sender: nil)
        
      }
      pickerController.showsCancelButton = true
      pickerController.didCancel = {
        print("User cancelled")
      }
      
    }
    
  func selectImages() {
    present(photoGallery: DKPhotoGallery(), completion: nil)
  }
    
  @IBAction func sekectImagesClicked(_ sender: Any) {
    pickerController.assetType = .allPhotos
    pickerController.delegate = self
    pickerController.sourceType = .photo
    present(pickerController, animated: true, completion: nil)
    //selectImages()
  }
  
}

extension MultipleImagesViewController: UINavigationControllerDelegate {
    // MARK: - Handling Image Picker Selection

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        print("Finished picking data")
  }
}

