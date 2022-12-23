//
//  CollumnView.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 16/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

struct Column {
    let image: String
    let title: String
}

class ImageTileView: UIView {

    var dataSource = [Column]()
    
    var noOfColumn = 2
    
    var userIntraction = true {
        didSet{
            collectionView.isUserInteractionEnabled = userIntraction
        }
    }
    
    var didSelectItemAt: ((IndexPath) -> ())?
    
    var itemSize = CGSize(width: 64, height: 88)
    
    var spacing = CGFloat(8)
    
    var scrollToItem = IndexPath(item: 0, section: 0) {
        didSet{
            collectionView.scrollToItem(at: scrollToItem, at: .centeredHorizontally, animated: true)
        }
    }
    
    var imageCornerRadius: CGFloat = 5
    var imageBackgroundColor: UIColor = UIColor(custom: .theme)
    var imageShadowOpticity: Float = 0.0
    var imageShadowColor: CGColor = UIColor.clear.cgColor

    var textColor: UIColor = UIColor(custom: Colors.Accent.theme)
    var font: UIFont = UIFont.bold(ofSize: 18)
    
    lazy private var collectionView : UICollectionView = {
        let layout  = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        layout.scrollDirection = .vertical
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func draw(_ rect: CGRect) {
        customInitialiser()
    }
    
    private func customInitialiser(){
        collectionView.register(TileImageCollectionViewCell.self, forCellWithReuseIdentifier: TileImageCollectionViewCell.identifier)
        collectionView.frame = bounds
        addSubview(collectionView)
    }
}

extension ImageTileView:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TileImageCollectionViewCell.identifier, for: indexPath) as! TileImageCollectionViewCell
        cell.setupImage(image: dataSource[indexPath.item].image,
                   cornerRadius: imageCornerRadius,
                   backgroundColor: imageBackgroundColor,
                   shadowOpticity: imageShadowOpticity,
                   shadowColor: imageShadowColor)
        cell.setupTitle(title: dataSource[indexPath.item].title, textColor: textColor, font: font)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if didSelectItemAt != nil { didSelectItemAt!(indexPath)}
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(dataSource.count % 2 == 0)
        {
            return itemSize
        }
        else
        {
            if(indexPath.row == 0)
            {
                return CGSize(width: itemSize.width*2, height: itemSize.height)
            }
            else
            {
                return itemSize
            }
//            return itemSize
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let cellWidth: CGFloat = itemSize.width
        let cellHeight: CGFloat = itemSize.height
  //      let cellSpacing: CGFloat = flowLayout.minimumInteritemSpacing
        let cellCount = CGFloat(dataSource.count)
        var collectionWidth = collectionView.frame.size.width
        var collectionHeight = collectionView.frame.size.height
        if noOfColumn > dataSource.count { noOfColumn = dataSource.count}
        var floatColumn = CGFloat(noOfColumn)

        if #available(iOS 11.0, *) {
            collectionWidth -= collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right
            collectionHeight -= collectionView.safeAreaInsets.top + collectionView.safeAreaInsets.bottom
        }
        var totalWidth = cellWidth * floatColumn + spacing * (floatColumn )
        
        if totalWidth > collectionWidth{
            floatColumn = CGFloat(Int((collectionWidth - spacing) / (cellWidth + spacing)))
            totalWidth = cellWidth * floatColumn + spacing * (floatColumn )
        }
        let totalHeight = cellHeight * (cellCount / floatColumn) + spacing * ((cellCount / floatColumn ) )
        let edgeInsetWidth = ((collectionWidth - totalWidth) / 2) - spacing
    
        let edgeInsetHieght = ((collectionHeight - totalHeight) / 2) - spacing
        print(edgeInsetHieght, edgeInsetHieght)
       
       if  totalHeight > collectionHeight{
                return UIEdgeInsets(top: 16, left: edgeInsetWidth, bottom: flowLayout.sectionInset.bottom, right: edgeInsetWidth)
           }
        return UIEdgeInsets(top: edgeInsetHieght, left: edgeInsetWidth, bottom: edgeInsetHieght, right: edgeInsetWidth)
        
    }
    
}
