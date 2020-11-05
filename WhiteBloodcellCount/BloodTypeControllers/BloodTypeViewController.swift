//
//  BloodTypeViewController.swift
//  WhiteBloodcellCount
//
//  Created by Tom Riddle on 10/31/20.
//

import UIKit
import Photos
import BSImagePicker

class BloodTypeViewController: UIViewController{

  

  @IBOutlet weak var tableView: UITableView!
  var assets : [UIImage]!
  //Demo id
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
        // Do any additional setup after loading the view.
    assets = ClassifiedImages.eosinophil
  }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
  


}

extension BloodTypeViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return assets.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "BloodTableCell") as! BloodTableCell
    cell.imageLabel.text = "Image \(indexPath.row + 1)"
    
    cell.bloodImageView.image = assets[indexPath.row]
    
    return cell
  }
}

extension PHAsset {
func getAssetThumbnail() -> UIImage {

    let manager = PHImageManager.default()
    let option = PHImageRequestOptions()
    var thumbnail = UIImage()
    option.isSynchronous = true
      manager.requestImage(for: self,
                         targetSize: CGSize(width: self.pixelWidth, height: self.pixelHeight),
                         contentMode: .aspectFit,
                         options: option,
                         resultHandler: {(result, info) -> Void in
                            thumbnail = result!
                         })
    return thumbnail
    }
}

