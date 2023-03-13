//
//  DocumentPicker.swift
//  MTM Driver
//
//  Created by Gaurang on 24/11/22.
//  Copyright © 2022 baps. All rights reserved.
//

import Foundation
import UIKit

enum DocumentPickerFileType: CaseIterable {
    case camera
    case image
    case pdf
}

class DocumentPickerController: NSObject {
    
    private lazy var pickerController = UIImagePickerController()
    private weak var presentationController: UIViewController?
    private let completion: (_ data: Any?) -> Void
    private let allowEditing: Bool
    private let fileType: [DocumentPickerFileType]

    init(from presentationController: UIViewController,
         allowEditing: Bool,
         fileType: [DocumentPickerFileType],
         completion: @escaping (_ data: Any) -> Void) {
        self.completion = completion
        self.allowEditing = allowEditing
        self.fileType = fileType
        self.presentationController = presentationController
        super.init()
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            if type == .camera {
                self.presentCamera()
            } else {
                self.presentImageSelection()
            }
        }
    }
    
    private func presentCamera() {
        AppDelegate.hasCameraAccess { granted in
            if granted {
                AppDelegate.shared.setupNavigationAppearance(darkStyle: false)
                self.pickerController.mediaTypes = ["public.image"]
                self.pickerController.delegate = self
                self.pickerController.sourceType = .camera
                self.pickerController.allowsEditing = self.allowEditing
                self.presentationController?.present(self.pickerController, animated: true)
            }
        }
    }
    
    private func presentImageSelection() {
        AppDelegate.hasPhotoLibraryAccess { granted in
            if granted {
                AppDelegate.shared.setupNavigationAppearance(darkStyle: false)
                self.pickerController.mediaTypes = ["public.image"] // check error and crash
                self.pickerController.delegate = self
                self.pickerController.sourceType = .photoLibrary
                self.pickerController.allowsEditing = self.allowEditing
                self.presentationController?.present(self.pickerController, animated: true)
            }
        }
    }

    public func present(from sourceView: UIView) {
        let alertController = UIAlertController(title: Messages.chooseSource.localized,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        for type in fileType {
            switch type {
            case .camera:
                if let action = self.action(for: .camera, title: "Camera".localized) {
                    alertController.addAction(action)
                }
            case .image:
                if let action = self.action(for: .photoLibrary, title: "Photo Library".localized) {
                    alertController.addAction(action)
                }
            case .pdf:
                let action = UIAlertAction(title: "PDF".localized, style: .default) { _ in
                    self.pickDocumentTapped()
                }
                alertController.addAction(action)
            }
        }
        alertController.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel) { _ in
            self.completion(nil)
        })
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        self.presentationController?.present(alertController, animated: true)
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage) {
        self.completion(image)
        controller.dismiss(animated: true, completion: nil)

    }

    func pickDocumentTapped() {
        AppDelegate.shared.setupNavigationAppearance(darkStyle: false)
        let docsTypes: [String] = ["com.adobe.pdf"]
        let documentPicker = UIDocumentPickerViewController(documentTypes: docsTypes, in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        if #available(iOS 13.0, *) {
            documentPicker.shouldShowFileExtensions = true
        }
        presentationController?.present(documentPicker, animated: true)
    }
}

extension DocumentPickerController: UIImagePickerControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        AppDelegate.shared.setupNavigationAppearance()
        picker.dismiss(animated: true)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        AppDelegate.shared.setupNavigationAppearance()
        guard let image = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage) else {
            self.completion(nil)
            picker.dismiss(animated: true)
            return
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension DocumentPickerController: UIDocumentPickerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        self.completion(urls[0])
        AppDelegate.shared.setupNavigationAppearance()
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
        AppDelegate.shared.setupNavigationAppearance()
        self.completion(nil)
    }
}

extension DocumentPickerController: UINavigationControllerDelegate {
}
