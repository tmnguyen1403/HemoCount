//
//  MultipleImagesViewController.swift
//  WhiteBloodcellCount
//
//  Created by Tom Riddle on 10/18/20.
//

import UIKit
import Photos
import BSImagePicker
import CoreML
import Vision
import ImageIO
import Photos


class MultipleImagesViewController: UIViewController{
  
  var selectedImages : [PHAsset]!
  let imagePicker = ImagePickerController()
  
  @IBOutlet weak var countBloodCellButton: UIButton!
  override func viewDidLoad() {
        super.viewDidLoad()
//    countBloodCellButton.isEnabled = false
//    countBloodCellButton.backgroundColor = UIColor.gray
    selectedImages = []
    //setup for imagePicker
    imagePicker.settings.theme.selectionStyle = .numbered
    imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
    //use this to show different albums
    imagePicker.settings.fetch.album.fetchResults.append(PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: imagePicker.settings.fetch.album.options))
    //closures for imagePicker
  }
    
  @IBAction func onSelectImages(_ sender: Any) {
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
      self.countBloodCellButton.isEnabled = true
    }, completion: {
        let finish = Date()
        print("Finish \(finish.timeIntervalSince(start))")
      
    })
    //selectImages()
  }
  @IBAction func onCountBloodCell(_ sender: Any) {
    print("clicked button")
    if selectedImages.count > 0 {
      //assgined assets to render
      var thumbnails : [UIImage] = []
      for asset in selectedImages {
        let thumbnail = asset.getAssetThumbnail()
        thumbnails.append(thumbnail)
      }
      //reset data
      ClassifiedImages.eosinophil = []
      ClassifiedImages.lymphocyte = []
      ClassifiedImages.monocyte = []
      ClassifiedImages.neutrophil = []

      //perform classification on selected images
      updateClassifications(for: thumbnails)
      
//      //setup data for chartview
//      print("assetID: \(selectedImages[0].localIdentifier)")
//      let data = [ BloodCell(name: "Eosinophil", amount: Double(ClassifiedImages.eosinophil.count)),
//                   BloodCell(name: "Lymphocyte", amount: Double(ClassifiedImages.lymphocyte.count)),
//                   BloodCell(name: "Monocyte", amount: Double(ClassifiedImages.monocyte.count)),
//                  BloodCell(name: "Neutrophil", amount: Double(ClassifiedImages.neutrophil.count))]
//      MacawChartView.setData(data);
//
//      //go to barchart
//      self.performSegue(withIdentifier: "showBarChartSegue", sender: nil)
    }
  }
  
  // MARK: - Image Classification
  
  /// - Tag: MLModelSetup
  lazy var classificationRequest: VNCoreMLRequest = {
      do {
          /*
           Use the Swift class `MobileNet` Core ML generates from the model.
           To use a different Core ML classifier model, add it to the project
           and replace `MobileNet` with that model's generated Swift class.
           */
          let model = try VNCoreMLModel(for: BloodCellClassifier().model)
          
          let request = VNCoreMLRequest(model: model, completionHandler: nil)
        //request.imageCropAndScaleOption = .centerCrop
          return request
      } catch {
          fatalError("Failed to load Vision ML model: \(error)")
      }
  }()
  
  func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    print("Image Size", image.size)
    let size = image.size
    let widthRatio = targetSize.width / size.width
    let heightRatio = targetSize.height / size.height
    
    var newSize: CGSize
    if (widthRatio > heightRatio) {
      newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
      newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
    }
    
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
  }
  
  /// - Tag: PerformRequests
  func updateClassifications(for images: [UIImage]) {
    //use this to monitor the classfication activities and notify when the work is done
    var dispatchGroup = DispatchGroup()
    var dispatchClassifcation = DispatchQueue(label: "classification", qos: .userInitiated)
    //create array of ciImage
    for image in images {
      let resized_image = image//self.resizeImage(image: image, targetSize: CGSize(width: 320, height: 240))
      let orientation = CGImagePropertyOrientation(rawValue: UInt32(resized_image.imageOrientation.rawValue))

      print("Resize Image size helloo:", resized_image.size)
        guard let ciImage = CIImage(image: resized_image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
      print("ci Image size:", ciImage)
      dispatchClassifcation.async(group: dispatchGroup) {
        dispatchGroup.enter()
        //create array of handler
        let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation!)
        do {
          let request = self.classificationRequest
          try handler.perform([self.classificationRequest])
          if let results = request.results {
            print("I got results")
            let classifications = results as! [VNClassificationObservation]
            let topLabel = classifications[0].identifier
            
            switch topLabel {
              case "EOSINOPHIL":
                ClassifiedImages.eosinophil.append(image)
                break
              case "LYMPHOCYTE":
                ClassifiedImages.lymphocyte.append(image)
                break
              case "MONOCYTE":
                ClassifiedImages.monocyte.append(image)
                break
              case "NEUTROPHIL":
                ClassifiedImages.neutrophil.append(image)
                break
              default:
                print("Error")
            }
          }
          dispatchGroup.leave()
        } catch {
            /*
             This handler catches general image processing errors. The `classificationRequest`'s
             completion handler `processClassifications(_:error:)` catches errors specific
             to processing that request.
             */
            print("Failed to perform classification.\n\(error.localizedDescription)")
        }
      }
    }
    
    //group notify
    dispatchGroup.notify(queue: dispatchClassifcation) {
      //setup data for chartview
      let data = [ BloodCell(name: "Eosinophil", amount: Double(ClassifiedImages.eosinophil.count)),
                   BloodCell(name: "Lymphocyte", amount: Double(ClassifiedImages.lymphocyte.count)),
                   BloodCell(name: "Monocyte", amount: Double(ClassifiedImages.monocyte.count)),
                  BloodCell(name: "Neutrophil", amount: Double(ClassifiedImages.neutrophil.count))]
      MacawChartView.setData(data);
      
      //go to barchart using the main thread
      DispatchQueue.main.sync {
        self.performSegue(withIdentifier: "showBarChartSegue", sender: nil)
      }
    }
    //called segue
    
  }
  
  /// Updates the UI with the results of the classification.
  /// - Tag: ProcessClassifications
  func processClassifications(for request: VNRequest, error: Error?) {
      DispatchQueue.main.async {
          guard let results = request.results else {
            print("Unable to classify image")
              return
          }
          // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
          let classifications = results as! [VNClassificationObservation]
      
          if classifications.isEmpty {
              print("Nothing to recognized")
              //self.classificationLabel.text = "Nothing recognized."
          } else {
              // Display top classifications ranked by confidence in the UI.
              let topClassifications = classifications.prefix(2)
              let descriptions = topClassifications.map { classification in
                  // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
                
                 return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
              }
            
            //Save images
            let label = topClassifications[0].identifier
            
//            let data: [BloodCell] = [ BloodCell(name: "Eosinophil", amount: 1000),
//                                      BloodCell(name: "Lymphocyte", amount: 40),
//                                      BloodCell(name: "Monocyte", amount: 700),
//                                      BloodCell(name: "Neutrophil", amount: 300)]
//            //set blood cell datas to render chart
//            MacawChartView.setData(data);
//            self.performSegue(withIdentifier: "chartViewSegue", sender: nil)
        
            print("Classification label:", descriptions[0])
            print(descriptions)
            print("Classification successfully")
//              self.classificationLabel.text = "Classification:\n" + descriptions.joined(separator: "\n")
          }
      }
  }
}
