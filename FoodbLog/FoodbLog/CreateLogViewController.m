//
//  CreateLogViewController.m
//  FoodbLog
//
//  Created by Ayuna Vogel on 10/11/15.
//  Copyright © 2015 Ayuna Vogel. All rights reserved.
//
#import <Parse/Parse.h>
#import <AFNetworking/AFNetworking.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIKit/UIKit.h>
#import <ChameleonFramework/Chameleon.h>
#import "CreateLogViewController.h"
#import "InstagramImagePicker.h"
#import "FoodLog.h"
#import "RestaurantPickerTableViewController.h"
#import "FoodFeedObject.h"
#import "RecipeTableViewController.h"

@interface CreateLogViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, CLLocationManagerDelegate, InstagramImagePickerDelegate, UIActionSheetDelegate,RestaurantPickerTableViewDelegate, RecipeTableViewDelegate>


@property (nonatomic) IBOutlet UITextField *foodLogTitleTextField;
@property (weak, nonatomic) IBOutlet UIImageView *foodLogImageView;
@property (strong, nonatomic) UIImage *foodLogImage;
@property (nonatomic) IBOutlet UITextField *restaurantSearchTextField;
@property (weak, nonatomic) IBOutlet UITextField *recipeSearchTextField;
@property (weak, nonatomic) IBOutlet UITextView *foodExperienceTextView;

@property (nonatomic) UIImagePickerController *imagePickerController;
@property (copy, nonatomic) NSString *lastChosenMediaType;

@property (nonatomic) NSString* recipeIngredientsToSave;

@property (weak, nonatomic) IBOutlet UIButton *snapAPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *searchAPicButton;

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic) CLLocation* userLocation;

- (void)saveButtonTapped;
- (void)setupNavigationBar;

- (BOOL)shouldPresentPhotoCaptureController;

@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property (nonatomic, assign) UIBackgroundTaskIdentifier photoPostBackgroundTaskId;


@end

@implementation CreateLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.locationManager = [[CLLocationManager alloc]init]; // initializing locationManager
    [self.locationManager setDelegate:self]; // we set the delegate of locationManager to self.
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];

    [self.locationManager startUpdatingLocation];

    self.foodLogTitleTextField.delegate = self;
    self.restaurantSearchTextField.delegate = self;
    self.recipeSearchTextField.delegate = self;

    [self setupNavigationBar];

    self.imagePickerController = [[UIImagePickerController alloc]init];
    self.imagePickerController.delegate = self;




    //Added formatting to text fields
    [self textFieldFormatting:self.foodLogTitleTextField];
    [self textFieldFormatting:self.restaurantSearchTextField];
    [self textFieldFormatting:self.recipeSearchTextField];

    self.foodExperienceTextView.delegate = self;

    self.snapAPhotoButton.backgroundColor = [UIColor whiteColor];
    self.searchAPicButton.backgroundColor = [UIColor whiteColor];




}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    self.foodLogImageView.layer.masksToBounds = YES;
    self.foodLogImageView.layer.cornerRadius = 10;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
}

#pragma mark - Formatting Methods

//Method for formatting text fields
-(void)textFieldFormatting:(UITextField *)textField{
    textField.layer.borderWidth = 1.0f;
    textField.layer.cornerRadius = 3.0;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = [[UIColor flatOrangeColor] CGColor];
    textField.inputAccessoryView = [[UIView alloc] init];
}


#pragma mark - Navigation Bar methods

-(void)setupNavigationBar {

    self.navigationItem.title = @"🍴🍜🍟🍤🍴";

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonTapped)];

    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];

}

-(void)cancelButtonTapped{

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - API requests methods

-(void)instagramRequestForTag:(NSString*)foodName
{

    
    foodName = [foodName stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSString *urlString = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=ac0ee52ebb154199bfabfb15b498c067", foodName];


    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc]init];
    [manager GET:urlString
      parameters:nil
         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
             
             NSArray *results = responseObject[@"data"];
             
             
             NSMutableArray* searchResults = [[NSMutableArray alloc] init];
             
             // loop through all json posts
             for (NSDictionary *result in results) {
                 ;
                 [searchResults addObject:result[@"images"][@"standard_resolution"][@"url"]];
                 
             }
             
             //pass the searchResults over to the CollectionViewController
             InstagramImagePicker* instagramPicker = [self.storyboard instantiateViewControllerWithIdentifier:@"InstagramImagePicker"];
             
             instagramPicker.delegate = self;
             instagramPicker.imageURLArray = searchResults;
             
             [self.navigationController pushViewController:instagramPicker animated:YES];
             
             NSLog(@"%@", searchResults);
             


         } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
             NSLog(@"%@", error);

         }];

}



