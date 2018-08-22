//
//  TimeLineContentView.swift
//  MinFin
//
//  Created by Владимир Мельников on 22/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class TimeLineContentView: UIView {

    private let startDate = 1800
    private let finalDate = 1885
    private let spaceBetweenDateLines: CGFloat = 20.0
    private let dotRadius: CGFloat = 2
    private let bottomOffset: CGFloat = 50
    private let leftOffset: CGFloat = 20 + 110
    private let timeLabelHeight: CGFloat = 20
    private let timeLabelWidth: CGFloat = 40
    
    var maxWidth: CGFloat {
        let range = finalDate - startDate
        return CGFloat(range) * spaceBetweenDateLines + bounds.minX + leftOffset + spaceBetweenDateLines * 2;
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        frame = CGRect(x: frame.minX, y: frame.minY, width: maxWidth, height: bounds.height)
        drawDateLines()
    }
    
    private func drawDateLines() {
        let rangeSize = finalDate - startDate
        if let context = UIGraphicsGetCurrentContext() {
            context.setStrokeColor(UIColor.black.cgColor)
            context.setLineWidth(1.0)
            
            for i in 0...rangeSize {
                let xCoordinate = bounds.minX + spaceBetweenDateLines * CGFloat(i) + leftOffset;
                let startPoint = CGPoint(x: xCoordinate, y: bounds.maxY - bottomOffset)
                let finalPoint = CGPoint(x: xCoordinate, y: bounds.minY)
                
                if i % 10 != 0 {
                    context.setLineDash(phase: 2.0, lengths: [5])
                } else {
                    context.setLineDash(phase: 0, lengths: [])
                    let dotRect = CGRect(x: xCoordinate - dotRadius, y: startPoint.y - dotRadius, width: dotRadius * 2, height: dotRadius * 2)
                    context.fillEllipse(in: dotRect)
                    
                    let labelFrame = CGRect(x: xCoordinate - timeLabelWidth / 2, y: startPoint.y + dotRadius + 10, width: timeLabelWidth, height: timeLabelHeight)
                    let label = UILabel(frame: labelFrame)
                    label.center = CGPoint(x: xCoordinate, y: startPoint.y + dotRadius + 15)
                    label.text = "\(startDate + i)"
                    addSubview(label)
                }
                
                context.move(to: startPoint)
                context.addLine(to: finalPoint)
                context.strokePath()
        }
        }
    }
}
