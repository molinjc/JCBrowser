//
//  AlertHelper.m
//  ControlManageSystemProject
//
//  Created by guan song on 14-7-30.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "AlertHelper.h"

@implementation AlertHelper
/**
 *  创建一个提示框有代理，一个按钮
 *
 *  @param title             title
 *  @param message           message
 *  @param delegate          delegate
 *  @param cancelButtonTitle cancelButtonTitle
 */
+(void) showAlert:(NSString *)title
       andMessage:(NSString *)message
      andDelegate:(id) delegate
       andButtons:(NSString *)cancelButtonTitle
{
    UIAlertView * alertView =[[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles: nil];
    [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}
/**
 *  创建有代理的提示框默认是确认按你的
 *
 *  @param title    title
 *  @param message  message
 *  @param delegate delegate
 */
+(void) showAlert:(NSString *)title
       andMessage:(NSString *)message
      andDelegate:(id) delegate
{
    [self showAlert:title andMessage:message andDelegate:delegate andButtons:@"确定"];
}
/**
 *  创建有代理的提示框是确认，取消按钮的
 *
 *  @param title    title
 *  @param message  message
 *  @param delegate delegate
 */
+(void) showConfirm:(NSString *) title
         andMessage:(NSString *)message
        andDelegate:(id) delegate
{
    UIAlertView * alertView =[[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles: @"确定",nil];
    [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    
}

/**
 *  弹出一个对话框，一秒之后消失
 *
 *  @param message   提示消息
 *  @param superView 要显示的视图
 */
+(void) showOneSecond:(NSString *)message andDelegate:(UIView *) superView andBackgroundColor:(UIColor *)color
{
    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(superView.center.x-80, superView.frame.size.height*0.8, 160, 40)];
    v.backgroundColor= color;
  
    v.layer.cornerRadius=7;
    
    
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 160, 40)];
    lbl.tintColor=[UIColor blackColor];
    
    lbl.text=message;
    
    lbl.font=[UIFont systemFontOfSize:13];
    lbl.textAlignment=NSTextAlignmentCenter;
    [v  addSubview:lbl];
    
    [superView  performSelectorOnMainThread:@selector(addSubview:) withObject:v waitUntilDone:YES];
    
    [self  performSelectorOnMainThread:@selector(stop:) withObject:v waitUntilDone:YES];
}

+(void) showOneSecond:(NSString *)message andDelegate:(UIView *) superView
{
    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(superView.center.x-80, superView.frame.size.height*0.8, 160, 40)];
    v.backgroundColor= [UIColor greenColor];
    
    v.layer.cornerRadius=7;
    
    
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 160, 40)];
    lbl.tintColor=[UIColor blackColor];
    
    lbl.text=message;
    
    lbl.font=[UIFont systemFontOfSize:13];
    lbl.textAlignment=NSTextAlignmentCenter;
    [v  addSubview:lbl];
    
    [superView  performSelectorOnMainThread:@selector(addSubview:) withObject:v waitUntilDone:YES];
    
    [self  performSelectorOnMainThread:@selector(stop:) withObject:v waitUntilDone:YES];
}


/**
 *  1s移除
 *
 *  @param v 提示视图
 */
+(void)stop:(UIView *)v
{
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeView:) userInfo:v repeats:NO];
}
/**
 *  移除视图操作
 *
 *  @param sender 定时器对象
 */
+(void)removeView:(NSTimer *)sender
{
    UIView *v=[sender userInfo];
    
    
    [v  removeFromSuperview];
}

+(void) showWaiting:(NSString *)title
{
    NSLog(@"数据下载中。。。");
}
+(void) hideWaiting:(NSString *)title
{
    NSLog(@"数据下载完成...");
}

@end
