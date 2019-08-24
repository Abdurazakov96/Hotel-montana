//
//  SelectedTableViewController.swift
//  Hotel montana
//
//  Created by Магомед Абдуразаков on 24/08/2019.
//  Copyright © 2019 Магомед Абдуразаков. All rights reserved.
//

import UIKit

class SelectedTableViewController: UITableViewController {

    var delegate: SelectedRoomTypeTableViewControllerProtocol?
    var roomType: RoomType?
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return  RoomType.all.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTypeCell")
        let roomType = RoomType.all[indexPath.row]
        cell?.accessoryType = roomType == self.roomType ? .checkmark : .none
        cell?.textLabel?.text = roomType.name
        cell?.detailTextLabel?.text = String(roomType.price)
        return cell! 
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        roomType = RoomType.all[indexPath.row]
        delegate?.didSelect(roomType: roomType!)
        tableView.reloadData()
    }
}
