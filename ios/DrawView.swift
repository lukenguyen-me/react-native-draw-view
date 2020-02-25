//
//  DrawView.swift
//  DrawView
//
//  Created by Loc Nguyen on 2/24/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import UIKit

class DrawView: UIView {
  @objc var color: String = "#000000"
  @objc var strokeWidth: NSNumber = 1
  @objc var onSaved: RCTDirectEventBlock?
  @objc var onError: RCTDirectEventBlock?

  var drawView = UIImageView()
  var tempView = UIImageView()
  var lastPoint = CGPoint.zero
  var swiped = false
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupLayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    self.addSubview(drawView)
    self.addSubview(tempView)
    
  }
  
  private func setupLayout() {
    drawView.translatesAutoresizingMaskIntoConstraints = false
    tempView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint(item: drawView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
    NSLayoutConstraint(item: drawView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    NSLayoutConstraint(item: drawView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
    NSLayoutConstraint(item: drawView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
    
    NSLayoutConstraint(item: tempView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
    NSLayoutConstraint(item: tempView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    NSLayoutConstraint(item: tempView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
    NSLayoutConstraint(item: tempView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    swiped = false
    lastPoint = touch.location(in: tempView)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    swiped = true
    let currentPoint = touch.location(in: tempView)
    drawLine(from: lastPoint, to: currentPoint)
    lastPoint = currentPoint
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if !swiped {
      drawLine(from: lastPoint, to: lastPoint)
    }
    UIGraphicsBeginImageContext(tempView.frame.size)
    drawView.image?.draw(in: tempView.bounds, blendMode: .normal, alpha: 1.0)
    tempView.image?.draw(in: tempView.bounds, blendMode: .normal, alpha: 1.0)
    drawView.image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    tempView.image = nil
  }
}

private extension DrawView {
  func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
    UIGraphicsBeginImageContext(tempView.frame.size)
    guard let context = UIGraphicsGetCurrentContext() else { return }
    tempView.image?.draw(in: tempView.bounds)
    
    context.move(to: fromPoint)
    context.addLine(to: toPoint)
    
    context.setLineCap(.round)
    context.setBlendMode(.normal)
    context.setStrokeColor(hexToColor(color).cgColor)
    context.setLineWidth(CGFloat(truncating: strokeWidth))
    
    context.strokePath()
    
    tempView.image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
  }
  
  func hexToColor(_ hexString: String) -> UIColor {
    let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    let scanner = Scanner(string: hexString)
    if (hexString.hasPrefix("#")) {
        scanner.scanLocation = 1
    }
    var color: UInt32 = 0
    scanner.scanHexInt32(&color)
    let mask = 0x000000FF
    let r = Int(color >> 16) & mask
    let g = Int(color >> 8) & mask
    let b = Int(color) & mask
    let red   = CGFloat(r) / 255.0
    let green = CGFloat(g) / 255.0
    let blue  = CGFloat(b) / 255.0
    return UIColor(red:red, green:green, blue:blue, alpha:1)
  }
}

extension DrawView {
  @objc func reset() {
    drawView.image = nil
    tempView.image = nil
  }
  
  @objc func save() {
    guard let image = drawView.image else {
      if let onError = onError {
        onError(["message": "No draw to save"])
      }
      return
    }
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileName = "draw.png"
    let fileURL = documentsDirectory.appendingPathComponent(fileName)
    if let data = image.pngData() {
      do {
        try data.write(to: fileURL)
        if let onSaved = onSaved {
          onSaved([
            "uri": fileURL.absoluteString,
            "mimetype": "image/png",
            "name": "draw.png",
            "size": data.count,
          ])
        }
      } catch {
        if let onError = onError {
          onError(["message": "Can't save to image"])
        }
      }
    }
  }
}
