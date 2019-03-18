//
//  DDCRadioHeaderView.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/14.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCRadioHeaderView: UICollectionReusableView {
    enum DDCRadioHeaderViewType {
        case normal
        case title // 带标题
    }
    
    var type: DDCRadioHeaderViewType {
        get {
            return .normal
        }
        set {
            switch newValue {
            case .title:
                self.titleLabel.isHidden = false
                self.radioButton.status = .normal
                self.updateViewConstraints()
            case .normal:
                self.titleLabel.isHidden = true
                self.radioButton.status = .normal
                self.updateViewConstraints()
            }
        }
    }
    
    
    public lazy var titleLabel: DDCContractLabel = {
        let _titleLabel: DDCContractLabel = DDCContractLabel()
        _titleLabel.isHidden = true
        return _titleLabel
    }()

    lazy var radioButton: DDCRadioWithImageView = {
        let _radioButton: DDCRadioWithImageView = DDCRadioWithImageView.init(frame: CGRect.zero, status: .image)
        _radioButton.status = .image
        _radioButton.isUserInteractionEnabled = true
        return _radioButton
    }()
    
    public lazy var subtitleLabel: UILabel = {
        let _subtitleLabel: UILabel = UILabel()
        _subtitleLabel.textColor = DDCColor.mainColor.red
        _subtitleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .light)
        return _subtitleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.titleLabel)
        self.addSubview(self.radioButton)
        self.addSubview(self.subtitleLabel)
        self.setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {

        self.radioButton.snp.makeConstraints({ (make) in
            make.width.equalTo(screen.width - DDCAppConfig.kLeftMargin * 2)
            make.centerX.top.bottom.equalTo(self)
        })
        
        self.subtitleLabel.snp.makeConstraints { (make) in
            make.width.height.centerY.equalTo(self.radioButton)
            make.left.equalTo(self.radioButton).offset(280)
        }
    }
    
    func updateViewConstraints() {
        
        if self.titleLabel.isHidden {
            self.radioButton.snp.remakeConstraints({ (make) in
                make.width.equalTo(self.titleLabel)
                make.top.bottom.equalTo(self)
                make.left.equalTo(self).offset(DDCAppConfig.kLeftMargin)
            })
        } else {
            self.titleLabel.snp.makeConstraints { (make) in
                make.width.equalTo(screen.width - DDCAppConfig.kLeftMargin * 2)
                make.centerX.top.equalTo(self)
                make.height.equalTo(40)
            }
            
            self.radioButton.snp.remakeConstraints({ (make) in
                make.width.left.equalTo(self.titleLabel)
                make.centerX.bottom.equalTo(self)
                make.top.equalTo(self.titleLabel.snp_bottomMargin).offset(20)
            })
        }
       
    }
    
    override func prepareForReuse() {
        self.subtitleLabel.text = ""
    }

}
