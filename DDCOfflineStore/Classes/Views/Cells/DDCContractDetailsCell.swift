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
    
    private lazy var titleLabel : UILabel = {
        let titleLabel : UILabel = UILabel()
        titleLabel.text = "selina"
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        return titleLabel;
    }()
    
    private lazy var subtitleLabel : UILabel = {
        let subtitleLabel : UILabel = UILabel()
        subtitleLabel.text = "生效中"
        subtitleLabel.font = UIFont.systemFont(ofSize: 18)
        return subtitleLabel;
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
            make.width.equalTo(50)
            make.left.equalTo(self.snp_leftMargin).offset(20)
            make.centerY.equalTo(self)
        })
        
        self.subtitleLabel.snp.makeConstraints({ (make) in
            make.width.equalTo(100)
            make.left.equalTo(self.titleLabel.snp_rightMargin).offset(20)
            make.right.equalTo(self.snp_rightMargin)
            make.centerY.equalTo(self)
        })
    }
}
