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
  var assets : [PHAsset]!
  //Demo id
  var eosinophilId = ["7156D371-02DD-4C3C-8B38-B8CAC3998BB2/L0/001",
                      "FFD1BC06-4ED5-4A82-971C-33A997EF265B/L0/001",
                      "739F5B59-02F7-4C66-89A3-D8ABA2E79CA4/L0/001",
                      "283B9AF5-1952-4C56-9A84-FBBF0463F932/L0/001",
                      "9CE0D8B1-1BA0-484A-BA58-59B41D3E2D97/L0/001",
                      "CA2D1915-8F97-483F-A305-A10D07419040/L0/001",
                      "7CDBDCA6-19E6-44D5-B4FA-F09FB2F4C2D5/L0/001",
                      "4F31EDD6-988D-4A43-9BF4-B8C3AC97BCA0/L0/001",
                      "2B221924-4B15-4D98-86F7-553C177FB118/L0/001",
                      "0E489E75-378B-43DA-AAC7-42586F5C1A47/L0/001",
                      "705319F2-B59F-4231-81BB-036335731DC6/L0/001",
                      "41ADA14F-ABBA-432F-A88C-725C6686A146/L0/001",
                      "AF56122A-772E-431D-BB7E-F7AD46B7B6CC/L0/001"]
  override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    assets = SelectedAssets.eosinophil.filter({ (asset) -> Bool in
      let index = self.eosinophilId.firstIndex(of: asset.localIdentifier)
      if let hasIndex = index {
        return true
      }
      return false
    })
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
    let image = assets[indexPath.row].getAssetThumbnail()
    cell.bloodImageView.image = image
    
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

