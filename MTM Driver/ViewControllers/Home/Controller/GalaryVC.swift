//
//  GalaryVC.swift
//
//  Created by Raju Gupta on 09/02/21.
//

import UIKit
import SDWebImage

struct ImageData{
    var img : UIImage!
}

class GalaryVC: UIViewController {
    
    //MARK: - Propertise
    @IBOutlet weak var collectionGalary: UICollectionView!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblNumberofImage: UILabel!
    
    var arrImage : [String] = []
    var firstTimeSelectedIndex = 0
    var isFromEdit = false
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        btnNext.tintColor = UIColor.appColor(ThemeColor.ThemePlaceHolderTextColor)
        btnPrevious.tintColor = UIColor.appColor(ThemeColor.ThemePlaceHolderTextColor)
        collectionGalary.delegate = self
        collectionGalary.dataSource = self
        lblNumberofImage.text = "1" + " / " + "\(arrImage.count)"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.moveITem(to: self.firstTimeSelectedIndex, direction: .left,animated: false)
        })
    }
    
    //MARK: - Custom Method
    func moveITem(to index:Int, direction: UICollectionView.ScrollPosition,animated: Bool) {
        self.collectionGalary.scrollToItem(at: IndexPath(item: index, section: 0), at: direction, animated: animated)
        let count = index+1 > 9 ? "\(index+1)" : "\(index+1)"
        let totalCount = arrImage.count > 9 ? "\(arrImage.count)" : "\(arrImage.count)"
        lblNumberofImage.text = "\(count)" + " / " + "\(totalCount)"
    }
    
    //MARK: - IBAction Methods
    @IBAction func btnPreviousTap(_ sender: Any) {
        let visibleItems: NSArray = self.collectionGalary.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item - 1, section: 0)
        if nextItem.row < arrImage.count && nextItem.row >= 0{
            self.moveITem(to: nextItem.row, direction: .left,animated: true)
        }
    }
    
    @IBAction func btnCancelTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnNextTap(_ sender: Any) {
        let visibleItems: NSArray = self.collectionGalary.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
        if nextItem.row < arrImage.count {
            self.moveITem(to: nextItem.row, direction: .right,animated: true)
        }
    }
}

//MARK: - UICollectionView Delegate and DataSource Methods
extension GalaryVC : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalaryCell.className, for: indexPath)as! GalaryCell
        cell.imgGalary.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgGalary.sd_setImage(with: URL(string: arrImage[indexPath.row]), placeholderImage: UIImage())
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerPoint = CGPoint(x: collectionGalary.bounds.midX, y: collectionGalary.bounds.midY)
        if let indexPath = collectionGalary.indexPathForItem(at: centerPoint) {
            print(indexPath.row)
            lblNumberofImage.text = "\(indexPath.row + 1)" + " / " + "\(arrImage.count)"
        }
    }
}
