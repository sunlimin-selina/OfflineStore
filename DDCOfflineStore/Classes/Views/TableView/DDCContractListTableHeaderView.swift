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
    
    private lazy var backgroundView : UIImageView = {
        let backgroundView : UIImageView = UIImageView.init(image: UIImage.init(named: "background"))
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.clipsToBounds = true
        return backgroundView
    }()
    
    lazy var portraitView : UIImageView = {
        let portraitView : UIImageView = UIImageView()
        portraitView.contentMode = .scaleAspectFill
        portraitView.clipsToBounds = true
        return portraitView
    }()
    
    lazy var userName : UILabel = {
        let userName : UILabel = UILabel()
        userName.textColor = UIColor.white
        userName.font = UIFont.boldSystemFont(ofSize: 18)
        return userName
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.backgroundView)
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
        
        self.portraitView.snp.makeConstraints({ (make) in
            make.width.height.equalTo(86)
            make.centerY.equalTo(self).offset(15.0)
            make.left.equalTo(50)
        })
        self.userName.snp.makeConstraints({ (make) in
            make.width.equalTo(100)
            make.left.equalTo(self.portraitView.snp_rightMargin).offset(30.0)
            make.centerY.equalTo(self.portraitView)
        })
    }
}
