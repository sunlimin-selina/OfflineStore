//
//  DDCOrderingTableViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/22.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
typealias SelectedBlock = (String?)->Void

class DDCOrderingTableViewController: UIViewController {
    static let kFliterLeftMargin: CGFloat = 44.0

    var optionalArray: Array<Any>? = Array()
    var block: SelectedBlock?
    var rect: CGRect?

    lazy var collectionView: UICollectionView! = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 120, height: 45)
        let margin:CGFloat = DDCOrderingTableViewController.kFliterLeftMargin
        layout.sectionInset = UIEdgeInsets.init(top: 20, left: margin, bottom: 10, right: margin)
        layout.minimumLineSpacing = 20
        layout.headerReferenceSize = CGSize.init(width: screen.width, height: 40)
        layout.footerReferenceSize = CGSize.init(width: screen.width, height: 10)

        var _collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        _collectionView.showsHorizontalScrollIndicator = false
        _collectionView.register(DDCCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: DDCCollectionViewCell.self))
        _collectionView.register(DDCSectionHeaderFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DDCSectionHeaderFooterView.self))
        _collectionView.backgroundColor = UIColor.white
        _collectionView.delegate = self
        _collectionView.dataSource = self
        _collectionView.clipsToBounds = true
        _collectionView.layer.borderColor = DDCColor.complementaryColor.separatorColor.cgColor
        _collectionView.layer.borderWidth = 1.0
        _collectionView.contentInset = UIEdgeInsets.init(top: 20, left: 0, bottom: DDCAppConfig.kBarHeight, right: 0)
        return _collectionView
    }()
    
    lazy var bottomBar: DDCBottomBar = {
        let _bottomBar: DDCBottomBar = DDCBottomBar.init(frame: CGRect.init(x: 0.0, y: 0.0, width: screen.width, height: DDCAppConfig.kBarHeight))
        _bottomBar.addButton(button:DDCBarButton.init(title: "重置", style: .normal, handler: {
        }))
        _bottomBar.addButton(button:DDCBarButton.init(title: "确认", style: .forbidden, handler: {
        }))
        _bottomBar.layer.borderColor = UIColor.clear.cgColor
        return _bottomBar
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.bottomBar)
        self.setupViewConstraints()
    }
    
    init(array: Array<Any>?, rect: CGRect, block:@escaping SelectedBlock) {
        super.init(nibName: nil, bundle: nil)

        self.optionalArray = array
        self.block = block
        self.rect = rect

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViewConstraints() {
        let topMargin: CGFloat = (self.rect?.origin.y)! + (self.rect?.size.height)!
        let height: CGFloat = 394
        
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(topMargin)
            make.left.right.equalTo(self.view)
            make.height.equalTo(height)
        }
        
        self.bottomBar.snp.makeConstraints({ (make) in
            make.height.equalTo(DDCAppConfig.kBarHeight)
            make.left.right.equalTo(self.collectionView)
            make.bottom.equalTo(self.collectionView).offset(-1) //-1为了显示border
        })
        
    }
}

// MARK: PopoverDelegate
extension DDCOrderingTableViewController: UIPopoverPresentationControllerDelegate{
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        if let block = self.block {
            block(nil)
        }
    }
}

extension DDCOrderingTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return DDCContract.courseStatusArray.count
        }
        return self.optionalArray!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCCollectionViewCell.self), for: indexPath) as! DDCCollectionViewCell
        
        if indexPath.section == 0 {
            cell.titleLabel.text = (DDCContract.courseStatusArray[indexPath.item])
        } else {
            cell.titleLabel.text = (self.optionalArray![indexPath.item] as! String)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DDCSectionHeaderFooterView.self), for: indexPath) as! DDCSectionHeaderFooterView
        view.titleLabel.text = indexPath.section == 0 ? "订单类型" : "订单状态"
        view.titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        view.titleLabel.textColor = DDCColor.fontColor.black
        view.titleLabel.snp.updateConstraints { (make) in
            make.width.equalTo(screen.width - DDCOrderingTableViewController.kFliterLeftMargin * 2)
        }
        return view
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let block = self.block {
            block((self.optionalArray![indexPath.item] as! String))
        }
    }
}
