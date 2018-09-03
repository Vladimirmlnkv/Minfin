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
    func didSelect(detailInfo: DetailInfo)
}

class TimeLineContentView: UIView {

    private let startDate = 1800
    private let finalDate = 2019
    private let spaceBetweenDateLines: CGFloat = 45.0
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
    var ministersClusters = [Cluster]()
    var governorsClusters = [Cluster]()
    
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
        addClustersViews()
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
    
    private func addClustersViews() {
        let yCoordinate = bounds.minY + topOffset + personsSectionHeight
        for cluster in ministersClusters {
            addClusterView(for: cluster, yCoordinate: yCoordinate, title: AppLanguage.multiple_ministers.customLocalized(), isInteractionEnabled: true)
        }
        for cluster in governorsClusters {
            addClusterView(for: cluster, yCoordinate: bounds.minY + topOffset, title: AppLanguage.multiple_governers.customLocalized(), isInteractionEnabled: false)
        }
    }
    
    private func addClusterView(for cluster: Cluster, yCoordinate: CGFloat, title: String, isInteractionEnabled: Bool) {
        let xCoordinate = bounds.minX + CGFloat(cluster.startYear - startDate) * spaceBetweenDateLines + leftOffset
        let width = CGFloat(cluster.endYear - cluster.startYear) * spaceBetweenDateLines - 1
        let rect = CGRect(x: xCoordinate, y: yCoordinate, width: width, height: personsSectionHeight - verticalOffset)
        let clusterView = ClusterView(frame: rect)
        clusterView.cluster = cluster
        clusterView.numberLabel.text = "+\(cluster.persons.count)"
        clusterView.titleLabel.text = title
        addSubview(clusterView)
        if isInteractionEnabled {
            let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(clusterTapGestureAction))
            pressGesture.minimumPressDuration = 0.05
            clusterView.addGestureRecognizer(pressGesture)
        } else {
            let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(governersTapGestureAction))
            pressGesture.minimumPressDuration = 0.05
            clusterView.addGestureRecognizer(pressGesture)
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
                if event.photoUrl != "" {
                    eventView.imageView.image = UIImage(named: event.photoUrl)
                }
                eventView.event = event
                eventView.titleLabel.text = event.name

