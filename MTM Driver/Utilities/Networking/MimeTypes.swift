//
//  MimeTypes.swift
//  Populaw
//
//  Created by Gaurang on 02/12/21.
//

import Foundation
import UIKit

final class MimeTypes {

    static let mimeTypes = [
        "doc": "application/msword",
        "pdf": "application/pdf",
        "docx": "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    ]

    var data: Data
    var mimeType: String
    var fileName: String
    var key: String

    init?(_ file: Any, key: String) {
        self.key = key
        var mimeType: String?
        var fileData: Data?
        var fileName = ""
        if let image = file as? UIImage {
            if let data = image.getData(inKb: 500) {
                fileData = data
                mimeType = "image/jpeg"
                fileName = "\(Helper.randomString(length: 10)).jpeg"
            }
        } else if let url = file as? URL {
            fileData = try? Data(contentsOf: url)
            mimeType = MimeTypes.mimeTypes[url.pathExtension]
            fileName = "\(Helper.randomString(length: 10)).\(url.pathExtension)"
        }
        if let unwrappedData = fileData, let unwrappedMimeType = mimeType {
            self.data = unwrappedData
            self.mimeType = unwrappedMimeType
            self.fileName = fileName
        } else {
            return nil
        }
    }

}
