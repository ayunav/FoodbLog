//
//  CreateLogVC.swift
//  FoodbLog
//
//  Created by Ikmal Azman on 05/04/2023.
//  Copyright © 2023 Ayuna Vogel. All rights reserved.
//

import UIKit
import SDWebImage
import Parse

final class CreateLogVC: UIViewController {
    @IBOutlet weak var foodLogTitleTextField : UITextField!
    @IBOutlet weak var snapAPhotoButton : UIButton!
    @IBOutlet weak var searchAPicButton : UIButton!
    @IBOutlet weak var foodLogImageView : UIImageView!
    @IBOutlet weak var restaurantSearchTextField: UITextField!
    @IBOutlet weak var recipeSearchTextField: UITextField!
    @IBOutlet weak var foodExperienceTextView : UITextView!
    
    var foodLogImage : UIImage?
    var recipeIngredientsToSave : String?
    var imagePickerController : UIImagePickerController = UIImagePickerController()
    var lastChosenMediaType : String?
    var shouldPresentPhotoCaptureController : Bool = false
    var locationManager : CLLocationManager = CLLocationManager()
      
    var userLocation : CLLocation?
    
    
    var fileUploadBackgroundTaskID : UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 1)
    var photoPostBackgroundTaskID : UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLocationManager()
        setupTextEditor()
        setupImagePicker()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
}

extension CreateLogVC {
    @IBAction func searcAPicOnIntagramButtonTapped(_ sender : UIButton) {
        instagramRequestForTag(foodLogTitleTextField.text ?? "-")
    }
    
    @IBAction func snapAPhotoButtonTapped(_ sender : UIButton) {
        let alertControler = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default, handler: shouldStartCameraController(_:))
        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default, handler: shouldStartPhotoLibraryPickerController(_:))
        let cancelMediaSelection = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertControler.addAction(takePhoto)
        alertControler.addAction(choosePhoto)
        alertControler.addAction(cancelMediaSelection)
        present(alertControler, animated: true)
    }
}

extension CreateLogVC {
    func saveDataToParse() {
        let imageToBeSave = foodLogImageView.image ?? UIImage()
        let data = imageToBeSave.jpegData(compressionQuality: 0.5) ?? Data()
        let imageFileToBeSavedOnParse = PFFile(data: data, contentType: "image/png")
        
        // sending data to and storing it on Parse
        let foodLog = FoodLog()
        foodLog.name = foodLogTitleTextField.text
        foodLog.image = imageFileToBeSavedOnParse
        foodLog.notes = foodExperienceTextView.text
        foodLog.restaurantName = restaurantSearchTextField.text
        foodLog.recipeName = recipeSearchTextField.text
        
        let uiApplication = UIApplication.shared
        
        fileUploadBackgroundTaskID = uiApplication.beginBackgroundTask {
            uiApplication.endBackgroundTask(self.fileUploadBackgroundTaskID)
        }
        
        foodLog.saveInBackground { _, _ in
            self.dismiss(animated: true)
        }
        
        UIImageWriteToSavedPhotosAlbum(imageToBeSave, nil, nil, nil)
    }
}

extension CreateLogVC {
    func shouldStartPhotoLibraryPickerController(_ action :UIAlertAction?) {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true)
    }
    
    func shouldStartCameraController(_ action : UIAlertAction?) {
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true)
    }
}

extension CreateLogVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.userLocation = locations.last
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error retrieving location : \(error.localizedDescription)")
        
        let alert = UIAlertController(
            title: "Error",
            message: "There was an error retrieving your location",
            preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        
        self.present(alert, animated: true)
    }
}

extension CreateLogVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == restaurantSearchTextField {
            requestRestaurantName(textField.text ?? "-")
        } else if textField == recipeSearchTextField {
            recipeRequestForString(textField.text ?? "-")
        }
        
        return true
    }
    
}

extension CreateLogVC : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView.text == "" else {return}
        textView.text = "Wanna Save Some Notes?"
        textView.textColor = .lightGray
    }
}

extension CreateLogVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let foodImage = info[.originalImage] as? UIImage else {return}
        foodLogImageView.image = foodImage
        foodLogImageView.layer.masksToBounds = true
        foodLogImageView.layer.cornerRadius = 10
        
        picker.dismiss(animated: true)
    }
}

extension CreateLogVC : RestaurantPickerTableViewDelegate {
    func didSelectRestaurant(_ restaurant: String!) {
        restaurantSearchTextField.text = restaurant
    }
}