-(void)foursquareRequestForRestaurantName:(NSString*)restaurantName {


    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?client_id=VENOVOCEM4E1QVRTGNOCNO40V32YHQ4FMRD0M3K4WBMYQWPS&client_secret=QVM22AMEWXEZ54VBHMGOHYE2JNMMLTQYKOKOSAK0JTGDQBLT&v=20130815&ll=%f,%f&query=%@&radius=2000", self.userLocation.coordinate.latitude, self.userLocation.coordinate.longitude, restaurantName];

    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc]init];
    [manager GET:urlString
      parameters:nil
         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {

             NSArray* venues = responseObject[@"response"][@"venues"];
             NSMutableArray<NSMutableDictionary*>* restaurantData = [[NSMutableArray alloc]init];
             for(NSDictionary* venue in venues){
                 
                 NSMutableDictionary* restaurantNamesAndAddresses = [[NSMutableDictionary alloc]init];

                 
                 [restaurantNamesAndAddresses setObject:venue[@"name"] forKey:@"restaurantName"];
                 
                 [restaurantNamesAndAddresses setObject:venue[@"location"][@"address"] forKey:@"restaurantAddress"];
                 
                 [restaurantData addObject:restaurantNamesAndAddresses];
                 
             }
             
             RestaurantPickerTableViewController* restaurantPicker = [self.storyboard instantiateViewControllerWithIdentifier:@"RestaurantPicker"];
             
             restaurantPicker.restaurantData = [NSArray arrayWithArray:restaurantData];
             
             restaurantPicker.delegate = self;
             
             [self.navigationController pushViewController:restaurantPicker animated:YES];
             
             
             

         } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
             NSLog(@"%@", error);
                NSLog(@"you are at %f and %f", self.userLocation.coordinate.latitude, self.userLocation.coordinate.longitude);

         }];




}
-(void)recipeRequestForString:(NSString*)string
{
    NSString* formattedInputString = [string stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString* URLString = [NSString stringWithFormat:@"http://food2fork.com/api/search?key=54f7d87124b73e5b6ea3a30f7ec3eb54&q=%@", formattedInputString];
    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    
    
    
    [manager GET:URLString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSArray* recipes = responseObject[@"recipes"];
        
        NSMutableArray<FoodFeedObject*>* recipeResultsArray = [[NSMutableArray alloc]init];
        for(NSDictionary* recipe in recipes){
            
            
            FoodFeedObject* recipeResultObject = [[FoodFeedObject alloc]init];
            recipeResultObject.imageURLString = recipe[@"image_url"];
            recipeResultObject.recipeID = recipe[@"recipe_id"];
            recipeResultObject.recipeTitle = recipe[@"title"];
            
            [recipeResultsArray addObject:recipeResultObject];
    
        }
        
        RecipeTableViewController* recipeTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RecipeTableViewController"];
        
        recipeTVC.recipeResultsArray = recipeResultsArray;
        recipeTVC.delegate = self;
        
        [self.navigationController pushViewController:recipeTVC animated:YES];
        
    
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"failure");
    }];
    

    
}


#pragma mark - RestaurantPickerTableViewDelegate method

- (void) didSelectRestaurant:(NSString *)restaurant {
    self.restaurantSearchTextField.text = restaurant;
    [self.navigationController popViewControllerAnimated:YES]; 
}

#pragma mark - RecipeTableViewDelegate method
-(void)didSelectRecipe:(NSString *)recipe withIngredients:(NSString *)ingredients {
    
    self.recipeSearchTextField.text = recipe;
    self.recipeIngredientsToSave = ingredients;
    NSLog(@"%@", self.recipeIngredientsToSave);
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


#pragma mark - Image Picker Controller Delegate methods

- (IBAction)snapAPhotoButtonTapped:(UIButton *)sender {

    BOOL cameraDeviceAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    BOOL photoLibraryAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];

    if (cameraDeviceAvailable && photoLibraryAvailable) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

        UIAlertAction *takePhoto;
        UIAlertAction *choosePhoto;
        UIAlertAction *cancelFoodLogPhotoTaking;

        takePhoto = [UIAlertAction actionWithTitle:@"Take Photo"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                                   [self shouldStartCameraController];
                                               }];
        choosePhoto = [UIAlertAction actionWithTitle:@"Choose Photo"
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction *action) {
                                                 [self shouldStartPhotoLibraryPickerController];
                                             }];

        cancelFoodLogPhotoTaking = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            //NSLog(@"canceled");
        }];

        [alertController addAction:takePhoto];
        [alertController addAction:choosePhoto];
        [alertController addAction:cancelFoodLogPhotoTaking];

        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        // if we don't have at least two options, we automatically show whichever is available (camera or roll)
        [self shouldPresentPhotoCaptureController];
    }

}

