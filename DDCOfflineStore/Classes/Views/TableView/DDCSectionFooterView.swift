//
//  DDCSectionFooterView.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/12.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCSectionFooterView: UITableViewHeaderFooterView {
    public lazy var titleLabel : UILabel = {
        let titleLabel : UILabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        titleLabel.textColor = DDCColor.fontColor.gray
        return titleLabel
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.backgroundView = UIView(frame: self.bounds)
        self.backgroundView!.backgroundColor = UIColor.white
        self.addSubview(self.titleLabel)
        self.clipsToBounds = true
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
