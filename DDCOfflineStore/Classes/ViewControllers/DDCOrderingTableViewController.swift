//
//  DDCOrderingTableViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/22.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
typealias SelectedBlock = (String?)->Void

class DDCOrderingTableViewController: UITableViewController {
    var optionalArray: Array<Any>? = Array()
    var block: SelectedBlock?
    
    init(style: UITableView.Style, array: Array<Any>?, block:@escaping SelectedBlock) {
        super.init(style: style)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        self.tableView.separatorColor = DDCColor.colorWithHex(RGB: 0xEEEEEE)
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.rowHeight = 50.0
//        self.popoverPresentationController?.delegate = self
        
        if let popover = self.popoverPresentationController {
            popover.delegate = self
        }
        self.optionalArray = array
        self.block = block
        self.preferredContentSize = CGSize.init(width: 100, height: 50 * (self.optionalArray?.count)!)
        self.modalPresentationStyle = .popover
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

// MARK: UITableViewDelegate
extension DDCOrderingTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.optionalArray!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        cell.textLabel!.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        cell.textLabel!.textColor = DDCColor.fontColor.black
        cell.textLabel!.text = (self.optionalArray![indexPath.row] as! String)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let block = self.block {
            block((self.optionalArray![indexPath.row] as! String))
        }
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