- (BOOL)shouldPresentPhotoCaptureController {
    BOOL presentedPhotoCaptureController = [self shouldStartCameraController];

    if (!presentedPhotoCaptureController) {
        presentedPhotoCaptureController = [self shouldStartPhotoLibraryPickerController];
    }

    return presentedPhotoCaptureController;
}


- (BOOL)shouldStartCameraController {

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return NO;
    }

    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
        && [[UIImagePickerController availableMediaTypesForSourceType:
             UIImagePickerControllerSourceTypeCamera] containsObject:(NSString *)kUTTypeImage]) {

        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;

        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        } else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }

    } else {
        return NO;
    }

    cameraUI.showsCameraControls = YES;
    cameraUI.delegate = self;

    [self presentViewController:cameraUI animated:YES completion:nil];

    return YES;
}


- (BOOL)shouldStartPhotoLibraryPickerController {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO
         && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return NO;
    }

    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] containsObject:(NSString *)kUTTypeImage]) {

        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];

    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]
               && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum] containsObject:(NSString *)kUTTypeImage]) {

        cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];

    } else {
        return NO;
    }

    cameraUI.delegate = self;

    [self presentViewController:cameraUI animated:YES completion:nil];

    return YES;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    UIImage *foodPhotoImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.foodLogImageView.image = foodPhotoImage;
    self.foodLogImageView.layer.masksToBounds = YES;
    self.foodLogImageView.layer.cornerRadius = 10;

    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self shouldStartCameraController];
    } else if (buttonIndex == 1) {
        [self shouldStartPhotoLibraryPickerController];
    }
}


#pragma mark - search a pic on instagram method

- (IBAction)searchAPicOnInstagramButtonTapped:(UIButton *)sender {

    [self instagramRequestForTag:self.foodLogTitleTextField.text];
    
}

#pragma mark - save image data to Parse

- (void)saveImageDataToParseRemoteDatabase {

    UIImage *imageToBeSavedOnParse = self.foodLogImageView.image;

    // Convert to JPEG with 50% quality
    NSData* data = UIImageJPEGRepresentation(imageToBeSavedOnParse, 0.5f);
    PFFile *imageFileToBeSavedOnParse = [PFFile fileWithName:@"Image.jpg" data:data];

    // Save the image to Parse

    [imageFileToBeSavedOnParse saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The image has now been uploaded to Parse. Associate it with a new object
            FoodLog *foodLog = [[FoodLog alloc] init];
            foodLog.image = imageFileToBeSavedOnParse;

            [foodLog saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"Saved");
                }
                else{
                    // Error
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
    }];
}

#pragma mark - Save button

- (void)saveButtonTapped {

    UIImage *foodLogImageToBeSaved = self.foodLogImageView.image;
    // Convert to JPEG with 50% quality
    NSData* data = UIImageJPEGRepresentation(foodLogImageToBeSaved, 0.5f);
    PFFile *imageFileToBeSavedOnParse = [PFFile fileWithData:data contentType:@"image/png"];

    // sending data to and storing in in Parse. This is a test version.
    FoodLog *foodLog = [[FoodLog alloc] init];
    foodLog.name = self.foodLogTitleTextField.text;
    foodLog.image = imageFileToBeSavedOnParse;
    foodLog.notes = self.foodExperienceTextView.text;
    foodLog.restaurantName = self.restaurantSearchTextField.text;
    foodLog.recipeName = self.recipeSearchTextField.text; 

    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];

    [foodLog saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

    [foodLog saveInBackground];

    UIImageWriteToSavedPhotosAlbum(foodLogImageToBeSaved, nil, nil, nil); // saves the snapped images to the camera roll on the device

}

#pragma mark CoreLocation delegate methods

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *crnLoc = [locations lastObject];
    self.userLocation = crnLoc;
}

#pragma mark InstagramImagePickerDelegate

-(void)imagePickerDidSelectImageWithURL:(NSString *)url {

    [self.foodLogImageView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

        self.foodLogImageView.image = image;

    }];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    if(textField.tag == 1){
        
        NSString* stringToSearch = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [self foursquareRequestForRestaurantName:stringToSearch];
    } else if(textField.tag == 2){
        NSLog(@"tag is 2!");
        [self recipeRequestForString:textField.text];
    } else {
        
        NSLog(@"what");
    }
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
      [textView setText:@""];
    textView.textColor = [UIColor blackColor];
}

-(void)textViewDidEndEditing:(UITextView *)textView{

    if ([textView.text isEqualToString:@""]) {
        textView.textColor = [UIColor lightGrayColor];
        [textView setText:@"Wanna Save Some Notes?"];
    }
}

@end