extension CreateLogVC : RecipeTableViewDelegate {
    func didSelectRecipe(_ recipe: String!, withIngredients ingredients: String!) {
        recipeSearchTextField.text = recipe
        recipeIngredientsToSave = ingredients
        navigationController?.popViewController(animated: true)
    }
    
}

extension CreateLogVC : InstagramImagePickerDelegate {
    func imagePickerDidSelectImage(withURL url: String!) {
        guard let url = URL(string: url) else {return}
        self.foodLogImageView.setImageWith(url, placeholderImage: UIImage()) { image, error, _ in
            self.foodLogImageView.image = image
        }
    }
}

extension CreateLogVC {
    func actionSheet(_ actionSheet : UIActionSheet, clickedButtonAtIndex buttonIndex : Int) {
        if buttonIndex == 0 {
            shouldStartCameraController(nil)
        } else {
            shouldStartPhotoLibraryPickerController(nil)
        }
    }
}

extension CreateLogVC {
    // MARK:  Fousquare API Request method
    func requestRestaurantName(_ name : String) {
        let query = name
        let latitude : Double = userLocation?.coordinate.latitude ?? 0.0
        let longitute : Double = userLocation?.coordinate.longitude ?? 0.0
        
        let urlString = "https://api.foursquare.com/v2/venues/search?client_id=VENOVOCEM4E1QVRTGNOCNO40V32YHQ4FMRD0M3K4WBMYQWPS&client_secret=QVM22AMEWXEZ54VBHMGOHYE2JNMMLTQYKOKOSAK0JTGDQBLT&v=20130815&ll=\(latitude),\(longitute)&query=\(query)&radius=2000"
        
        guard let url = URL(string: urlString) else {return}
        
        let header = [
            "accept": "application/json",
             "Authorization": "fsq330X+8o6/JsdNbbyzjYaEqXORJTZvanpmRWgb4MVsW8E="
        ]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = header
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                print("Error to search restaurant name : \(error.localizedDescription)")
                print("You are at \(latitude) & \(longitute)")
            }
            
            guard let data = data else {return}
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let restaurants = try decoder.decode(RestaurantResponse.self, from: data)
                self.displaySearchResults(restaurants.results)
                
            } catch {
                print("Error decode data : \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func displaySearchResults(_ results : [Restaurant]) {
        let restaurantPickerTVC = storyboard?.instantiateViewController(withIdentifier: "RestaurantPickerTableViewController") as! RestaurantPickerTableViewController
        #warning("replace with restaurant object once this refactoringt complete")
        restaurantPickerTVC.restaurantData = [[:]]
        restaurantPickerTVC.delegate = self
        
        navigationController?.pushViewController(restaurantPickerTVC, animated: true)
    }
    
    // MARK:  Recipes API Request method
    #warning("need to replace with other recipe api due the current API provider was shut down")
    func recipeRequestForString(_ recipe : String) {
        let formattedInputString = recipe.replacingOccurrences(of: " ", with: "%20")
        
        let urlString = "https://forkify-api.herokuapp.com/api/get?rId=%\(formattedInputString)"
        
        guard let url = URL(string: urlString) else {return}
        
        let urlRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                print("Error to request recipe for \(recipe) : \(error.localizedDescription)")
            }
            
            guard let data = data else {return}
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let recipes = try decoder.decode(RecipeResponse.self, from: data)
                self.displayRecipeResults(recipes.recipes)
                
            } catch {
                print("Error decode data : \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func displayRecipeResults(_ recipes : [Recipe]) {
        let recipeTVC = storyboard?.instantiateViewController(withIdentifier: "RecipeTableViewController") as! RecipeTableViewController
#warning("replace with recipe object once this refactoringt complete")
        recipeTVC.recipeResultsArray = []
        recipeTVC.delegate = self
        
        self.navigationController?.pushViewController(recipeTVC, animated: true)
    }
    
    // MARK:  Instagram Image API Request method
    func instagramRequestForTag(_ foodName : String) {
        let foodName = foodName.replacingOccurrences(of: " ", with: "")
        
        let urlString = "https://api.instagram.com/v1/tags/\(foodName)/media/recent?client_id=ac0ee52ebb154199bfabfb15b498c067"
        
        guard let url = URL(string: urlString) else {return}
        
        let urlRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                print("Error to request tag for \(foodName) : \(error.localizedDescription)")
            }
            
            guard let data = data else {return}
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            do {
                let recipes = try decoder.decode(TagResponse.self, from: data)
                self.displayTagResults(recipes.data)
                
            } catch {
                print("Error decode data : \(error.localizedDescription)")
            }
        }
        
        task.resume()
        
    }
    
    func displayTagResults(_ tags : [Tag]) {
        let instagramPickerVC = storyboard?.instantiateViewController(withIdentifier: "InstagramImagePickerViewController") as! InstagramImagePicker
        
        
#warning("replace with tags object once this refactoringt complete")
        instagramPickerVC.imageURLArray = []
        instagramPickerVC.delegate = self
        
        navigationController?.pushViewController(instagramPickerVC, animated: true)
    }
}

