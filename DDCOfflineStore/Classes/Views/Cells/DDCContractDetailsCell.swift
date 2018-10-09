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
        titleLabel.text = "合同状态"
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.gray
        return titleLabel;
    }()
    
    private lazy var subtitleLabel : UILabel = {
        let subtitleLabel : UILabel = UILabel()
        subtitleLabel.text = "已解除"
        subtitleLabel.font = UIFont.systemFont(ofSize: 18)
        subtitleLabel.textColor = UIColor.gray
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
            make.width.equalTo(100)
            make.left.equalTo(self.snp_leftMargin).offset(20)
            make.right.equalTo(self.subtitleLabel.snp_leftMargin).offset(-20)
            make.centerY.equalTo(self)
        })
        
        self.subtitleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.titleLabel.snp_rightMargin).offset(20)
            make.centerY.right.equalTo(self)
        })
    }
}
