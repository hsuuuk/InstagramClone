//
//  CustomTextField.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/04/17.
//

import UIKit
import SnapKit

class CustomTextField: UITextField {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        setupSpacer()
        setupProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSpacer() {
        let spacer = UIView()
        
        spacer.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(12)
        }
        
        self.leftView = spacer
        self.leftViewMode = .always
    }
    
    func setupProperties() {
        self.borderStyle = .roundedRect
        self.textColor = .black
        self.keyboardAppearance = .dark
        self.keyboardType = .emailAddress
        self.backgroundColor = UIColor(white: 1, alpha: 0.3)
        self.attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: [.foregroundColor: UIColor.lightGray])
        self.frame.size.height = 50
    }
}
