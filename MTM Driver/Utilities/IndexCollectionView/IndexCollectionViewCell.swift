//
//  NumberCollectionViewCell.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 15/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

class IndexCollectionViewCell: UICollectionViewCell {

    
    var selectedIndex = 0
    
    var labelNumber : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    var viewLine1 : UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    var viewLine2 : UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(labelNumber)
        addSubview(viewLine1)
        addSubview(viewLine2)
        addVisualFormatConstraints(format: "H:|[v0][v1][v2]|", views: labelNumber,viewLine1,viewLine2)
        addVisualFormatConstraints(format: "V:|[v0]|", views: labelNumber)

        NSLayoutConstraint(item: viewLine1, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: viewLine2, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: labelNumber, attribute: .width, relatedBy: .equal, toItem: labelNumber, attribute:.height, multiplier: 1.0, constant:0.0).isActive = true
        NSLayoutConstraint(item: viewLine2, attribute: .width, relatedBy: .equal, toItem: viewLine1, attribute:.width, multiplier: 1.0, constant:0.0).isActive = true
        NSLayoutConstraint(item: viewLine1, attribute: .height, relatedBy: .equal, toItem: viewLine1, attribute:.height, multiplier: 0.0, constant:2.0).isActive = true
        NSLayoutConstraint(item: viewLine2, attribute: .height, relatedBy: .equal, toItem: viewLine1, attribute:.height, multiplier: 1.0, constant:0.0).isActive = true

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(index: Int,
               selectedIndex: Int,
               count: Int,
               isCircle : Bool,
               textColor: UIColor,
               selectedTextColor : UIColor,
               backgroundColor : UIColor,
               selectedBgColor: UIColor){
        
        labelNumber.text = String(describing: index + 1)
        labelNumber.textColor = textColor
        labelNumber.backgroundColor = backgroundColor
        viewLine1.backgroundColor = backgroundColor
        viewLine2.backgroundColor = backgroundColor
        
        if index <= selectedIndex{
            labelNumber.textColor = selectedTextColor
            labelNumber.backgroundColor = selectedBgColor
            viewLine1.backgroundColor = selectedBgColor
            viewLine2.backgroundColor = selectedBgColor
        }
        if isCircle{
            labelNumber.layer.cornerRadius = bounds.height / 2
            labelNumber.clipsToBounds = true
        }
        if index == selectedIndex{
            viewLine1.backgroundColor = selectedBgColor
            viewLine2.backgroundColor = backgroundColor
        }
        if index == count - 1{
            viewLine1.backgroundColor = .clear
            viewLine2.backgroundColor = .clear
        }
    }

}
