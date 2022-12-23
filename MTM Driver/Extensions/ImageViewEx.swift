//
//  ImageViewEx.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 14/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView{
    func setImageWithBaseImageUrl(byAdding suffix: String,
                                placeholder: UIImage? = nil,
                                isProfileImage: Bool = false) {
        let url = URL(serverPath: suffix)
        let finalPlaceholder = isProfileImage ? AppImages.userPlaceholder.image : placeholder
        self.sd_setImage(with: url, placeholderImage: finalPlaceholder)
    }
}

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}


extension UIImage {
    // MARK: - UIImage+Resize
    func compressTo(kb expectedSizeInKb: Int) -> UIImage? {
        
        if let data = getData(inKb: expectedSizeInKb) {
            return UIImage(data: data)
        }
        return nil
    }
    
    func getData(inKb expectedSizeInKb: Int) -> Data? {
        let sizeInBytes = expectedSizeInKb * 1024
        var needCompress: Bool = true
        var imgData: Data?
        var compressingValue: CGFloat = 1.0
        while needCompress && compressingValue > 0.0 {
            if let data: Data = self.jpegData(compressionQuality: compressingValue) {
                if data.count < sizeInBytes {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                    if compressingValue < 0 {
                        imgData = data
                        needCompress = false
                    }
                }
            }
        }
        return imgData
    }
}

extension URL {
    init?(serverPath: String) {
        self.init(string: NetworkEnvironment.baseImageURL + serverPath)
    }
}
