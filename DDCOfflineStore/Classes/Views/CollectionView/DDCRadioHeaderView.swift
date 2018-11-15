//
//  DDCRadioHeaderView.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/14.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCRadioHeaderView: UICollectionReusableView {

    lazy var radioButton: DDCRadioWithImageView = {
        let _radioButton: DDCRadioWithImageView = DDCRadioWithImageView.init(frame: CGRect.zero, status: .image)
        _radioButton.status = .image
        return _radioButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.radioButton)
        self.setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        self.radioButton.snp.makeConstraints({ (make) in
            make.width.equalTo(screen.width - DDCAppConfig.kLeftMargin * 2)
            make.centerX.top.bottom.equalTo(self)
        })
        
    }
    

}
