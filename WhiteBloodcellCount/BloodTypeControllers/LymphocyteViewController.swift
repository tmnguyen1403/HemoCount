//
//  LymphocyteViewController.swift
//  WhiteBloodcellCount
//
//  Created by Tom Riddle on 10/31/20.
//

import UIKit
import Photos


class LymphocyteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  

  @IBOutlet weak var tableView: UITableView!
  var assets : [PHAsset]!
  var lymphocyteId = [ "5E17960B-FEAE-4A2C-8DDB-7DB18DC1CB39/L0/001",
                       "CB9C14BE-AD44-49AC-A795-5A456D4ADAC0/L0/001",
                       "1EDF4E5F-E34A-4603-87A7-4C37E140B0CA/L0/001",
                       "8A222ED9-D3E8-41F5-953D-027B09617CA5/L0/001",
                       "0C310D04-15B4-4FBC-8176-8603F3888317/L0/001",
                       "84087A99-EFD1-49CC-BA37-7E262C50DA6D/L0/001"]
  override func viewDidLoad() {
        super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
        // Do any additional setup after loading the view.
    assets = SelectedAssets.lymphocyte.filter({ (asset) -> Bool in
      let index = self.lymphocyteId.firstIndex(of: asset.localIdentifier)
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


