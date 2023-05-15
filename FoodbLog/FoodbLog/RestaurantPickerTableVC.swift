//
//  RestaurantPickerTableVC.swift
//  FoodbLog
//
//  Created by Ikmal Azman on 14/04/2023.
//  Copyright © 2023 Ayuna Vogel. All rights reserved.
//

import UIKit

protocol RestaurantPickerTableVCDelegate : AnyObject {
    func didSelectRestaurant(_ restaurant : String)
}

final class RestaurantPickerTableVC: UITableViewController {
    
    weak var delegate : RestaurantPickerTableVCDelegate?
    var data : [Restaurant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension RestaurantPickerTableVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let restaurant = data[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantNameCell", for: indexPath)
        cell.textLabel?.text = restaurant.name
        cell.detailTextLabel?.text = restaurant.location?.formattedAddress
        
        return cell
    }
}

extension RestaurantPickerTableVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedRestaurant = data[indexPath.row].name else {return}
        
        delegate?.didSelectRestaurant(selectedRestaurant)
        navigationController?.popViewController(animated: true)
    }
}
