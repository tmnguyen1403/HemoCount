//
//  MacawChartView.swift
//  WhiteBloodcellCount
//
//  Created by Tom Riddle on 10/17/20.
//

import Foundation
import Macaw

class MacawChartView: MacawView {
  
  static let lastFiveShows      = createDummyData()
  static let maxValue           = 6000
  static let maxValueLineHeight = 180
  static let lineWidth: Double  = 275
  
  static let dataDivisor        = Double(maxValue/maxValueLineHeight)
  static let adjustedData: [Double] = lastFiveShows.map({$0.videoCount / dataDivisor})
  static var animation: [Animation] = []
  
  required init?(coder aDecoder: NSCoder) {
    super.init(node: MacawChartView.createChart(), coder: aDecoder)
    backgroundColor = .clear
  }
  
  private static func createChart() -> Group {
    var items: [Node] = addYAxisItems() + addXAxisItems()
    items.append(createBars())
    
    return Group(contents: items, place: .identity)
  }
  
  private static func addYAxisItems() -> [Node] {
    let maxLines = 6
    let lineInterval = Int(maxValue/maxLines)
    let yAxisHeight: Double = 200
    let lineSpacing: Double = 30
    
    var newNodes: [Node] = []
    
    for i in 1...maxLines {
      let y = yAxisHeight - (Double(i) * lineSpacing)
      
      let valueLine = Line(x1: -5, y1: y, x2: lineWidth, y2: y).stroke(fill: Color.white.with(a: 0.10))
      let valueText = Text(text: "\(i * lineInterval)", align: .max, baseline: .mid, place: .move(dx: -10, dy: y))
      valueText.fill = Color.white
      
      newNodes.append(valueLine)
      newNodes.append(valueText)
    }
    
    let yAxis = Line(x1: 0, y1: 0, x2: 0, y2: yAxisHeight).stroke(fill: Color.white.with(a: 0.25))
    newNodes.append(yAxis)
    
    return []
  }
  
  private static func addXAxisItems() -> [Node] {
    return []
  }
  
  private static func createBars() -> Group {
    return Group()
  }
  
  private static func createDummyData() -> [SwiftNewsVideo] {
    let one = SwiftNewsVideo(showNumber: "55", videoCount: 3456)
    let two = SwiftNewsVideo(showNumber: "56", videoCount: 5000)
    let three = SwiftNewsVideo(showNumber: "57", videoCount: 5500)
    
    return [one, two, three]
  }
}
/*
 *Data to visualize:
 *blood cell names - percentage : [Basophil, Eosinophil, Lymphocyte, Monocyte, Neutrophil] - [5,10,20,30,40]
 */
