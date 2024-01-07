//
//  MLStillViewController.m
//  Runner
//
//  Created by Ge YuMing on 2024/1/7.
//
#import <UIKit/UIKit.h>
#include <sys/time.h>
#import "MLStillViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MLImageSegmentationLibrary/MLImageSegmentationLibrary.h>

static NSString * const kOriginalCollectionName = @"imgseg_origin";

static NSString * const kProcessCollectionName = @"imgseg_process";

@interface MLStillViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    UIImage *_currentImage;
}


@property(nonatomic, strong) MLImageSegmentationAnalyzer *analyzer;

@property(nonatomic, strong) UIActivityIndicatorView *loadingView;

@end

@implementation MLStillViewController

- (void)dealloc {
    
    [self.analyzer stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.analyzer = [MLImageSegmentationAnalyzer sharedInstance];
    
}

#pragma mark - lazy

- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    return _loadingView;
}

#pragma mark - nav

- (void)rightNavBtnClicked {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark - action


- (void)btn01Clicked:(NSString *)imagePath {
    _currentImage = [UIImage imageWithContentsOfFile:imagePath];
    if (!_currentImage) {
        printf("Please select a picture");
        return;
    }
    
    // Set up the analyzer
    [self setImgSegAnalyzerWithIndex:1];
    
    MLFrame *frame = [[MLFrame alloc] initWithImage:_currentImage];
        
    MLImageSegmentation *imgseg = [self.analyzer analyseFrame:frame];
//    self.bgImageView.image = [imgseg getForeground];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
        
    NSString *mediaType = [info valueForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        
        [picker dismissViewControllerAnimated:YES completion:^{
            UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
            
            self->_currentImage = image;
        }];
    }
}

#pragma mark - private

- (void)setImgSegAnalyzerWithIndex:(NSInteger)index {
    
    MLImageSegmentationSetting *setting = nil;
    setting = [[MLImageSegmentationSetting alloc] init];
    [setting setAnalyzerType:MLImageSegmentationAnalyzerTypeBody];
    [setting setScene:MLImageSegmentationSceneForegroundOnly];
    [setting setExact:YES];
    [self.analyzer setImageSegmentationAnalyzer:setting];
}

@end

