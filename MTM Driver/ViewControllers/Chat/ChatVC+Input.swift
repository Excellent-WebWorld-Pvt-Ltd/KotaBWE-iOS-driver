//
//  ChatVC+Input.swift
//  DSP Driver
//
//  Created by Admin on 26/11/21.
//  Copyright © 2021 baps. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift

//MARK:- ===== TextView Delegate Methods ======
extension ChatVC : UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView){
      
    }

    func textViewDidEndEditing(_ textView: UITextView) {
       
    }

    func textViewDidChange(_ textView: UITextView) {
        setSendButtonAppearance()
    }

    func setupKeyboard(_ enable: Bool) {
        IQKeyboardManager.shared.enable = enable
        IQKeyboardManager.shared.enableAutoToolbar = !enable
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = !enable
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
    }


    //MARK: -notification center for Keyboard Hide and Show
    func registerForKeyboardNotifications(){

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWasShown(notification: NSNotification){
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        conBottomChatBox.constant = keyboardSize!.height + 8
        self.animateConstraintWithDuration(duration: duration)

    }

    @objc func keyboardWillBeHidden(notification: NSNotification){
        conBottomChatBox.constant = 30
        self.animateConstraintWithDuration()
    }

    func deregisterFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func animateConstraintWithDuration(duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: {
           // self.inputContrainerView.superview?.layoutIfNeeded()
        })
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension ChatVC {

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tblChatHistory.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
