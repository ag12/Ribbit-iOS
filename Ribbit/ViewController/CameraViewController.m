//
//  CameraViewController.m
//  Ribbit
//
//  Created by Amir Ghoreshi on 10/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "RBRecipientsDataHandler.h"
#import "RBUploadData.h"
#import "MBProgressHUD.h"
#import "RACEXTScope.h"

@interface CameraViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *videoFilePath;
@property (nonatomic) RBRecipientsDataHandler *dataHandler;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *send;

@end

@implementation CameraViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self imagePickerControllerSettings];
    if (!_image && !_videoFilePath) {
        [self presentViewController:_imagePickerController animated:YES completion:^{

        }];
    } else {
        _cancel.enabled = _send.enabled = YES;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataHandler = [RBRecipientsDataHandler new];
    _tableView.dataSource = _dataHandler;
    _tableView.delegate = _dataHandler;

    [self.dataHandler dataSource:^{
        [_activityIndicator stopAnimating];
        [_tableView reloadData];
    }];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
#pragma mark - Image Picker Controller

- (void)imagePickerControllerSettings {
    _imagePickerController = [UIImagePickerController new];
    _imagePickerController.delegate = self;
    _imagePickerController.allowsEditing = NO;
    _imagePickerController.videoMaximumDuration = 10;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    _imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:_imagePickerController.sourceType];
}

#pragma mark - Image Picker Controller delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tabBarController setSelectedIndex:0];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];

    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        //Photo taken or selected
        _image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (_imagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera) {
            //Photo taken, save it
            UIImageWriteToSavedPhotosAlbum(_image, nil, nil, nil);
        }
    } else {
        //Video taken or selected
        _videoFilePath = [NSString stringWithFormat:@"%@", [[info objectForKey:UIImagePickerControllerMediaURL] path]];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(_videoFilePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum(_videoFilePath, nil, nil, nil);
        }
    }
    [_imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBActions 

- (void)reset {
    _image = nil;
    _videoFilePath = nil;
    [_dataHandler.recipients removeAllObjects];
    [_tableView reloadData];
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction)cancel:(id)sender {
    [self reset];
}

- (IBAction)send:(id)sender {

    if (!_image && !_videoFilePath.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Try again!" message:@"Please capture a video or a photo to share!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    } else {
        [self uploadMessage];
        
    }
}

- (void)uploadMessage {
    LogTrace(@"%@", _dataHandler.recipients);

    if (_image) {
        UIImage *image = [self resizeImage:_image width:230.0f height:480.0f];
        [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] windows] lastObject] animated:YES];

        @weakify(self);
        [self.dataHandler.service uploadFile:image recipients:self.dataHandler.recipients success:^(BOOL succeeded) {
            @strongify(self);
            [MBProgressHUD hideHUDForView:[[[UIApplication sharedApplication] windows] lastObject] animated:YES];
            [self reset];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"NICE!" message:@"Nailed it!!!" delegate:self cancelButtonTitle:@"Pica, pica!" otherButtonTitles:nil];
            [alertView show];
        } failure:^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Obs!" message:@"Please try sending your message again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }];

    } else {

    }
}

- (UIImage *)resizeImage:(UIImage *)image width:(float)width height:(float)height {


    CGSize newSize = CGSizeMake(width, height);
    CGRect rectangle = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [_image drawInRect:rectangle];
    UIImage *resizedImaged = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImaged;
}
@end