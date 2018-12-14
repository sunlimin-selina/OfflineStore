//
//  DDCSectionHeaderFooterView.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/9.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCSectionHeaderFooterView: UICollectionReusableView {
    
    lazy var titleLabel: DDCContractLabel = {
        var _titleLabel = DDCContractLabel()
        return _titleLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(self.titleLabel)
        self.setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        self.titleLabel.snp.makeConstraints { (make) in
            make.width.equalTo(screen.width - DDCAppConfig.kLeftMargin * 2)
            make.centerX.top.bottom.equalTo(self)
        }
    }
    
    override func prepareForReuse() {
        self.titleLabel.text = ""
    }
}
