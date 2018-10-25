//
//  DDCContractListTableViewCell.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/9/30.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCStatusViewModel: NSObject {
    var color : UIColor?
    var title : String?
    var imageName : String?

    init(color: UIColor, title: String, imageName: String) {
        self.color = color
        self.title = title
        self.imageName = imageName
    }

}

class DDCContractListTableViewCell: UITableViewCell {
    
    private lazy var icon : UIImageView = {
        let icon : UIImageView = UIImageView.init(image: UIImage.init(named: "icon_contractdetails_shengxiaozhong"))
        icon.contentMode = .scaleAspectFill
        icon.clipsToBounds = true
        return icon
    }()
    
    private lazy var titleLabel : UILabel = {
        let titleLabel : UILabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = DDCColor.fontColor.black
        return titleLabel
    }()
    
    private lazy var datetime : UILabel = {
        let datetime : UILabel = UILabel()
        datetime.textColor = DDCColor.fontColor.gray
        datetime.font = UIFont.systemFont(ofSize: 12)
        return datetime
    }()
    
    private lazy var subtitleLabel : UILabel = {
        let subtitleLabel : UILabel = UILabel()
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        return subtitleLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(self.icon)
        self.addSubview(self.titleLabel)
        self.addSubview(self.datetime)
        self.addSubview(self.subtitleLabel)

        self.setupViewConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        let kLeftMargin: CGFloat = 20.0
        let kLabelWidth: CGFloat = 400.0
        let kCenterOffset: CGFloat = 12.0

        self.icon.snp.makeConstraints({ (make) in
            make.width.height.equalTo(40)
            make.centerY.equalTo(self)
            make.left.equalTo(kLeftMargin)
        })
        
        self.titleLabel.snp.makeConstraints({ (make) in
            make.width.equalTo(kLabelWidth)
            make.left.equalTo(self.icon.snp_rightMargin).offset(kLeftMargin)
            make.centerY.equalTo(self.icon).offset(-kCenterOffset)
        })
        
        self.datetime.snp.makeConstraints({ (make) in
            make.width.equalTo(kLabelWidth)
            make.left.equalTo(self.icon.snp_rightMargin).offset(kLeftMargin)
            make.centerY.equalTo(self.icon).offset(kCenterOffset)
        })
        
        self.subtitleLabel.snp.makeConstraints({ (make) in
            make.width.equalTo(50)
            make.right.equalTo(self.snp_rightMargin)
            make.centerY.equalTo(self)
        })
    }
    
    func configureCell(model : DDCContractDetailsModel) {
        let title = "\(model.user!.nickName ?? "") \(model.user!.userName ?? "")"
        self.titleLabel.text = title
        self.datetime.text = model.info!.createDateString
        
        let status : DDCStatusViewModel = DDCContract.statusPairings[(model.showStatus?.rawValue)!]!
        self.subtitleLabel.text = status.title
        self.subtitleLabel.textColor = status.color
        self.icon.image = UIImage.init(named: status.imageName!)
    }
    
}
