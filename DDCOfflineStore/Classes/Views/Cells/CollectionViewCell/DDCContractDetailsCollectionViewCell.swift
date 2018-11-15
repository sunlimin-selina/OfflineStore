//
//  DDCContractDetailsCollectionViewCell.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/12.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCContractDetailsCollectionViewCell: UICollectionViewCell {
    
    public lazy var titleLabel: UILabel = {
        let titleLabel: UILabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .regular)
        titleLabel.textColor = DDCColor.fontColor.gray
        titleLabel.textAlignment = .right
        return titleLabel
    }()
    
    public lazy var subtitleLabel: UILabel = {
        let subtitleLabel: UILabel = UILabel()
        subtitleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .regular)
        subtitleLabel.textColor = DDCColor.fontColor.black
        return subtitleLabel
    }()
    
    public var labelView: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.labelView)
        self.labelView.addSubview(self.titleLabel)
        self.labelView.addSubview(self.subtitleLabel)
        self.setupViewConstraints()
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        self.labelView.snp.makeConstraints({ (make) in
            make.width.equalTo(screen.width - DDCAppConfig.kLeftMargin * 2)
            make.centerX.centerY.height.equalTo(self.contentView)
        })
        
        self.titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.labelView)
            make.width.equalTo(120.0)
            make.centerY.equalTo(self.labelView)
        })
        
        self.subtitleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.titleLabel.snp_rightMargin).offset(30)
            make.centerY.right.equalTo(self.labelView)
        })
    }
}
