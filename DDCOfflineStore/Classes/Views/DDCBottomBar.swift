//
//  DDCBottomBar.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/9/30.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCBottomBar : UIView {
    
    private lazy var button : UIButton = {
        let button : UIButton = UIButton()
        button.setTitle("创建新合同", for: .normal)
        button.backgroundColor = UIColor.orange
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 15
        return button;
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(self.button)
        self.setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        
        self.button.snp.makeConstraints({ (make) in
            make.width.equalTo(200)
            make.height.equalTo(40)
            make.left.equalTo(self).offset(100)
            make.right.equalTo(self.snp_rightMargin).offset(-100)
            make.centerX.centerY.equalTo(self)
        })
        
    }
    
}
