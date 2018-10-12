//
//  DDCContractListTableViewCell.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/9/30.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCContractListTableViewCell: UITableViewCell {
    
    private lazy var icon : UIImageView = {
        let icon : UIImageView = UIImageView.init(image: UIImage.init(named: "icon_contractdetails_shengxiaozhong"))
        icon.contentMode = .scaleAspectFill
        icon.clipsToBounds = true
        return icon
    }()
    
    private lazy var titleLabel : UILabel = {
        let titleLabel : UILabel = UILabel()
        titleLabel.text = "selina 15921519009"
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        return titleLabel
    }()
    
    private lazy var datetime : UILabel = {
        let datetime : UILabel = UILabel()
        datetime.text = "2018/08/30"
        datetime.textColor = UIColor.gray
        datetime.font = UIFont.systemFont(ofSize: 16)
        return datetime
    }()
    
    private lazy var subtitleLabel : UILabel = {
        let subtitleLabel : UILabel = UILabel()
        subtitleLabel.text = "生效中"
        subtitleLabel.font = UIFont.systemFont(ofSize: 18)
        return subtitleLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(self.icon)
        self.addSubview(self.titleLabel)
        self.addSubview(self.datetime)
        self.addSubview(self.subtitleLabel)

        self.setupViewConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        
        self.icon.snp.makeConstraints({ (make) in
            make.width.height.equalTo(40)
            make.centerY.equalTo(self)
            make.left.equalTo(30)
        })
        
        self.titleLabel.snp.makeConstraints({ (make) in
            make.width.equalTo(200)
            make.left.equalTo(self.icon.snp_rightMargin).offset(20)
            make.centerY.equalTo(self.icon).offset(-10)
        })
        
        self.datetime.snp.makeConstraints({ (make) in
            make.width.equalTo(200)
            make.left.equalTo(self.icon.snp_rightMargin).offset(20)
            make.centerY.equalTo(self.icon).offset(10)
        })
        
        self.subtitleLabel.snp.makeConstraints({ (make) in
            make.width.equalTo(100)
            make.right.equalTo(self.snp_rightMargin)
            make.centerY.equalTo(self)
        })
    }
}
