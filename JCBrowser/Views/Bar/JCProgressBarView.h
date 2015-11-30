//
//  JCProgressBarView.h
//  JCBrowser
//
//  Created by molin on 15/11/28.
//  Copyright © 2015年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCProgressBarView : UIView

@property (nonatomic, assign) int image_quantity_get;
@property (nonatomic, assign) int downloader_finish;
@property (nonatomic, copy) NSString *image_url_downloader;

- (instancetype)initWithPlace:(CGPoint)place;

@end
