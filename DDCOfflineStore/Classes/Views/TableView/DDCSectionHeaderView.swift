//
//  DDCSectionHeaderView.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/9.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCSectionHeaderView: UITableViewHeaderFooterView {
    
    lazy var titleLabel: DDCContractLabel = {
        var _titleLabel = DDCContractLabel()
        return _titleLabel
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.backgroundView = UIView(frame: self.bounds)
        self.backgroundView!.backgroundColor = UIColor.white
        
        self.contentView.addSubview(self.titleLabel)
        self.setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        self.titleLabel.snp.makeConstraints { (make) in
            make.width.equalTo(screen.width - DDCAppConfig.kLeftMargin * 2)
            make.centerX.top.bottom.equalTo(self.contentView)
        }
    }
}
