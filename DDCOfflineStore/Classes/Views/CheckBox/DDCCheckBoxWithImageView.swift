//
//  DDCCheckBoxWithImageView.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/5.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCCheckBoxWithImageView: UIControl {
    lazy var imageView: UIImageView = {
        var _imageView = UIImageView()
        _imageView.backgroundColor = UIColor.white
        _imageView.contentMode = .scaleAspectFit
        _imageView.clipsToBounds = true
        return _imageView
    }()
    
    lazy var button: UIButton = {
        var _button = UIButton.init()
        _button.titleLabel!.font = UIFont.systemFont(ofSize: 12.0)
        _button.setTitleColor(UIColor.black, for: .normal)
        _button.setTitleColor(UIColor.black, for: .selected)

        _button.setImage(UIImage.init(named: "hdxq_btn_normal"), for: .normal)
        _button.setImage(UIImage.init(named: "hdxq_btn_normal"), for: .selected)

        _button.titleLabel!.lineBreakMode = .byCharWrapping
        _button.titleLabel!.numberOfLines = 2
        _button.titleLabel!.textAlignment = .right
        _button.contentHorizontalAlignment = .left
        _button.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 10.0, bottom: 0, right: 0)
        return _button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.imageView)
        self.addSubview(self.button)
        
        self.setupLayoutConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayoutConstraints() {
        self.imageView.snp.makeConstraints({ (make) in
            make.top.equalTo(self)
            make.width.equalTo(self)
            make.left.greaterThanOrEqualTo(self)
            make.right.lessThanOrEqualTo(self)
            make.bottom.equalTo(self.button.snp_topMargin)
        })
        
        self.button.snp.makeConstraints({ (make) in
            make.top.equalTo(self.imageView.snp_bottomMargin)
            make.width.equalTo(self)
            make.left.greaterThanOrEqualTo(self)
            make.right.lessThanOrEqualTo(self)
            make.height.equalTo(25.0)
            make.bottom.equalTo(self.snp_bottomMargin)
        })
    }
}
