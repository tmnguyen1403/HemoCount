//
//  BloodCellViewController.swift
//  WhiteBloodcellCount
//
//  Created by Tom Riddle on 10/17/20.
//

import UIKit

class BloodCellViewController: UIViewController {

  @IBOutlet weak var chartView: MacawChartView!
  
  override func viewDidLoad() {
        super.viewDidLoad()
        chartView.contentMode = .scaleAspectFit
    
        MacawChartView.playAnimation()
    }
}
