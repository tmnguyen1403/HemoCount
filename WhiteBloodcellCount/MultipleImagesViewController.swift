//
//  MultipleImagesViewController.swift
//  WhiteBloodcellCount
//
//  Created by Tom Riddle on 10/18/20.
//

import UIKit
import Photos
import BSImagePicker

class MultipleImagesViewController: UIViewController{
  
  var selectedImages : [PHAsset]!
  override func viewDidLoad() {
        super.viewDidLoad()
  }
    
  @IBAction func sekectImagesClicked(_ sender: Any) {
//    pickerController.assetType = .allPhotos
//    pickerController.delegate = self
//    pickerController.sourceType = .photo
//    present(pickerController, animated: true, completion: nil)
    let imagePicker = ImagePickerController()
    //imagePicker.settings.selection.max = 5
    imagePicker.settings.theme.selectionStyle = .numbered
    imagePicker.settings.fetch.assets.supportedMediaTypes = [.image, .video]
    imagePicker.settings.selection.unselectOnReachingMax = true

    let start = Date()
    self.presentImagePicker(imagePicker, select: { (asset) in
        print("Selected: \(asset)")
    }, deselect: { (asset) in
        print("Deselected: \(asset)")
    }, cancel: { (assets) in
        print("Canceled with selections: \(assets)")
    }, finish: { (assets) in
      print("Finished with selections: \(assets.count) images")
        //let asset = assets[0]
      self.selectedImages = assets
    }, completion: {
        let finish = Date()
        print("Finish \(finish.timeIntervalSince(start))")
      
    })
    //selectImages()
  }
  
  @IBAction func onCountBloodCell(_ sender: Any) {
    let data = [ BloodCell(name: "Eosinophil", amount: 13),
                             BloodCell(name: "Lymphocyte", amount: 6),
                             BloodCell(name: "Monocyte", amount: 4),
                             BloodCell(name: "Neutrophil", amount: 10)]
    MacawChartView.setData(data);
   
    self.performSegue(withIdentifier: "showBarChartSegue", sender: nil)
  }
}
