//
//  DDCOrderingTableViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/22.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCOrderingTableViewController: UIViewController {
    static let kFliterLeftMargin: CGFloat = 44.0

    var block: OrderingUpdateCallback?
    var rect: CGRect?

    var courseTypeModels: [DDCCheckBoxModel] = {
        var models: [DDCCheckBoxModel] = Array()
        for item in DDCContract.courseStatusArray {
            let model: DDCCheckBoxModel = DDCCheckBoxModel.init(id: nil, title: item, isSelected: false)
            models.append(model)
        }
        return models
    }()
    
    lazy var courseStatusModels: [DDCCheckBoxModel] = {
        var _optionalArray: [DDCCheckBoxModel] = Array()
        for item in DDCContract.backendStatusArray {
            let model: DDCCheckBoxModel = DDCCheckBoxModel.init(id: nil, title: item, isSelected: false)
            _optionalArray.append(model)
        }
        return _optionalArray
    }()
    
    lazy var backgroundView: UIView = {
        let _view: UIView = UIView()
        return _view
    }()
    
    lazy var collectionView: UICollectionView! = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 120, height: 45)
        let margin:CGFloat = DDCOrderingTableViewController.kFliterLeftMargin
        layout.sectionInset = UIEdgeInsets.init(top: 20, left: margin, bottom: 10, right: margin)
        layout.minimumLineSpacing = 20
        layout.headerReferenceSize = CGSize.init(width: screen.width, height: 40)
        layout.footerReferenceSize = CGSize.init(width: screen.width, height: 0.01)

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
            self.resetModel(model: self.courseTypeModels)
            self.resetModel(model: self.courseStatusModels)
            self.collectionView.reloadSections([0,1])
        }))
        _bottomBar.addButton(button:DDCBarButton.init(title: "确认", style: .highlighted, handler: {
            if let block = self.block {
                let status: DDCContractStatus = DDCContractStatus(rawValue: self.getSelectedIndex(model: self.courseStatusModels))!
                let type: DDCContractType = DDCContractType(rawValue: self.getSelectedIndex(model: self.courseTypeModels))!
                block(status, type)
            }
        }))
        _bottomBar.layer.borderColor = UIColor.clear.cgColor
        return _bottomBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.backgroundView)
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.bottomBar)
        self.setupViewConstraints()
        self.addGesture()
    }
    
    init(rect: CGRect, block:@escaping OrderingUpdateCallback) {
        super.init(nibName: nil, bundle: nil)
        self.block = block
        self.rect = rect
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBackground))
        self.backgroundView.addGestureRecognizer(tapGesture)
    }
    
    private func setupViewConstraints() {
        let topMargin: CGFloat = (self.rect?.origin.y)! + (self.rect?.size.height)!
        let height: CGFloat = 394
        
        self.backgroundView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
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
    
    func resetModel(model: [DDCCheckBoxModel]) {
        for item in model {
            item.isSelected = false
        }
    }
    
    func getSelectedIndex(model: [DDCCheckBoxModel]) -> Int {
        for idx in 0..<model.count {
            let item = model[idx]
            if item.isSelected {
                return idx
            }
        }
        return 0
    }
}


// MARK: Action
extension DDCOrderingTableViewController {
    @objc func tapBackground() {
        if let block = self.block {
            block(nil, nil)
        }
    }
}

// MARK: UICollectionViewDelegate
extension DDCOrderingTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.courseTypeModels.count
        }
        return self.courseStatusModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DDCCollectionViewCell.self), for: indexPath) as! DDCCollectionViewCell
        let model: DDCCheckBoxModel?
        if indexPath.section == 0 {
            model = self.courseTypeModels[indexPath.item]
        } else {
            model = self.courseStatusModels[indexPath.item]
        }
        cell.labelButton.setTitle(model!.title, for: .normal)
        cell.labelButton.isSelected = model!.isSelected
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DDCSectionHeaderFooterView.self), for: indexPath) as! DDCSectionHeaderFooterView
        
        if kind == UICollectionView.elementKindSectionHeader {
            view.titleLabel.text = indexPath.section == 0 ? "订单类型" : "订单状态"
            view.titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
            view.titleLabel.textColor = DDCColor.fontColor.black
            view.titleLabel.snp.updateConstraints { (make) in
                make.width.equalTo(screen.width - DDCOrderingTableViewController.kFliterLeftMargin * 2)
            }
        }
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var item: DDCCheckBoxModel?

        if indexPath.section == 0 {
            for idx in 0..<self.courseTypeModels.count {
                item = self.courseTypeModels[idx]
                if indexPath.item == idx {
                    item!.isSelected = true
                } else {
                    item!.isSelected = false
                }
            }
        } else {
            for idx in 0..<self.courseStatusModels.count {
                item = self.courseStatusModels[idx]
                if indexPath.item == idx {
                    item!.isSelected = true
                } else {
                    item!.isSelected = false
                }
            }
        }
        self.collectionView.reloadSections([indexPath.section])
    }
}
