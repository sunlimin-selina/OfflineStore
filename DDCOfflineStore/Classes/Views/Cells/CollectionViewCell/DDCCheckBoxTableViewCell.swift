//
//  DDCCheckBoxTableViewCell.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/5.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCCheckBoxTableViewCell: UICollectionViewCell {
    var buttons: [DDCCheckBoxWithImageView] = Array()
    var buttonCount: Int {
        get {
            return 0
        }
        set {
            if buttonCount > 0 {
                self.updateButtons()
                self.setupViewConstraints()
            }
        }
    }
    
    lazy var titleLabel: UILabel = {
        let _titleLabel : UILabel = UILabel()
        _titleLabel.font = UIFont.systemFont(ofSize: 12.0)
        _titleLabel.textAlignment = .left
        _titleLabel.numberOfLines = 0
        _titleLabel.textColor = UIColor.black
        return _titleLabel
    }()
    
    lazy var anchorPoint: UIImageView = {
        let _anchorPoint : UIImageView = UIImageView()
        _anchorPoint.backgroundColor = DDCColor.mainColor.orange
        _anchorPoint.layer.cornerRadius = 2.0
        return _anchorPoint
    }()
    
    lazy var subContentView: UIView = {
        let _subContentView : UIView = UIView()
        return _subContentView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.anchorPoint)
        self.contentView.addSubview(self.subContentView)
        self.clipsToBounds = true
        self.setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        let kHorizontalMargin: CGFloat = 15.0
        
        self.titleLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(kHorizontalMargin)
            make.right.equalTo(self.contentView).offset(-kHorizontalMargin)
            make.bottom.equalTo(self.subContentView.snp_bottomMargin).offset(-kHorizontalMargin / 2)
        })
        
        self.anchorPoint.snp.makeConstraints({ (make) in
            make.top.equalTo(self.titleLabel).offset(kHorizontalMargin / 3)
            make.left.equalTo(self.contentView).offset(kHorizontalMargin / 2)
            make.height.width.equalTo(4)
        })
        
        self.subContentView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.titleLabel.snp_bottomMargin).offset(kHorizontalMargin / 2)
            make.left.right.equalTo(self.titleLabel)
            make.height.equalTo(self.contentView)
        })
        
        let moduleHeight: Int = 25
        
        for idx in 0...(self.buttons.count - 1) {
            let topMargin: CGFloat = CGFloat(5 * idx + moduleHeight * idx)
            let button: DDCCheckBoxWithImageView = self.buttons[idx]
            button.snp.makeConstraints({ (make) in
                make.top.equalTo(topMargin);
                make.height.equalTo(moduleHeight)
                make.left.right.equalTo(self.titleLabel)
            })
        }
        
    }
    
    func updateButtons() {
        for idx in 0...(self.buttons.count - 1) {
            let button: DDCCheckBoxWithImageView = self.buttons[idx]
            button.removeFromSuperview()
        }
        self.buttons.removeAll()
        
        for _ in 0...(self.buttonCount - 1) {
            let button: DDCCheckBoxWithImageView = DDCCheckBoxWithImageView.init(frame: CGRect.zero)
            self.buttons.append(button)
        }
        
        for button in self.buttons {
            self.subContentView.addSubview(button)
        }
    }
}
