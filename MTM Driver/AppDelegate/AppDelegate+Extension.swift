//
//  AppDelegate+Extension.swift
//  yousic
//
//  Created by Gaurang Vyas on 29/05/20.
//  Copyright © 2020 Solution Analysts. All rights reserved.
//

import AVKit
import Photos
import UIKit

extension AppDelegate {
    
    static func showAlert(title: String?, message: String?, actions: [UIAlertAction]? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let array = actions {
            array.forEach { alertVC.addAction($0) }
        } else {
            alertVC.addAction(.init(title: "Ok", style: .cancel))
        }
        AppViewControllers.shared.topViewController?.present(alertVC, animated: true)
    }

    static func hasCameraAccess( result: @escaping (_ access: Bool) -> Void) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                DispatchQueue.main.sync {
                    result(granted)
                }
            }
        case .restricted:
            openSettingsDialog(title: Messages.cameraAccess.localized, message: Messages.cameraAccessMsg.localized)
            result(false)
        case .denied:
            openSettingsDialog(title: Messages.cameraAccess.localized, message: Messages.cameraAccessMsg.localized)
                result(false)

        case .authorized:
                 result(true)

        @unknown default:
                result(false)
        }
    }

    static func hasPhotoLibraryAccess( result: @escaping (_ access: Bool) -> Void) {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { granted in
                DispatchQueue.main.async {
                    result(granted == .authorized)
                }
            }
        case .restricted, .denied:
            openSettingsDialog(title: Messages.photoAccess.localized, message: Messages.photoAccessMsg.localized)
            DispatchQueue.main.async {
                result(false)
            }

        case .authorized:
            DispatchQueue.main.async {
                result(true)
            }
        default:
            DispatchQueue.main.async {
                result(true)
            }
        }
    }
    
    static func openSettingsDialog(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let settingsAppURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        AppViewControllers.shared.topViewController?.present(alertVC, animated: true)
    }
}
