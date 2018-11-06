//
//  DDCCheckBoxTableViewCell.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/5.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCCheckBoxTableViewCell: UITableViewCell {
    var buttons: [DDCCheckBoxWithImageView] = Array()
    var buttonCount: Int {
        get {
            return 0
        }
        set {
            if newValue > 0 {
                self.updateButtons(count: newValue)
                self.setupViewConstraints()
            }
        }
    }

    public lazy var titleLabel: DDCContractLabel = {
        let titleLabel : DDCContractLabel = DDCContractLabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = DDCColor.fontColor.black
        return titleLabel
    }()
    
    lazy var subContentView: UIView = {
        let _subContentView : UIView = UIView()
        return _subContentView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.subContentView)
        self.clipsToBounds = true
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        let kHorizontalMargin: CGFloat = 140.0
        let kPadding: CGFloat = 20.0

        self.titleLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(kHorizontalMargin)
            make.right.equalTo(self.contentView).offset(-kHorizontalMargin)
            make.bottom.equalTo(self.subContentView.snp_bottomMargin).offset(-kHorizontalMargin / 2)
        })
        
        self.subContentView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.titleLabel.snp_bottomMargin).offset(kPadding / 2)
            make.left.right.equalTo(self.titleLabel)
            make.height.equalTo(self.contentView)
        })
        
        let moduleHeight: Int = 40
        
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
    
    func updateButtons(count: Int) {
        if self.buttons.count > 0 {
            for idx in 0...(self.buttons.count - 1) {
                let button: DDCCheckBoxWithImageView = self.buttons[idx]
                button.removeFromSuperview()
            }
            self.buttons.removeAll()
        }
        
        for _ in 0...(count - 1) {
            let button: DDCCheckBoxWithImageView = DDCCheckBoxWithImageView.init(frame: CGRect.zero)
            self.buttons.append(button)
        }
        
        for button in self.buttons {
            self.subContentView.addSubview(button)
        }
    }
}
