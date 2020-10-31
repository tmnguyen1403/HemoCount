//
//  MacawChartView.swift
//  WhiteBloodcellCount
//
//  Created by Tom Riddle on 10/17/20.
//

import Foundation
import Macaw

class MacawChartView: MacawView {
  
  static var lastFiveShows      = createDummyData()
  static let maxValue           = 1200
  static let maxValueLineHeight = 300
  static let lineWidth: Double  = 400
  
  static let dataDivisor        = Double(maxValue/maxValueLineHeight)
  static let adjustedData: [Double] = lastFiveShows.map({$0.amount / dataDivisor})
  static var animations: [Animation] = []
  
  required init?(coder aDecoder: NSCoder) {
    super.init(node: MacawChartView.createChart(), coder: aDecoder)
    backgroundColor = .clear
  }
  
  public static func setData(_ data : [BloodCell]) {
    print("Called set Data")
    lastFiveShows = data
  }
  
  private static func createChart() -> Group {
    var items: [Node] = addYAxisItems() + addXAxisItems()
    items.append(createBars())
    
    return Group(contents: items, place: .identity)
  }
  
  private static func addYAxisItems() -> [Node] {
    let maxLines = 10
    let lineInterval = Int(maxValue/maxLines)
    let yAxisHeight: Double = 300
    let lineSpacing: Double = 30
    
    var newNodes: [Node] = []
    
    for i in 0...maxLines {
      let y = yAxisHeight - (Double(i) * lineSpacing)
      
      let valueLine = Line(x1: -5, y1: y, x2: lineWidth, y2: y).stroke(fill: Color.black.with(a: 0.10))
      let valueText = Text(text: "\(i * lineInterval / 10)", align: .max, baseline: .mid, place: .move(dx: -10, dy: y))
      valueText.fill = Color.black
      
      newNodes.append(valueLine)
      newNodes.append(valueText)
    }
    
    let yAxis = Line(x1: 0, y1: 0, x2: 0, y2: yAxisHeight).stroke(fill: Color.black.with(a: 0.25))
    newNodes.append(yAxis)
    
    return newNodes
  }
  
  private static func addXAxisItems() -> [Node] {
    let chartBaseY: Double = 300
    var newNodes: [Node] = []
    
    for i in 1...adjustedData.count {
      let x = (Double(i) * 100)
      let nameText = Text(text: (lastFiveShows[i-1].name), align: .max, baseline: .mid, place: .move(dx: x - 25, dy: chartBaseY + 15))
      nameText.fill = Color.black
      newNodes.append(nameText)
      
      let valueText = Text(text: "\(Int(lastFiveShows[i-1].amount))", align: .max, baseline: .mid, place: .move(dx: x - 55, dy: chartBaseY - adjustedData[i-1]*10 - 10.0))
      valueText.fill = Color.black
      newNodes.append(valueText)
    }
    
    let xAxis = Line(x1: 0, y1: chartBaseY, x2: lineWidth, y2: chartBaseY).stroke(fill: Color.black.with(a: 0.25))
    newNodes.append(xAxis)
    
    return newNodes
  }
  
  private static func createBars() -> Group {
    let fill = LinearGradient(degree: 90, from: Color(val: 0x2C71EA), to: Color(val: 0x2C71EA).with(a: 0.33))
    let items = adjustedData.map { _ in Group() }
    
    animations = items.enumerated().map { (i: Int, item: Group) in
      item.contentsVar.animation(delay: Double(i) * 0.1) { t in
        let height = adjustedData[i] * t
        let rect = Rect(x: Double(i) * 100 + 25, y: 300 - height * 10, w: 30, h: height * 10)
        return [rect.fill(with: fill)]
      }
    }
    return items.group()
  }
  
  static func playAnimation() {
    animations.combine().play()
  }
  
  private static func createDummyData() -> [BloodCell] {
    let one = BloodCell(name: "Eosinophil", amount: 522)
    let two = BloodCell(name: "Lymphocyte", amount: 620)
    let three = BloodCell(name: "Lymphocyte", amount: 456)
    let four = BloodCell(name: "Neutrophil", amount: 568)
    
    return [one, two, three, four]
  }
}
/*
 *Data to visualize:
 *blood cell names - percentage : [Basophil, Eosinophil, Lymphocyte, Monocyte, Neutrophil] - [5,10,20,30,40]
 */


