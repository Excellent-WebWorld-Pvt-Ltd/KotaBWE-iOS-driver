//
//  GallaryVC.swift
//  DSP Driver
//
//  Created by Admin on 13/12/21.
//  Copyright © 2021 baps. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

struct ImageData{
    var img : UIImage!
}

class GalaryVC: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var collectionGalary: UICollectionView!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblNumberofImage: UILabel!
    
    //MARK:- Varibles and Properties
//    var arrImage = [ImageData]()
    var arrImage : [String] = []
    var firstTimeSelectedIndex = 0
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // btnNext.tintColor = UIColor.appColor(ThemeColor.ThemePlaceHolderTextColor)
        //btnPrevious.tintColor = UIColor.appColor(ThemeColor.ThemePlaceHolderTextColor)
        collectionGalary.delegate = self
        collectionGalary.dataSource = self
//        arrImages[selectedIndex]
        
        lblNumberofImage.text = "1" + " / " + "\(arrImage.count)"
//        self.moveITem(to: self.firstTimeSelectedIndex, direction: .right,animated: false)
//        self.showHUD()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//            self.hideHUD()
            self.moveITem(to: self.firstTimeSelectedIndex, direction: .left,animated: false)
        })
//        Do any additional setup after loading the view.
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func btnPreviousTap(_ sender: Any) {
        
//        let visibleItems: NSArray = self.collectionGalary.indexPathsForVisibleItems as NSArray
//        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
////        lblNumberofImage.text = "\(currentItem.row)" + "/" + "\(arrImage.count)"
//        let nextItem: IndexPath = IndexPath(item: currentItem.item - 1, section: 0)
////        lblNumberofImage.text = "\(nextItem.row)" + "/" + "\(arrImage.count)"
////        lblNumberofImage.text =
//        if nextItem.row < arrImages.count && nextItem.row >= 0{
//        self.collectionGalary.scrollToItem(at: nextItem, at: .right, animated: true)
//            lblNumberofImage.text = "\(nextItem.row+1)" + " / " + "\(arrImages.count)"
//        }
        
        let visibleItems: NSArray = self.collectionGalary.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
//        lblNumberofImage.text = "\(currentItem.row)" + "/" + "\(arrImage.count)"
        let nextItem: IndexPath = IndexPath(item: currentItem.item - 1, section: 0)
//        lblNumberofImage.text = "\(nextItem.row)" + "/" + "\(arrImage.count)"
//        lblNumberofImage.text =
        if nextItem.row < arrImage.count && nextItem.row >= 0{
//            self.collectionGalary.scrollToItem(at: nextItem, at: .right, animated: true)
//            let count = nextItem.row+1 > 9 ? "\(nextItem.row+1)" : "0\(nextItem.row+1)"
//            lblNumberofImage.text = "\(count)" + "/" + "\(arrImage.count)"
            self.moveITem(to: nextItem.row, direction: .left,animated: true)
        }
    }
    func moveITem(to index:Int, direction: UICollectionView.ScrollPosition,animated: Bool) {
        
        self.collectionGalary.scrollToItem(at: IndexPath(item: index, section: 0), at: direction, animated: animated)
        let count = index+1 > 9 ? "\(index+1)" : "\(index+1)"
        let totalCount = arrImage.count > 9 ? "\(arrImage.count)" : "\(arrImage.count)"
        lblNumberofImage.text = "\(count)" + " / " + "\(totalCount)"
    }
    
    @IBAction func btnCancelTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnTrashTap(_ sender: Any) {
    }
    
    @IBAction func btnNextTap(_ sender: Any) {
//        let visibleItems: NSArray = self.collectionGalary.indexPathsForVisibleItems as NSArray
//        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
////        lblNumberofImage.text = "\(currentItem.row)" + "/" + "\(arrImage.count)"
//        let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
////        lblNumberofImage.text = "\(nextItem.row)" + "/" + "\(arrImage.count)"
//
//        if nextItem.row < arrImages.count {
//        self.collectionGalary.scrollToItem(at: nextItem, at: .left, animated: true)
//            lblNumberofImage.text = "\(nextItem.row+1)" + " / " + "\(arrImages.count)"
//        }
        let visibleItems: NSArray = self.collectionGalary.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
//        lblNumberofImage.text = "\(currentItem.row)" + "/" + "\(arrImage.count)"
        let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
//        lblNumberofImage.text = "\(nextItem.row)" + "/" + "\(arrImage.count)"
        
        if nextItem.row < arrImage.count {
            self.moveITem(to: nextItem.row, direction: .right,animated: true)
        }
    }
}

//MARK:- UICollectionview Delegate and DataSourse Methods

extension GalaryVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalaryCell", for: indexPath)as! GalaryCell
        let strUrl = "\(NetworkEnvironment.baseImageURL)\(arrImage[indexPath.row])"
       // cell.imgGalary.showin
        cell.imgGalary.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage())
       
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectedIndex = indexPath.row
//        print("delegate called")
//        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerPoint = CGPoint(x: collectionGalary.bounds.midX, y: collectionGalary.bounds.midY)
                       if let indexPath = collectionGalary.indexPathForItem(at: centerPoint) {
                           print(indexPath.row)
                        lblNumberofImage.text = "\(indexPath.row + 1)" + " / " + "\(arrImage.count)"
                     }
                  }
           }

//MARK:- ===== Gallery CollectionView Cell ======
class GalaryCell : UICollectionViewCell{
    
    //MARK:- ===== Outlets ======
    @IBOutlet weak var imgGalary: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

