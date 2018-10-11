//
//  DDCBottomBar.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/9/30.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCBottomBar : UIView {
    
    var handler = {}
    
    private lazy var button : UIButton = {
        let button : UIButton = UIButton()
        button.setTitle("创建新合同", for: .normal)
        button.backgroundColor = UIColor.init(hex: "#FF5D31")
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    init(frame: CGRect, handler : @escaping ()->Void) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.isUserInteractionEnabled = true
        self.handler = handler
        self.addSubview(self.button)
        self.setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        self.button.snp.makeConstraints({ (make) in
            make.width.equalTo(400)
            make.height.equalTo(40)
            make.centerX.centerY.equalTo(self)
        })
    }
    
    @objc func clickAction() {
        self.handler()
    }
    
}
