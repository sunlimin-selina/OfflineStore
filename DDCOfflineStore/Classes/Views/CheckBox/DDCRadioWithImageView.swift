//
//  DDCRadioWithImageView.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/5.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCRadioWithImageView: UIControl {
    enum DDCRadioStatus : UInt {
        case normal
        case image
    }

    lazy var button: UIButton = {
        var _button = UIButton.init()
        _button.titleLabel!.font = UIFont.systemFont(ofSize: 20.0)
        _button.setTitleColor(DDCColor.fontColor.gray, for: .normal)
        _button.setTitleColor(DDCColor.fontColor.black, for: .selected)

        _button.setImage(UIImage.init(named: "icon_selection_desselected"), for: .normal)
        _button.setImage(UIImage.init(named: "icon_selection_selected"), for: .selected)

        _button.titleLabel!.lineBreakMode = .byCharWrapping
        _button.titleLabel!.numberOfLines = 2
        _button.titleLabel!.textAlignment = .right
        _button.contentHorizontalAlignment = .left
        _button.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 10.0, bottom: 0, right: 0)
        _button.isUserInteractionEnabled = false
        return _button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.button)
        self.setupLayoutConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayoutConstraints() {
        self.button.snp.makeConstraints({ (make) in
            make.width.equalTo(self)
            make.left.greaterThanOrEqualTo(self)
            make.right.lessThanOrEqualTo(self)
            make.height.equalTo(30.0)
            make.bottom.equalTo(self.snp_bottomMargin)
        })
    }
}
