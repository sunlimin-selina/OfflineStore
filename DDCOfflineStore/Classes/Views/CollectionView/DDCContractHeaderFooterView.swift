//
//  DDCContractHeaderFooterView.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/12.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCContractHeaderFooterView: UICollectionReusableView {
    public lazy var titleLabel : UILabel = {
        let titleLabel : UILabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        titleLabel.textColor = DDCColor.fontColor.gray
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.titleLabel)
        self.setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        self.titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self).offset(DDCAppConfig.kLeftMargin)
            make.width.bottom.equalTo(self)
            make.height.equalTo(20.0)
        })
    }
}
