//
//  Extension.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/04/17.
//

import UIKit
import JGProgressHUD

extension UIViewController {
    static let hud = JGProgressHUD(style: .dark)
    
    func showLoader(_ show: Bool) {
        view.endEditing(true)
        
        if show {
            UIViewController.hud.show(in: view)
        } else {
            UIViewController.hud.dismiss()
        }
    }
}

extension UIButton {
    func attributedTitle(firstPart: String, secondPart: String) {
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.gray, .font: UIFont.systemFont(ofSize: 16)]
        let attributedTitle = NSMutableAttributedString(string: "\(firstPart) ", attributes: atts)
        let boldAtts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemBlue, .font: UIFont.systemFont(ofSize: 16, weight: .black),]
        attributedTitle.append(NSAttributedString(string: secondPart, attributes: boldAtts))
        
        setAttributedTitle(attributedTitle, for: .normal)
    }
}

extension Date {
    func dateToString() -> String {
        let formatter = Foundation.DateFormatter()
        formatter.dateFormat = "yyyy년 M월 dd일"
        return formatter.string(from: self)
    }
    
    func relativeTime() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .day], from: self , to: Date())
        let hour = components.hour ?? 0
        let day = components.day ?? 0
        
        if day > 6 {
            let weeks = day / 7
            return "\(weeks)주 전"
        } else if day <= 6 && day > 0 {
            return "\(day)일 전"
        } else if hour < 24 && hour > 1 {
            return "\(hour)시간 전"
        } else {
            return "방금 전"
        }
    }
}
