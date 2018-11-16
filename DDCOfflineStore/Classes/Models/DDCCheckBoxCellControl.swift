//
//  DDCCheckBoxTableViewCellControl.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/5.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import UIKit

class DDCCheckBoxCellControl: NSObject {
    static let kCTag: Int = 200

    var selectedItems: NSMutableArray = NSMutableArray()
    var selectedIndexes: NSMutableArray = NSMutableArray()
    var cell: DDCCheckBoxCollectionViewCell?
    var model: DDCCourseModel?
    
    var hasImage: Bool?
    
    func cellHeight() -> CGFloat {
        if self.model != nil {
            return CGFloat((self.model!.isSelected ? (self.model!.attributes?.count)! + 1: 1 ) * 42)
        }
        return 42
    }
    
    override init() {
        super.init()
    }
    
    init(cell: DDCCheckBoxCollectionViewCell) {
        super.init()
        self.cell = cell
    }
    
    func configureCell(model: DDCCourseModel, indexPath: IndexPath) {
        self.model = model
        
        if let _attributes = model.attributes,
            (_attributes.count > 0 && model.isSelected) {
            self.cell!.buttonCount = _attributes.count
            for index in 0...(self.cell!.buttons.count - 1) {
                let view: DDCCheckBox = self.cell!.buttons[index]
                view.button.isEnabled = true
                view.button.tag = index + DDCCheckBoxCellControl.kCTag
                let subtitle:String = _attributes[index].attributeValue!
                view.button.setTitle(subtitle, for: .normal)
                view.button.isSelected = _attributes[index].isSelected
                view.textField.isHidden = !view.button.isSelected
                view.textField.textField.delegate = self
                view.setHandler { (sender) in
                    self.buttonClicked(sender: sender)
                }
                view.updateLayoutConstraints(width: DDCString.width(string: subtitle, font: UIFont.systemFont(ofSize: 20.0), height: 40.0) + 45)
            }
        }
        self.cell!.checkBox.button.setTitle(model.categoryName, for: .normal)
        self.cell!.checkBox.button.isSelected = model.isSelected
        self.cell!.subContentView.isHidden = !model.isSelected
    }
    
    func buttonClicked(sender: DDCCheckBox) {
        sender.button.isSelected = !sender.button.isSelected
        sender.textField.isHidden = !sender.button.isSelected
        if (self.model?.attributes?.count)! <= 0 {
            return
        }
        let item: DDCCourseAttributeModel = (self.model?.attributes![sender.button.tag - DDCCheckBoxCellControl.kCTag])!
        item.isSelected = sender.button.isSelected

        if (sender.isSelected) {
            if self.selectedItems.contains(item) {
                self.selectedItems.add(item)
            }
        } else {
            if self.selectedItems.contains(item) {
                self.selectedItems.remove(item)
            }
        }
    }
    
}

extension DDCCheckBoxCellControl: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //限制字符长度
        let existedLength: Int = (textField.text?.count)!
        let selectedLength: Int = range.length
        let replaceLength: Int = string.count
        let totalLength: Int = existedLength - selectedLength + replaceLength
        
        if (totalLength > 3) {//字符数量不超过3
            return false
        }
        
        return true
    }
}
