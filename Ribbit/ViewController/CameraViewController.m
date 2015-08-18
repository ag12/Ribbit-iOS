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
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }
    if (self.dataHandler) {
        [self.dataHandler dataSource:^{
            [self.tableView reloadData];
        }];
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

- (IBAction)cancel:(id)sender {
    _image = nil;
    _videoFilePath = nil;
    [_dataHandler.recipients removeAllObjects];
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction)send:(id)sender {
}

@end