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
    if (!self.image && !self.videoFilePath) {
        [self presentViewController:_imagePickerController animated:YES completion:^{
            if (self.dataHandler) {
                [self.dataHandler dataSource:^{
                    [self.activityIndicator stopAnimating];
                    [self.tableView reloadData];
                }];
            }
        }];
    } else {
        self.cancel.enabled = self.send.enabled = YES;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataHandler = [RBRecipientsDataHandler new];
    self.tableView.dataSource = self.dataHandler;
    self.tableView.delegate = self.dataHandler;

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
#pragma mark - Image Picker Controller

- (void)imagePickerControllerSettings {
    self.imagePickerController = [UIImagePickerController new];
    self.imagePickerController.delegate = self;
    self.imagePickerController.allowsEditing = NO;
    self.imagePickerController.videoMaximumDuration = 10;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    self.imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePickerController.sourceType];
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
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (self.imagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera) {
            //Photo taken, save it
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        }
    } else {
        //Video taken or selected
        self.videoFilePath = [NSString stringWithFormat:@"%@", [[info objectForKey:UIImagePickerControllerMediaURL] path]];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);
        }
    }
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBActions 

- (void)reset {
    self.image = nil;
    self.videoFilePath = nil;
    [self.dataHandler.recipients removeAllObjects];
    [self.tableView reloadData];
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction)cancel:(id)sender {
    [self reset];
}

- (IBAction)send:(id)sender {

    if (!self.image && !self.videoFilePath) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Try again!" message:@"Please capture a video or a photo to share!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    } else {
        [self uploadMessage];
    }
}

- (void)uploadMessage {
    LogTrace(@"%@", self.dataHandler.recipients);
    if (self.image) {
        UIImage *image = [self resizeImage:_image width:230.0f height:480.0f];
        [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] windows] lastObject] animated:YES];
        @weakify(self);
        [[RBService service] uploadImage:image recipients:self.dataHandler.recipients success:^(BOOL succeeded) {
            @strongify(self);
            [MBProgressHUD hideHUDForView:[[[UIApplication sharedApplication] windows] lastObject] animated:YES];
            [self reset];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"NICE!" message:@"Nailed it!!!" delegate:self cancelButtonTitle:@"Pica, pica!" otherButtonTitles:nil];
            [alertView show];
        } failure:^{
            @strongify(self);
            [self failedToUploadMessage];
        }];
    } else {
        [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] windows] lastObject] animated:YES];
        @weakify(self);
        [[RBService service] uploadVideo:self.videoFilePath recipients:self.dataHandler.recipients success:^(BOOL succeeded) {
            @strongify(self);
            [MBProgressHUD hideHUDForView:[[[UIApplication sharedApplication] windows] lastObject] animated:YES];
            [self reset];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"NICE!" message:@"Nailed it!!!" delegate:self cancelButtonTitle:@"Pica, pica!" otherButtonTitles:nil];
            [alertView show];
        } failure:^{
            @strongify(self);
            [self failedToUploadMessage];
        }];

    }
}

- (void)failedToUploadMessage {
    [MBProgressHUD hideHUDForView:[[[UIApplication sharedApplication] windows] lastObject] animated:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Obs!" message:@"Please try sending your message again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
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