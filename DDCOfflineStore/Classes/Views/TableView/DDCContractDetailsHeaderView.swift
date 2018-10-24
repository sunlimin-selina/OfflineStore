//
//  DDCContractDetailsHeaderView.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/24.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCContractDetailsHeaderView: UITableViewHeaderFooterView {
    var status: DDCContractStatus? {
        didSet{
            switch status {
            case .effective?:
                self.imageView.image = UIImage.init(named: "icon_contractdetails_shengxiaozhong")
            case .ineffective?:
                self.imageView.image = UIImage.init(named: "icon_contractdetails_weishengxiao")
            case .inComplete?:
                self.imageView.image = UIImage.init(named: "icon_contractdetails_weiwancheng")
            case .used?:
                self.imageView.image = UIImage.init(named: "icon_contractdetails_yixiaohe")
            case .completed?:
                self.imageView.image = UIImage.init(named: "icon_contractdetails_yijieshu")
            case .revoked?:
                do {
                    self.imageView.image = UIImage.init(named: "icon_contractdetails_yijiechu")
                    self.titleLabel.textColor = DDCColor.fontColor.gray
                }
            default:
                break
            }
        }
    }
    
    lazy var imageView: UIImageView = {
        var _imageView = UIImageView.init()
        _imageView.layer.masksToBounds = true
        _imageView.layer.cornerRadius = 2.0
        _imageView.contentMode = .scaleAspectFill
        return _imageView
    }()
    
    lazy var titleLabel: UILabel = {
        var _titleLabel = UILabel()
        _titleLabel.textAlignment = .center
        _titleLabel.textColor = DDCColor.fontColor.black
        _titleLabel.numberOfLines = 1
        _titleLabel.font = UIFont.systemFont(ofSize: 18.0)
        _titleLabel.text = "课程合同书"
        return _titleLabel
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.backgroundView = UIView(frame: self.bounds)
        self.backgroundView!.backgroundColor = UIColor.white
        
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.titleLabel)
        self.setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        self.imageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(35.0)
            make.centerX.equalTo(self.contentView)
            make.width.height.equalTo(50.0)
        }
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.imageView.snp_bottomMargin).offset(15.0)
            make.centerX.equalTo(self.contentView)
        }
    }
}
