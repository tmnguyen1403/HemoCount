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
  var assets : [UIImage]!

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
        // Do any additional setup after loading the view.
    assets = ClassifiedImages.neutrophil
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
 
    cell.bloodImageView.image = assets[indexPath.row]
    
    return cell
  }
}

