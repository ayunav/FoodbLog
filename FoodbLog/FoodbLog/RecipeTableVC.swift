//
//  RecipeTableVC.swift
//  FoodbLog
//
//  Created by Ikmal Azman on 15/04/2023.
//  Copyright © 2023 Ayuna Vogel. All rights reserved.
//

import UIKit

protocol RecipeTableVCDelegate : AnyObject {
    func didSelecteRecipe(_ recipe : String, withIngredients ingredients : String)
}

final class RecipeTableVC: UITableViewController {

    weak var delegate : RecipeTableVCDelegate?
    var data : [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension RecipeTableVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = data[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeTableViewCell
        cell.recipeName.text = recipe.title
        if let imageURL = URL(string: recipe.imageURL) {
            cell.recipeImage.sd_setImage(with: imageURL)
        }

        return cell
    }
}

extension RecipeTableVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRecipe = data[indexPath.row]
        let ingredients = selectedRecipe.ingredients.joined(separator: ", ")
        
        delegate?.didSelecteRecipe(selectedRecipe.title, withIngredients: ingredients)
        navigationController?.popViewController(animated: true)
    }
}
