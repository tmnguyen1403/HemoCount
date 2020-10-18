//
//  ViewController.swift
//  WhiteBloodcellCount
//
//  Created by Tom Riddle on 10/17/20.
//

import UIKit
import CoreML
import Vision
import ImageIO

class ViewController: UIViewController{

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
    if let image = imageView.image {
      updateClassifications(for: image)
    } else {
      print("No image to classify")
    }
  }
  
  @IBAction func takePicture() {
      // Show options for the source picker only if the camera is available.
      guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
          presentPhotoPicker(sourceType: .photoLibrary)
          return
      }
      
      let photoSourcePicker = UIAlertController()
      let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { [unowned self] _ in
        self.presentPhotoPicker(sourceType: .camera)
      }
      let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { [unowned self] _ in
          self.presentPhotoPicker(sourceType: .photoLibrary)
      }
      
      photoSourcePicker.addAction(takePhoto)
      photoSourcePicker.addAction(choosePhoto)
      photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
      
      present(photoSourcePicker, animated: true)
  }
  
  func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
      let picker = UIImagePickerController()
      picker.delegate = self
      picker.sourceType = sourceType
      present(picker, animated: true)
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
          let model = try VNCoreMLModel(for: Test().model)
          
          let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
              self?.processClassifications(for: request, error: error)
          })
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
  func updateClassifications(for image: UIImage) {
      //classificationLabel.text = "Classifying..."
      
    let resized_image = image//self.resizeImage(image: image, targetSize: CGSize(width: 320, height: 240))
    let orientation = CGImagePropertyOrientation(rawValue: UInt32(resized_image.imageOrientation.rawValue))
    
    print("Resize Image size helloo:", resized_image.size)
      guard let ciImage = CIImage(image: resized_image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
    print("ci Image size:", ciImage)

      DispatchQueue.global(qos: .userInitiated).async {
          let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation!)
          do {
              try handler.perform([self.classificationRequest])
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
  
  /// Updates the UI with the results of the classification.
  /// - Tag: ProcessClassifications
  func processClassifications(for request: VNRequest, error: Error?) {
      DispatchQueue.main.async {
          guard let results = request.results else {
            print("Unable to classify image")
//              self.classificationLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
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
            
            let data: [BloodCell] = [ BloodCell(name: "Eosinophil", amount: 1000),
                                      BloodCell(name: "Lymphocyte", amount: 40),
                                      BloodCell(name: "Monocyte", amount: 700),
                                      BloodCell(name: "Neutrophil", amount: 300)]
            //set blood cell datas to render chart
            MacawChartView.setData(data);
            self.performSegue(withIdentifier: "chartViewSegue", sender: nil)
        
            print("Classification label:", descriptions[0])
            print(descriptions)
            print("Classification successfully")
//              self.classificationLabel.text = "Classification:\n" + descriptions.joined(separator: "\n")
          }
      }
  }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Handling Image Picker Selection

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
    if let image = info[.originalImage] {
        imageView.image = image as! UIImage
        //updateClassifications(for: image as! UIImage)
    }
  }
}


