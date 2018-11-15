//
//  DDCContractListTableHeaderView.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/9/30.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCContractListTableHeaderView: UIView {
    static let kImgBorderWidth: CGFloat = 15
    static let kImgDiameter: CGFloat = 80
    
    private lazy var backgroundView: UIImageView = {
        let _backgroundView: UIImageView = UIImageView.init()
        _backgroundView.backgroundColor = DDCColor.colorWithHex(RGB: 0x202932)
        _backgroundView.contentMode = .scaleAspectFill
        _backgroundView.clipsToBounds = true
        return _backgroundView
    }()
    
    lazy var portraitView: UIImageView = {
        let _portraitView: UIImageView = UIImageView()
        _portraitView.contentMode = .scaleAspectFill
        _portraitView.clipsToBounds = true
        _portraitView.layer.masksToBounds = true
        return _portraitView
    }()
    
    lazy var portraitViewHolder: UIView = {
        let _portraitViewHolder: UIView = UIView()
        _portraitViewHolder.layer.cornerRadius = (DDCContractListTableHeaderView.kImgDiameter + DDCContractListTableHeaderView.kImgBorderWidth) / 2
        _portraitViewHolder.layer.masksToBounds = true
        _portraitViewHolder.layer.borderColor = UIColor.init(white: 1, alpha: 0.05).cgColor
        _portraitViewHolder.layer.borderWidth = DDCContractListTableHeaderView.kImgBorderWidth
        return _portraitViewHolder
    }()
    
    lazy var userName: UILabel = {
        let _userName: UILabel = UILabel()
        _userName.textColor = UIColor.white
        _userName.font = UIFont.systemFont(ofSize: 22.0, weight: .medium)
        return _userName
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.backgroundView)
        self.addSubview(self.portraitViewHolder)
        self.addSubview(self.portraitView)
        self.addSubview(self.userName)
        self.setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        
        self.backgroundView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        self.portraitViewHolder.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self).offset(15.0)
            make.left.equalTo(50)
            make.width.height.equalTo(DDCContractListTableHeaderView.kImgBorderWidth + DDCContractListTableHeaderView.kImgDiameter)
        })
        
        self.portraitView.snp.makeConstraints({ (make) in
            make.width.height.equalTo(DDCContractListTableHeaderView.kImgDiameter)
            make.center.equalTo(self.portraitViewHolder)
        })
        
        self.userName.snp.makeConstraints({ (make) in
            make.width.equalTo(100)
            make.left.equalTo(self.portraitView.snp_rightMargin).offset(30.0)
            make.centerY.equalTo(self.portraitView)
        })
    }
}
