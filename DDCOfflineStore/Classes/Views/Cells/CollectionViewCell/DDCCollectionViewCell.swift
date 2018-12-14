//
//  DDCCollectionViewCell.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/12/14.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCCollectionViewCell: UICollectionViewCell {
    
    public lazy var titleLabel: UILabel = {
        let titleLabel: UILabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .regular)
        titleLabel.textColor = DDCColor.fontColor.gray
        titleLabel.textAlignment = .center

        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.layer.cornerRadius = 20.0
        self.contentView.backgroundColor = DDCColor.complementaryColor.backgroundColor
        self.contentView.addSubview(self.titleLabel)
        self.setupViewConstraints()
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        self.titleLabel.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.contentView)
        })

    }
}
