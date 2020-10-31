//
//  NeutrophilViewController.swift
//  WhiteBloodcellCount
//
//  Created by Tom Riddle on 10/31/20.
//

import UIKit
import Photos
import BSImagePicker

class NeutrophilViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!
  var assets : [PHAsset]!
  var neutrophilId = [  "58F77B29-15C5-4321-B9E5-63F0B3FB27A9/L0/001",
                        "F6893152-CCFA-4040-8016-30D8E706B0F0/L0/001",
                        "5C7F1169-F369-4538-ADFD-8E489FEEE033/L0/001",
                        "643A4AC7-B8C0-4675-B797-7990DF29F321/L0/001",
                        "3ADDC040-518C-48E3-8B60-445B59CB8856/L0/001",
                        "302C1294-EB91-4621-8CD5-1B7B36D971E1/L0/001",
                        "6A8779E4-5C81-4474-B62E-42CF0A302A6B/L0/001",
                        "C6738484-FD5E-4444-8D63-B7023F6FA800/L0/001",
                        "4E2577C3-1504-404D-98D9-DE8BF1D772AA/L0/001",
                        "9C26C418-4068-4FC6-9A46-8B091C9510F3/L0/001"]
  override func viewDidLoad() {
        super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
        // Do any additional setup after loading the view.
    assets = SelectedAssets.neutrophil.filter({ (asset) -> Bool in
      let index = self.neutrophilId.firstIndex(of: asset.localIdentifier)
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