private extension CreateLogVC {
    func setupImagePicker() {
        imagePickerController.delegate = self
        
        snapAPhotoButton.backgroundColor = .white
        searchAPicButton.backgroundColor = .white
        
        foodLogImageView.layer.masksToBounds = true
        foodLogImageView.layer.cornerRadius = 10
        
    }
    
    func setupTextEditor() {
        foodLogTitleTextField.delegate = self
        setTextFieldFormatting(foodLogTitleTextField)
        
        restaurantSearchTextField.delegate = self
        setTextFieldFormatting(restaurantSearchTextField)
        
        recipeSearchTextField.delegate = self
        setTextFieldFormatting(recipeSearchTextField)
        
        foodExperienceTextView.delegate = self
    }
    
    func setTextFieldFormatting(_ textfield : UITextField) {
        textfield.layer.borderWidth = 1
        textfield.layer.cornerRadius = 2
        textfield.layer.masksToBounds = true
        textfield.layer.borderColor = UIColor.flatOrange().cgColor
        textfield.inputAccessoryView = UIView()
    }
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func setupNavigationBar() {
        navigationItem.title = "🍴🍜🍟🍤🍴"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped(_:)))
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped(_:)))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    @objc func cancelButtonTapped(_ button : UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @objc func saveButtonTapped(_ button : UIBarButtonItem) {
        saveDataToParse()
     
    }
}

//import Foundation
//
//let headers = [
//  "accept": "application/json",
//  "Authorization": "fsq330X+8o6/JsdNbbyzjYaEqXORJTZvanpmRWgb4MVsW8E="
//]
//
//let request = NSMutableURLRequest(url: NSURL(string: "https://api.foursquare.com/v3/places/search?query=donut&ll=38.656555%2C-77.250441&radius=2000")! as URL,
//                                        cachePolicy: .useProtocolCachePolicy,
//                                    timeoutInterval: 10.0)
//request.httpMethod = "GET"
//request.allHTTPHeaderFields = headers
//
//let session = URLSession.shared
//let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//  if (error != nil) {
//    print(error as Any)
//  } else {
//    let httpResponse = response as? HTTPURLResponse
//    print(httpResponse)
//  }
//})

// dataTask.resume()

//{
//  "results": [
//    {
//      "fsq_id": "4b61ab65f964a520881c2ae3",
//      "categories": [
//        {
//          "id": 13001,
//          "name": "Bagel Shop",
//          "icon": {
//            "prefix": "https://ss3.4sqi.net/img/categories_v2/food/bagels_",
//            "suffix": ".png"
//          }
//        }
//      ],
//      "link": "/v3/places/4b61ab65f964a520881c2ae3",
//      "location": {
//        "address": "13607 Richmond Hwy",
//        "census_block": "511539006021000",
//        "country": "US",
//        "cross_street": "",
//        "dma": "Washington, Dc-Hagrstwn",
//        "formatted_address": "13607 Richmond Hwy, Woodbridge, VA 22191",
//        "locality": "Woodbridge",
//        "postcode": "22191",
//        "region": "VA"
//      },
//      "name": "Dunkin'",
//      "related_places": {},
//      "timezone": "America/New_York"
//    }
//  ],
//}

struct RestaurantResponse : Decodable {
    let results : [Restaurant]
}

struct Restaurant : Decodable {
    let name : String?
    let location : RestaurantLocation?
}

struct RestaurantLocation : Decodable {
    let formattedAddress : String
}

struct RecipeResponse : Decodable {
    let recipes : [Recipe]
}

struct Recipe : Decodable {
    let imageURL : String
    let recipeID : String
    let title : String
}


struct TagResponse : Decodable {
    let data : [Tag]
}

struct Tag : Decodable {
    let images : [String]
    let standardResolution : String
    let URL : String
}