//
//  DDCPaymentQRCodeImageCollectionViewCell.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/16.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCPaymentQRCodeImageCollectionViewCell: UICollectionViewCell {
    static let kTextFieldViewHeight: CGFloat = 50.0
    
    public lazy var priceLabel: DDCContractLabel = {
        let _priceLabel: DDCContractLabel = DDCContractLabel()
        _priceLabel.textColor = UIColor.black
//        _priceLabel.font = UIFont.init(name: "AshbyBlack", size: 40.0)
        return _priceLabel
    }()
    
    public lazy var qrCodeImageView: UIImageView = {
        let _qrCodeImageView: UIImageView = UIImageView()
        _qrCodeImageView.contentMode = .scaleAspectFit
        _qrCodeImageView.clipsToBounds = true
        return _qrCodeImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.priceLabel)
        self.contentView.addSubview(self.qrCodeImageView)
        self.setupViewConstraints()
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        
        let kQRCodeImageDiameter: CGFloat = 258.0
        let kQRCodeToTitle: CGFloat = 30.0

        self.qrCodeImageView.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(self.contentView).offset(102.0)
            make.width.height.equalTo(kQRCodeImageDiameter)
        })
        
        self.priceLabel.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(self.qrCodeImageView.snp_bottomMargin).offset(kQRCodeToTitle)
            make.height.equalTo(40.0)
        })
        
    }
    
    func configureCell(QRCodeURLString: String, price: String) {
        self.loadQRCodeImage(url: QRCodeURLString)
        let attributeString: NSMutableAttributedString = NSMutableAttributedString.init(string: "¥ \(price)")
        attributeString.addAttributes([NSAttributedString.Key.font: UIFont.init(name: "AshbyBlack", size: 40.0)!], range: NSMakeRange(0, attributeString.length))
        attributeString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .medium)], range: NSMakeRange(0, 1))

        self.priceLabel.attributedText = attributeString
    }
    
    override func prepareForReuse() {
        self.qrCodeImageView.image = nil
        self.priceLabel.attributedText = nil
    }
    
    func loadQRCodeImage(url: String) {
        var width: CGFloat = self.qrCodeImageView.bounds.size.width

        if (width == 0) {
            self.qrCodeImageView.setNeedsLayout()
            self.qrCodeImageView.layoutIfNeeded()
            width = self.qrCodeImageView.bounds.size.width
        } 
        self.qrCodeImageView.image = DDCQRCodeGenerateManager.setupQRCodeImage(url, image: nil)
    }
    
}
