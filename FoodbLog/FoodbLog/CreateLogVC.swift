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
    var foodbLogInteractor = FoodbLogInteractorImpl()
    
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
        requestImageForTag(foodLogTitleTextField.text ?? "-")
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

extension CreateLogVC : RestaurantPickerTableVCDelegate {
    func didSelectRestaurant(_ restaurant: String) {
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

extension CreateLogVC : UnsplashImagePickerVCDelegate {
    func didSelectImageWithURL(_ url: String) {
        guard let url = URL(string: url) else {return}
        foodLogImageView.sd_setImage(with: url)
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
        let latitude = "\(userLocation?.coordinate.latitude ?? 0.0)"
        let longitute = "\( userLocation?.coordinate.longitude ?? 0.0)"
        
        foodbLogInteractor.requestRestaurantName(query, latitude, longitute) { result in
            
            switch result {
            case .success(let data):
                self.displaySearchResults(data.results)
            case .failure(let error):
                print("Failed fetch searched restaurant : \(error.localizedDescription)")
            }
        }
    }
    
    func displaySearchResults(_ results : [Restaurant]) {
        DispatchQueue.main.async {
            let restaurantPickerTVC = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantPickerTableViewController") as! RestaurantPickerTableVC
            restaurantPickerTVC.data = results
            restaurantPickerTVC.delegate = self
            
            self.navigationController?.pushViewController(restaurantPickerTVC, animated: true)
        }
    }
    
    // MARK:  Recipes API Request method
    func recipeRequestForString(_ recipe : String) {
        let formattedInputString = recipe.replacingOccurrences(of: " ", with: "%20")
        
        foodbLogInteractor.requestRecipes(formattedInputString) { result in
            switch result {
            case .success(let data):
                self.displayRecipeResults(data.results)
            case .failure(let failure):
                print("Failure to fetch recipes : \(failure.localizedDescription)")
            }
        }
    }
    
    func displayRecipeResults(_ recipes : [Recipe]) {
        DispatchQueue.main.async {
            let recipeTVC = self.storyboard?.instantiateViewController(withIdentifier: "RecipeTableViewController") as! RecipeTableViewController
#warning("replace with recipe object once this refactoringt complete")
            recipeTVC.recipeResultsArray = []
            recipeTVC.delegate = self
            
            self.navigationController?.pushViewController(recipeTVC, animated: true)
        }
    }
    
    // MARK:  Unsplash Image API Request method
    func requestImageForTag(_ foodName : String) {
        let foodName = foodName.replacingOccurrences(of: " ", with: "")
        foodbLogInteractor.requestInstagramHastags(foodName) { result in
            switch result {
            case .success(let success):
                self.displayTagResults(success.results)
            case .failure(let failure):
                print("Error request IG Hashtags : \(failure.localizedDescription)")
            }
        }
    }
    
    func displayTagResults(_ tags : [Tag]) {
        DispatchQueue.main.async {
            let instagramPickerVC = self.storyboard?.instantiateViewController(withIdentifier: "InstagramImagePicker") as! UnsplashImagePickerVC
            
            
#warning("replace with tags object once this refactoringt complete")
            instagramPickerVC.data = tags
            instagramPickerVC.delegate = self
            
            self.navigationController?.pushViewController(instagramPickerVC, animated: true)
        }
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
