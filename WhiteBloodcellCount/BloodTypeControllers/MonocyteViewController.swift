//
//  MonocyteViewController.swift
//  WhiteBloodcellCount
//
//  Created by Tom Riddle on 10/31/20.
//

import UIKit
import Photos
import BSImagePicker

class MonocyteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!
  var assets : [PHAsset]!
  var monocyteId = ["4083A594-27F3-4513-92FE-1DC43C503394/L0/001",
  "EA9CAD27-9555-4E4D-B2D4-6C23E6E51B0C/L0/001",
  "0438304E-F9C9-4E6E-87AB-C7CC82F31E38/L0/001",
  "5543CE0A-8AD1-43C0-8A39-65EE611A8E11/L0/001"]
  override func viewDidLoad() {
        super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
        // Do any additional setup after loading the view.
    assets = SelectedAssets.monocyte.filter({ (asset) -> Bool in
      let index = self.monocyteId.firstIndex(of: asset.localIdentifier)
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
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    assets.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "BloodTableCell") as! BloodTableCell
    cell.imageLabel.text = "Image \(indexPath.row + 1)"
    let image = assets[indexPath.row].getAssetThumbnail()
    cell.bloodImageView.image = image
    
    return cell
  }


}
