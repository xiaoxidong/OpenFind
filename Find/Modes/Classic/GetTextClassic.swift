//
//  GetTextClassic.swift
//  Find
//
//  Created by Andrew on 10/15/19.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit
import ARKit

extension ViewController {
    func getTextClassic(stringToFind: String, component: Component, alternate: Bool) {
        let point = CGPoint(x: component.x, y: component.y)
        print("point is \(point)")
        var newPoint = CGPoint()
        newPoint.x = deviceSize.width * point.x
        newPoint.y = deviceSize.height - (deviceSize.height * point.y)
        
        let realComponentWidth = component.width * deviceSize.width
        let realComponentHeight = component.height * deviceSize.height
        let individualCharacterWidth = realComponentWidth / CGFloat(component.text.count)
    
        print("NEWpoint is \(newPoint)")
        let indicies = component.text.indicesOf(string: stringToFind)
        if indicies.count >= 0 {
            
            
            for index in indicies {
                
                let finalPoint = CGPoint(x: newPoint.x + individualCharacterWidth, y: newPoint.y)
                let addedWidth = CGFloat(index) * individualCharacterWidth
                let results = sceneView.hitTest(finalPoint, types: .existingPlaneUsingExtent)
                
                if let hitResult = results.first {
                    
                    let realTextWidth = (individualCharacterWidth * CGFloat(stringToFind.count)) / CGFloat(2000)
                    
                    let highlight = SCNBox(width: realTextWidth, height: 0.001, length: realComponentHeight / 2000, chamferRadius: 0.001)
                    
//                    let sizeForHighlight = CGSize(width: realComponentWidth/2000, height: realComponentHeight/2000)
//                    let highlight = makeHighlightShape(size: sizeForHighlight)
                    let material = SCNMaterial()
                    let highlightColor : UIColor = #colorLiteral(red: 0, green: 0.7389578223, blue: 0.9509587884, alpha: 1)
                    material.diffuse.contents = highlightColor.withAlphaComponent(0.95)
                    highlight.materials = [material]
                    
                    let node = SCNNode(geometry: highlight)
                    node.transform = SCNMatrix4(hitResult.anchor!.transform)
                    node.position = SCNVector3(
                        
                        x: hitResult.worldTransform.columns.3.x,
                        y: hitResult.worldTransform.columns.3.y,
                        z: hitResult.worldTransform.columns.3.z
                    )
//                    node.eulerAngles.x = -.pi/2
//                    let billboardConstraint = SCNBillboardConstraint()
//                    billboardConstraint.freeAxes = [.Y]
//                    node.constraints = [billboardConstraint]
                    classicHasFoundOne = true
                    sceneView.scene.rootNode.addChildNode(node)
                    
                    if alternate == true {
                        //print("normal---------")
                        classicHighlightArray.append(node)
                        let action = SCNAction.fadeOpacity(to: 0.8, duration: 0.3)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                node.runAction(action)
                            }
                        
                    } else {
                        //print("alternate-------")
                        secondClassicHighlightArray.append(node)
                        let action = SCNAction.fadeOpacity(to: 0.8, duration: 0.3)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                node.runAction(action)
                            }
                    }
                    fadeHighlights()
                }
            }
        }
        
    }
}
extension String {
    func indicesOf(string: String) -> [Int] {
        var indices = [Int]()
        var searchStartIndex = self.startIndex
        
        while searchStartIndex < self.endIndex,
            let range = self.range(of: string, range: searchStartIndex..<self.endIndex),
            !range.isEmpty
        {
            let index = distance(from: self.startIndex, to: range.lowerBound)
            indices.append(index)
            searchStartIndex = range.upperBound
        }
        
        return indices
    }
}
