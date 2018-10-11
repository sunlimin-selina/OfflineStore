//
//  DDCSubmitButton.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/9.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

enum SubmitButtonType : UInt{
    case SubmitButtonTypeDefault
    case SubmitButtonTypeNext
    case SubmitButtonTypeCommit
    case SubmitButtonTypeUnCommittable
}

class DDCSubmitButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(hex: "#A5A4A4")
        self.layer.cornerRadius = 22.5
        self.layer.shadowColor = UIColor.init(hex: "#A5A4A4").cgColor
        self.layer.shadowRadius = 6.0
        self.layer.shadowOffset = CGSize.init(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 0.6
        self.setImage(UIImage.init(named: "sign_btn_next"), for: .normal)
        self.adjustsImageWhenDisabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    func enableButtonWithType(type : SubmitButtonType) {
        switch type {
        case .SubmitButtonTypeCommit:
            do {
                self.backgroundColor = UIColor.init(hex: "#FF5D31")
                self.layer.shadowColor = UIColor.init(hex: "#FF5D31").cgColor;
                self.setImage(UIImage.init(named: "sign_btn_finish"), for: .normal)
            }
        case .SubmitButtonTypeNext:
            do {
                self.backgroundColor = UIColor.init(hex: "#FF5D31")
                self.layer.shadowColor = UIColor.init(hex: "#FF5D31").cgColor
                self.setImage(UIImage.init(named: "sign_btn_next"), for: .normal)

            }
        case .SubmitButtonTypeUnCommittable:
            do {
                self.backgroundColor = UIColor.init(hex: "#A5A4A4")
                self.layer.shadowColor = UIColor.init(hex: "#A5A4A4").cgColor
                self.setImage(UIImage.init(named: "sign_btn_finish"), for: .normal)

            }
        default:
            do {
                self.backgroundColor = UIColor.init(hex: "#A5A4A4")
                self.layer.shadowColor = UIColor.init(hex: "#A5A4A4").cgColor
                self.setImage(UIImage.init(named: "sign_btn_next"), for: .normal)
            }
        }
    }
}
