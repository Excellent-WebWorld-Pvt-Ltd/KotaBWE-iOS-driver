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

class GalaryVC: UIViewController {

    //MARK:- IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    //MARK:- Varibles and Properties
//    var arrImage = [ImageData]()
    var Image = ""
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.setImageWithUrl(byAdding: Image)
     }
    
    //MARK: - IBAction Methods
    
    @IBAction func btnCancelTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
