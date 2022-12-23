//
//  TabBarCollectionViewCell.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 01/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

class TitleHeaderCollectionViewCell: UICollectionViewCell {
    
    var headerTitleLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    func setTitle(title: String,
                  textColor : UIColor,
                  font: UIFont){
        headerTitleLabel.text = title
        headerTitleLabel.font = font
        headerTitleLabel.textColor = textColor
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerTitleLabel)
        addVisualFormatConstraints(format: "H:|[v0]|", views: headerTitleLabel)
        addVisualFormatConstraints(format: "V:|[v0]|", views: headerTitleLabel)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class ImagesHeaderCollectionViewCell: UICollectionViewCell {
    var selectedImage = ""
    var unselectedImage = ""
    
    var headerImageView : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    override var isSelected: Bool{
        didSet{
           // tintColor = isSelected ? themeColorYellow : .clear
            headerImageView.image = isSelected ? UIImage(named: selectedImage) : UIImage(named: unselectedImage)
        }
    }
    func setImage(selectedImage: String, unselectedImage : String){
       headerImageView.image = UIImage(named: unselectedImage)
        self.selectedImage = selectedImage
        self.unselectedImage = unselectedImage
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerImageView)
        backgroundColor = .clear
        addVisualFormatConstraints(format: "H:|-10-[v0]-10-|", views: headerImageView)
        addVisualFormatConstraints(format: "V:|-10-[v0]-10-|", views: headerImageView)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
