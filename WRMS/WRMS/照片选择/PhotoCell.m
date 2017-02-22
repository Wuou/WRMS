//
//  PhotoCell.m
//  JKImagePicker
//
//  Created by Jecky on 15/1/16.
//  Copyright (c) 2015年 Jecky. All rights reserved.
//

#import "PhotoCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoCell()


@end

@implementation PhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Create a image view
        self.backgroundColor = [UIColor clearColor];
        [self imageView];
        [self Contentlabel];
    }
    
    return self;
}

- (void)setAsset:(JKAssets *)asset{
    if (_asset != asset) {
        _asset = asset;
        
        ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
        [lib assetForURL:_asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
            if (asset) {
                               
                self.imageView.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            }
        } failureBlock:^(NSError *error) {

        }];
    }

}


- (UILabel *)Contentlabel{
    if (!_labelContent) {
//        _labelContent = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        _labelContent = [[UILabel alloc] initWithFrame:CGRectMake(0, self.contentView.bounds.size.height - 20, self.contentView.bounds.size.width, 20)];
        _labelContent.backgroundColor = [UIColor grayColor];
        _labelContent.clipsToBounds = YES;
//         self.labelContent.text = @"视频";
         _labelContent.font = [UIFont boldSystemFontOfSize:12];
        [_labelContent setTextColor:[UIColor whiteColor]];
        _labelContent.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _labelContent.alpha = 0.5;
//        _labelContent.layer.cornerRadius = 6.0f;
//        _labelContent.layer.borderColor = [UIColor clearColor].CGColor;
//        _labelContent.layer.borderWidth = 0.5;
        [self.contentView addSubview:_labelContent];
    }
    return _labelContent;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.clipsToBounds = YES;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView.layer.cornerRadius = 6.0f;
        _imageView.layer.borderColor = [UIColor clearColor].CGColor;
        _imageView.layer.borderWidth = 0.5;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

@end
