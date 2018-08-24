//
//  TimeLineContentView.swift
//  MinFin
//
//  Created by Владимир Мельников on 22/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

extension String {
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return ceil(boundingBox.width)
    }
}

protocol TimeLineContentViewDelegate: class {
    func didSelect(person: Person)
}

class TimeLineContentView: UIView {

    private let startDate = 1800
    private let finalDate = 2019
    private let spaceBetweenDateLines: CGFloat = 40.0
    private let dotRadius: CGFloat = 2
    private let leftOffset: CGFloat = 20 + 110
    private let timeLabelHeight: CGFloat = 20
    private let timeLabelWidth: CGFloat = 44
    private let verticalOffset: CGFloat = 10.0
    
    var maxWidth: CGFloat {
        let range = finalDate - startDate
        return CGFloat(range) * spaceBetweenDateLines + bounds.minX + leftOffset + spaceBetweenDateLines;
    }
    
    let bottomOffset: CGFloat = 50
    var eventsMinYCoordinate: CGFloat!
    var topOffset: CGFloat!
    var governers = [Person]()
    var events = [Event]()
    var ministers = [Person]()
    
    var personsSectionHeight: CGFloat!
    var eventsSectionHeight: CGFloat!
    
    weak var delegate: TimeLineContentViewDelegate?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        frame = CGRect(x: frame.minX, y: frame.minY, width: maxWidth, height: bounds.height)
        drawDateLines()
        addGovernerViews()
        addMinistersViews()
        addEvenentsViews()
    }
    
    private func drawDateLines() {
        let rangeSize = finalDate - startDate
        if let context = UIGraphicsGetCurrentContext() {
            context.setStrokeColor(UIColor.white.cgColor)
            context.setFillColor(UIColor.white.cgColor)
            context.setLineWidth(1.0)
            
            for i in 0...rangeSize {
                let xCoordinate = bounds.minX + spaceBetweenDateLines * CGFloat(i) + leftOffset;
                let startPoint = CGPoint(x: xCoordinate, y: bounds.maxY - bottomOffset)
                let finalPoint = CGPoint(x: xCoordinate, y: bounds.minY + topOffset)
                
                if i % 10 != 0 {
                    context.setLineDash(phase: 2.0, lengths: [5])
                } else {
                    context.setLineDash(phase: 0, lengths: [])
                    let dotRect = CGRect(x: xCoordinate - dotRadius, y: startPoint.y - dotRadius, width: dotRadius * 2, height: dotRadius * 2)
                    context.fillEllipse(in: dotRect)
                    
                    let labelFrame = CGRect(x: xCoordinate - timeLabelWidth / 2, y: startPoint.y + dotRadius + 10, width: timeLabelWidth, height: timeLabelHeight)
                    let label = UILabel(frame: labelFrame)
                    label.textColor = UIColor.white
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
    
    private func addEvenentsViews() {
        
        let eventRowHeight = ((bounds.maxY - bottomOffset - dotRadius) - eventsMinYCoordinate) / 5
        
        for event in events {
            
            //one year event
            if event.endYear == nil || event.endYear == 0 {
                let xCenterCoordinate = bounds.minX + CGFloat(event.startYear - startDate) * spaceBetweenDateLines + leftOffset
                let yCoordinate = eventsMinYCoordinate + CGFloat(event.rowNumber) * eventRowHeight

                let eventView = SingleEventView(frame: CGRect())
                eventView.titleLabel.text = event.name

                let eventViewWidth = event.name.width(withConstrainedHeight: 21.0, font: eventView.titleLabel.font) + SingleEventView.horizontalSpace
                let eventRect = CGRect(x: xCenterCoordinate - eventViewWidth / 2, y: yCoordinate, width: eventViewWidth, height: SingleEventView.viewHeight)
                eventView.frame = eventRect
                addSubview(eventView)
            } else if event.needToCenterContent {
                
            } else if event.isTextOnLeft {
                
                
                let eventView = RightEventView(frame: CGRect())
                eventView.titleLabel.text = event.name
                
                let xEndCoordinate = bounds.minX + CGFloat(event.endYear! - startDate) * spaceBetweenDateLines + leftOffset
                let yCoordinate = eventsMinYCoordinate + CGFloat(event.rowNumber) * eventRowHeight
                let timeLineViewWidth = CGFloat(event.endYear! - event.startYear) * spaceBetweenDateLines - 1;
                let eventViewWidth = event.name.width(withConstrainedHeight: 21.0, font: eventView.titleLabel.font) + LeftEventView.horizontalSpace
                let finalWidth = max(eventViewWidth, timeLineViewWidth)
                let eventRect = CGRect(x: xEndCoordinate - finalWidth, y: yCoordinate, width: finalWidth, height: LeftEventView.viewHeight)
                eventView.frame = eventRect
                eventView.timeLineViewWidthConstraint.constant = timeLineViewWidth
                addSubview(eventView)
                
                
            } else if !event.isTextOnLeft {
                
                let eventView = LeftEventView(frame: CGRect())
                eventView.titleLabel.text = event.name
                
                let xCoordinate = bounds.minX + CGFloat(event.startYear - startDate) * spaceBetweenDateLines + leftOffset
                let yCoordinate = eventsMinYCoordinate + CGFloat(event.rowNumber) * eventRowHeight
                let timeLineViewWidth = CGFloat(event.endYear! - event.startYear) * spaceBetweenDateLines - 1;
                let eventViewWidth = event.name.width(withConstrainedHeight: 21.0, font: eventView.titleLabel.font) + LeftEventView.horizontalSpace
                let finalWidth = max(eventViewWidth, timeLineViewWidth)
                let eventRect = CGRect(x: xCoordinate, y: yCoordinate, width: finalWidth, height: LeftEventView.viewHeight)
                eventView.frame = eventRect
                eventView.timeLineViewWidthConstraint.constant = timeLineViewWidth
                addSubview(eventView)
            }
        }
    }
    
    private func addMinistersViews() {
        let yCoordinate = bounds.minY + topOffset + personsSectionHeight
        for minister in ministers {
            addPersonView(for: minister, tapIsEnabled: true, yCoordinate: yCoordinate)
        }
    }
    
    private func addGovernerViews() {
        let yCoordinate = bounds.minY + topOffset
        for governer in governers {
            addPersonView(for: governer, tapIsEnabled: false, yCoordinate: yCoordinate)
        }
    }
    
    private func addPersonView(for person: Person, tapIsEnabled: Bool, yCoordinate: CGFloat) {        
        let xCoordinate = bounds.minX + CGFloat(person.startYear - startDate) * spaceBetweenDateLines + leftOffset
        let width = CGFloat(person.endYear - person.startYear) * spaceBetweenDateLines - 1
        let rect = CGRect(x: xCoordinate, y: yCoordinate, width: width, height: personsSectionHeight - verticalOffset)
        let personView = PersonView(frame: rect)
        personView.person = person
        personView.nameLabel.text = person.name
        addSubview(personView)
        if tapIsEnabled {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(personTapGestureAction))
            personView.addGestureRecognizer(tapGestureRecognizer)
            addSubview(personView)
        }
    }
    
    
    @objc func personTapGestureAction(tapGesture: UITapGestureRecognizer) {
        if let personView = tapGesture.view as? PersonView {
            delegate?.didSelect(person: personView.person)
        }
    }
}
