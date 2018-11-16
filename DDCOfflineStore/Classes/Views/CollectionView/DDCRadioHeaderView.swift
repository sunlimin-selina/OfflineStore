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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.titleLabel)
        self.addSubview(self.radioButton)
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
        
    }
    
    func updateViewConstraints() {
        
        if self.titleLabel.isHidden {
            self.radioButton.snp.remakeConstraints({ (make) in
                make.width.equalTo(self.titleLabel)
                make.centerX.top.bottom.equalTo(self)
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

}
