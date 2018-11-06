//
//  DDCContractDetailsCell.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/8.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCContractDetailsCell: UITableViewCell {
    
    public lazy var titleLabel : UILabel = {
        let titleLabel : UILabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .regular)
        titleLabel.textColor = DDCColor.fontColor.gray
        titleLabel.textAlignment = .right
        return titleLabel
    }()
    
    public lazy var subtitleLabel : UILabel = {
        let subtitleLabel : UILabel = UILabel()
        subtitleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .regular)
        subtitleLabel.textColor = DDCColor.fontColor.black
        return subtitleLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(self.titleLabel)
        self.addSubview(self.subtitleLabel)
        self.setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        self.titleLabel.snp.makeConstraints({ (make) in
            make.width.equalTo(100)
            make.left.equalTo(self.snp_leftMargin).offset(20)
            make.right.equalTo(self.subtitleLabel.snp_leftMargin).offset(-30)
            make.centerY.equalTo(self)
        })
        
        self.subtitleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.contentView).offset(164)
            make.centerY.right.equalTo(self)
        })
    }
}
