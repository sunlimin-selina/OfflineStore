//
//  DDCCheckBoxTableViewCellControl.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/5.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import UIKit

class DDCCheckBoxTableViewCellControl: NSObject {
    static let kTag: Int = 100
    static let kCTag: Int = 200

    var selectedItems: Array<Any> = Array()
    var selectedIndexes: Array<Any> = Array()
    var cell: DDCCheckBoxTableViewCell?
    
    var hasImage: Bool?
    
//    let contractTypes: [DDCCheckBoxModel] = [DDCCheckBoxModel.init(id: nil, title: "体验课订单"),DDCCheckBoxModel.init(id: nil, title: "普通合同"),DDCCheckBoxModel.init(id: nil, title: "团体合同")]
    
    class func cellHeight() -> CGFloat {
        return 360
    }
    
    init(cell: DDCCheckBoxTableViewCell) {
        super.init()
        self.cell = cell
    }
    
//    func setData(data: [DDCStoreModel], cell: DDCCheckBoxTableViewCell, indexPath: IndexPath) {
//        guard data.count > 0 else { //  || data is [DDCStoreModel]
//            return
//        }
//        if indexPath.row == 0 {
//            cell.titleLabel.configure(title: "当前所在门店", isRequired: true)
//            cell.buttonCount = data.count
//
//            if (data.count > 0) {
//                for index in 0...(cell.buttons.count - 1) {
//                    let view: DDCRadioWithImageView = cell.buttons[index]
//                    view.button.isEnabled = true
//                    view.button.setTitle(data[index].title, for: .normal)
//                    view.button.addTarget(self, action: Selector(("buttonClicked:")), for: .touchUpInside)
//                    view.button.tag = index + DDCCheckBoxTableViewCellControl.kTag
//                    view.button.isSelected = false
//                }
//            }
//        } else {
//            cell.titleLabel.configure(title: "合同类型", isRequired: true)
//            cell.buttonCount = self.contractTypes.count
//
//            if (self.contractTypes.count > 0) {
//                for index in 0...(cell.buttons.count - 1) {
//                    let view: DDCRadioWithImageView = cell.buttons[index]
//                    view.button.isEnabled = true
//                    view.button.setTitle(self.contractTypes[index].title, for: .normal)
//                    view.button.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
//                    view.button.tag = index + DDCCheckBoxTableViewCellControl.kCTag
//                    view.button.isSelected = false
//                }
//            }
//        }
//    
//        return 
//    }
    
    @objc func buttonClicked(sender: UIButton) {
        // 不让用户取消已选中的选项
        // 取消已选中的选项
        for subView in self.cell!.buttons {
            subView.button.isSelected = false
            self.selectedIndexes.removeAll()
            self.selectedItems.removeAll()
        }
        
        sender.isSelected = !sender.isSelected
//        CampaignItemModel *item = self.subjectData.items[button.tag - kTag];
//
//        if (button.selected) {
//            if (![self.selectedItems containsObject:item]) {
//                [self.selectedItems addObject:item];
//                [self.selectedIndexes addObject:@(button.tag - kTag)];
//                item.selectCount = [NSString stringWithFormat:@"%ld", item.selectCount.integerValue+1];
//            }
//        } else {
//            if ([self.selectedItems containsObject:item]) {
//                [self.selectedItems removeObject:item];
//                [self.selectedIndexes removeObject:@(button.tag - kTag)];
//                item.selectCount = [NSString stringWithFormat:@"%ld", item.selectCount.integerValue-1];
//            }
//        }
    }
    
    
}
