//
//  DDCCheckBoxCollectionViewCell.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/13.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCCheckBoxCollectionViewCell: UICollectionViewCell {
    
    public lazy var checkBox: DDCCheckBox = {
        let _checkBox: DDCCheckBox = DDCCheckBox.init(frame: CGRect.zero)
        _checkBox.isUserInteractionEnabled = false
        return _checkBox
    }()

    var buttons: [DDCCheckBox] = Array()
    var buttonCount: Int {
        get {
            return 0
        }
        set {
            if newValue > 0 {
                self.updateButtons(count: newValue)
                self.updateViewConstraints()
            }
        }
    }
    
    lazy var subContentView: UIView = {
        let _subContentView: UIView = UIView()
        _subContentView.isUserInteractionEnabled = true
        return _subContentView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        let kPadding: CGFloat = 5.0
        self.contentView.addSubview(self.checkBox)
//        self.contentView.addSubview(self.textField)
        self.contentView.addSubview(self.subContentView)
        self.clipsToBounds = true
        self.checkBox.snp.makeConstraints({ (make) in
            make.width.equalTo(screen.width - DDCAppConfig.kLeftMargin * 2)
            make.centerX.top.equalTo(self.contentView).offset(kPadding)
            make.height.equalTo(30.0)
        })
    }
    
    func updateViewConstraints() {
        if self.buttons.count <= 0 {
            return
        }
        
        let kMargin: CGFloat = 35.0
        
        self.subContentView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.contentView).offset(kMargin)
            make.left.right.bottom.equalTo(self.contentView)
        })
        
        let moduleHeight: Int = 40

        for idx in 0...(self.buttons.count - 1) {
            let topMargin: CGFloat = CGFloat(5 * idx + moduleHeight * idx)
            let button: DDCCheckBox = self.buttons[idx]
            button.snp.makeConstraints({ (make) in
                make.top.equalTo(topMargin);
                make.height.equalTo(moduleHeight)
                make.right.equalTo(self.contentView)
                make.left.equalTo(self.contentView).offset(kMargin)
            })
        }
    }
    
    func updateButtons(count: Int) {
        if self.buttons.count > 0 {
            for idx in 0...(self.buttons.count - 1) {
                let button: DDCCheckBox = self.buttons[idx]
                button.removeFromSuperview()
            }
            self.buttons.removeAll()
        }
        
        for _ in 0...(count - 1) {
            let button: DDCCheckBox = DDCCheckBox.init(frame: CGRect.zero)
            button.isUserInteractionEnabled = true
            self.buttons.append(button)
        }
        
        for button in self.buttons {
            self.subContentView.addSubview(button)
        }
    }
    
//    override func prepareForReuse() {
//        self.contentView.subviews.last?.removeFromSuperview()
//        self.setupViewConstraints()
//    }
    

    
}

