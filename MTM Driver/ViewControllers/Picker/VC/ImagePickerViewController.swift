//
//  ImagePickerViewController.swift
//  Peppea-Driver
//
//  Created by EWW-iMac Old on 26/06/19.
//  Copyright © 2019 Excellent WebWorld. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
class ImagePickerViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: ThemeLabel!
    @IBOutlet weak var lblCamera: UILabel!
    @IBOutlet weak var lblGallery: UILabel!
    
    static func open(from viewCtr: UIViewController, allowEditing: Bool, completion: @escaping (_ image: UIImage) -> Void) {
        let imageVC : ImagePickerViewController = UIViewController.viewControllerInstance(storyBoard: .picker)
        imageVC.onDismiss = completion
        imageVC.allowEditing = allowEditing
        viewCtr.present(imageVC, animated: true)
    }
    
    @IBOutlet weak var bluryView : UIView!
    
    var onDismiss : ((_ image: UIImage) -> Void)?
    var imageFormat = ""
    var imageName = ""
    var allowEditing = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bluryView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bluryView.layer.cornerRadius = 16
        bluryView.clipsToBounds = true
        self.localization()
    }
    
    func localization(){
        self.lblTitle.text = "Select source".localized
        self.lblCamera.text = "Take From Camera".localized
        self.lblGallery.text = "Select From Gallery".localized
    }
    
    var pickedImage = UIImage()
    
    @IBAction func dismissAction() {
        self.dismiss(animated: true)
    }
    
    @IBAction func pickFromCamera(_ sender: UIButton){
        pickingImageFromGallery(fromCamera: true)
    }
    @IBAction func pickFromGallery(_ sender: UIButton){
        pickingImageFromGallery(fromCamera: false)
    }
    func pickingImageFromGallery(fromCamera: Bool, hasAccess: Bool = false) {
        if hasAccess {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = allowEditing
            
            if fromCamera {
                if !UIImagePickerController.isSourceTypeAvailable(.camera){
                    AlertMessage.showMessageForError("Your device does not have camera".localized)
                    return
                }
            }
            
            picker.sourceType = fromCamera ? .camera : .photoLibrary
            
            present(picker, animated: true, completion: nil)
        } else {
            if fromCamera {
                AppDelegate.hasCameraAccess { [unowned self] access in
                    if access {
                        self.pickingImageFromGallery(fromCamera: fromCamera, hasAccess: true)
                    }
                }
            } else {
                AppDelegate.hasPhotoLibraryAccess { [unowned self] access in
                    if access {
                        self.pickingImageFromGallery(fromCamera: fromCamera, hasAccess: true)
                    }
                }
            }
        }
    }
}
extension ImagePickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.editedImage] as? UIImage {
            self.pickedImage = pickedImage
        } else if let pickedImage = info[.originalImage] as? UIImage {
            self.pickedImage = pickedImage
        }
        onDismiss?(self.pickedImage)
        picker.dismiss(animated: true) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