                let eventViewWidth = event.name.width(withConstrainedHeight: 21.0, font: eventView.titleLabel.font) + SingleEventView.horizontalSpace
                let eventRect = CGRect(x: xCenterCoordinate - eventViewWidth / 2, y: yCoordinate, width: eventViewWidth, height: eventRowHeight - 5)
                eventView.frame = eventRect
                addSubview(eventView)
                eventView.updateCornerRadiuses()
                let tapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(tapGestureAction))
                tapGestureRecognizer.minimumPressDuration = 0.05
                eventView.addGestureRecognizer(tapGestureRecognizer)
            } else if event.isTextOnLeft {
                let eventView = RightEventView(frame: CGRect())
                eventView.titleLabel.text = event.name
                eventView.event = event
                if event.photoUrl != "" {
                    eventView.imageView.image = UIImage(named: event.photoUrl)
                }
                let xEndCoordinate = bounds.minX + CGFloat(event.endYear! - startDate) * spaceBetweenDateLines + leftOffset
                let yCoordinate = eventsMinYCoordinate + CGFloat(event.rowNumber) * eventRowHeight
                let timeLineViewWidth = CGFloat(event.endYear! - event.startYear) * spaceBetweenDateLines - 1;
                let finalWidth = width(for: event, font: eventView.titleLabel.font, timeLineViewWidth: timeLineViewWidth)
                let eventRect = CGRect(x: xEndCoordinate - finalWidth, y: yCoordinate, width: finalWidth, height: eventRowHeight - 20)
                eventView.frame = eventRect
                eventView.timeLineViewWidthConstraint.constant = timeLineViewWidth
                addSubview(eventView)
                let tapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(tapGestureAction))
                tapGestureRecognizer.minimumPressDuration = 0.05
                eventView.addGestureRecognizer(tapGestureRecognizer)
            } else if !event.isTextOnLeft {
                
                let eventView = LeftEventView(frame: CGRect())
                eventView.titleLabel.text = event.name
                eventView.event = event
                if event.photoUrl != "" {
                    eventView.imageView.image = UIImage(named: event.photoUrl)
                }
                let xCoordinate = bounds.minX + CGFloat(event.startYear - startDate) * spaceBetweenDateLines + leftOffset
                let yCoordinate = eventsMinYCoordinate + CGFloat(event.rowNumber) * eventRowHeight
                let timeLineViewWidth = CGFloat(event.endYear! - event.startYear) * spaceBetweenDateLines - 1;
                let finalWidth = width(for: event, font: eventView.titleLabel.font, timeLineViewWidth: timeLineViewWidth)
                let eventRect = CGRect(x: xCoordinate, y: yCoordinate, width: finalWidth, height: eventRowHeight - 20)
                eventView.frame = eventRect
                eventView.timeLineViewWidthConstraint.constant = timeLineViewWidth
                addSubview(eventView)
                
                if event.needToCenterContent {
                    eventView.viewLeadingConstraint.isActive = false
                    eventView.viewTrailingConstraint.isActive = false
                    eventView.labelTrailingConstraint.isActive = false
                    
                    let centerConstraint = NSLayoutConstraint(item: eventView.centerContainerView, attribute: .centerX, relatedBy: .equal, toItem: eventView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
                    let trailingConstraint = NSLayoutConstraint(item: eventView.titleLabel, attribute: .trailing, relatedBy: .equal, toItem: eventView.centerContainerView, attribute: .trailing, multiplier: 1.0, constant: 8.0)
                    eventView.addConstraints([centerConstraint, trailingConstraint])
                }
                
                let tapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(tapGestureAction))
                tapGestureRecognizer.minimumPressDuration = 0.05
                eventView.addGestureRecognizer(tapGestureRecognizer)
            }
        }
    }
    
    private func width(for event: Event, font: UIFont, timeLineViewWidth: CGFloat) -> CGFloat {
        let textLines = event.name.components(separatedBy: "\n")
        var maxTextWidth: CGFloat = 0
        for t in textLines {
            //set propper image width instead of 50.0
            let width = t.width(withConstrainedHeight: 21.0, font: font) + LeftEventView.horizontalSpace + 50
            maxTextWidth = max(maxTextWidth, width)
        }
        return max(maxTextWidth, timeLineViewWidth)
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
        let width = CGFloat(person.endYear! - person.startYear) * spaceBetweenDateLines - 1
        let rect = CGRect(x: xCoordinate, y: yCoordinate, width: width, height: personsSectionHeight - verticalOffset)
        let personView = PersonView(frame: rect)
        if person.photoUrl != "" {
            personView.imageView.image = UIImage(named: person.photoUrl)
        }
        personView.person = person
        personView.nameLabel.text = person.name
        addSubview(personView)
        if tapIsEnabled {
            let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(tapGestureAction))
            pressGesture.minimumPressDuration = 0.05
            personView.addGestureRecognizer(pressGesture)
        }
    }
    
    @objc func governersTapGestureAction(tapGesture: UITapGestureRecognizer) {
        if let clusterView = tapGesture.view as? ClusterView {
            animate(backgroundViews: [clusterView.backgroundView], for: tapGesture, completion: {
                self.handleClusterTapGesture(for: clusterView, shouldOpenDetails: false)
            })
        }
    }
    
    @objc func clusterTapGestureAction(tapGesture: UITapGestureRecognizer) {
        if let clusterView = tapGesture.view as? ClusterView {
            animate(backgroundViews: [clusterView.backgroundView], for: tapGesture, completion: {
                self.handleClusterTapGesture(for: clusterView, shouldOpenDetails: true)
            })
        }
    }
    
    private func handleClusterTapGesture(for clusterView: ClusterView, shouldOpenDetails: Bool) {
        if let detailsView = clusterView.detailsClusterView {
            detailsView.removeFromSuperview()
            clusterView.detailsClusterView = nil
        } else {
            var width: CGFloat
            var height: CGFloat
            if clusterView.cluster.persons.count <= 3 {
                height = CGFloat(55 * clusterView.cluster.persons.count)
                width = 4 * spaceBetweenDateLines
            } else {
                let multiplier = clusterView.cluster.persons.count % 2 == 0 ? clusterView.cluster.persons.count / 2 : (clusterView.cluster.persons.count + 1) / 2
                height = CGFloat(55 * multiplier)
                width = 9 * spaceBetweenDateLines
            }
            let detailsRect = CGRect(x: clusterView.frame.midX - width / 2, y: clusterView.frame.maxY + verticalOffset, width: width, height: height + 20)
            let clusterDetailsView = ClusterDetailsContainerView(frame: detailsRect)
            clusterDetailsView.allowsSelection = shouldOpenDetails
            if shouldOpenDetails {
                clusterDetailsView.delegate = self
            }
            clusterDetailsView.cluster = clusterView.cluster
            addSubview(clusterDetailsView)
            clusterView.detailsClusterView = clusterDetailsView
        }
    }
    
    private func animate(backgroundViews: [UIView], for tapGesture: UITapGestureRecognizer, completion: @escaping () -> Void) {
        if tapGesture.state == .began {
            UIView.animate(withDuration: 0.3, animations: {
                for view in backgroundViews {
                    view.alpha = 0.5
                }
            })
        } else if tapGesture.state == .ended {
            UIView.animate(withDuration: 0.3, animations: {
                for view in backgroundViews {
                    view.alpha = 0
                }
            })
            completion()
        }
    }
    
    @objc func tapGestureAction(tapGesture: UITapGestureRecognizer) {
        if let personView = tapGesture.view as? PersonView {
            animate(backgroundViews: [personView.backgroundView], for: tapGesture, completion: {
                self.delegate?.didSelect(detailInfo: personView.person)
            })
        } else if let eventView = tapGesture.view as? EventView {
            animate(backgroundViews: eventView.backgroundViews, for: tapGesture, completion: {
                self.delegate?.didSelect(detailInfo: eventView.event)
            })
        }
    }
}

extension TimeLineContentView: ClusterDetailsContainerViewDelegate {
    
    func didSelect(person: Person) {
        delegate?.didSelect(detailInfo: person)
    }
    
}
