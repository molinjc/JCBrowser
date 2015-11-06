//
//  JCBarView.h
//  JCBrowser
//
//  Created by molin on 15/11/4.
//  Copyright © 2015年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JCBarViewDelegate <NSObject>

- (void)advanceEvent;
- (void)retreatEvent;
- (void)closeEvent;
- (void)refreshEvent;
- (void)listEvent;
- (void)startEventWithAddress:(NSString *)address;

@end

@interface JCBarView : UIView

@property (nonatomic, weak) id<JCBarViewDelegate> delegate;

@property (nonatomic, copy) NSString *title;

/**
 *  初始化
 */
- (instancetype)init;


@end
