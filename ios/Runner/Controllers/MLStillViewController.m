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


- (void)btn01Clicked:(NSString *)imagePath completion:(void (^)(NSData *imgData))completion {
    
    self.analyzer = [MLImageSegmentationAnalyzer sharedInstance];

    _currentImage = [UIImage imageWithContentsOfFile:imagePath];
    
    if (!_currentImage) {
        NSLog(@"Please select a picture");
        return;
    }
    NSLog(@"_currentImage = %@", _currentImage);

    NSLog(@"imagePath = %@", imagePath);

    // Set up the analyzer
    [self setImgSegAnalyzerWithIndex:1];
    
    MLFrame *frame = [[MLFrame alloc] initWithImage:_currentImage];
        
    MLImageSegmentation *imgseg = [self.analyzer analyseFrame:frame];
    UIImage *bgImage = [imgseg getForeground];
    NSLog(@"bgImage = %@", bgImage);

//    // Convert UIImage to NSData
//    NSData *imageData = UIImageJPEGRepresentation(bgImage, 1.0);
//
//    // Get the path for tmp directory
//    NSString *tmpDirectory = NSTemporaryDirectory();
//    
//    // Build the complete path for the target file
//    NSString *filePath = [tmpDirectory stringByAppendingPathComponent:@"savedImage.jpg"];
//    
//    // Save NSData to file
//    if ([imageData writeToFile:filePath atomically:YES]) {
//        NSLog(@"Image saved successfully at %@", filePath);
//        if (completion) {
//            completion(filePath);
//        }
//    } else {
//        NSLog(@"Error saving image to file at %@", filePath);
//    }
    //png格式

    NSData *imagedata=UIImagePNGRepresentation(bgImage);
    NSLog(@"imagedata = %@", imagedata);
    completion(imagedata);
    //JEPG格式

    //NSData *imagedata=UIImageJEPGRepresentation(m_imgFore,1.0);

//    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//
//    NSString *documentsDirectory=[paths objectAtIndex:0];
//
//    NSString *savedImagePath=[documentsDirectory stringByAppendingPathComponent:@"saveFore.png"];
//
//    [imagedata writeToFile:savedImagePath atomically:YES];
//    NSLog(@"savedImagePath %@", savedImagePath);

    //或者

//    [fileManager createFileAtPath:[filePath stringByAppendingString:@"/image.png"] contents:data attributes:nil];   // 将图片保存为PNG格式
//
//     [fileManager createFileAtPath:[filePath stringByAppendingString:@"/image.jpg"] contents:data attributes:nil];  // 将图片保存为JPEG格式
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

