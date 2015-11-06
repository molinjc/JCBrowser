//
//  JCImageSeeView.h
//  图片查看视图
//  含有plist文件，数组->字典->图片名，图片描述
//  创建该View，需获取plist文件里的数据，使用数组传过来
//

#import <UIKit/UIKit.h>

@interface JCImageSeeView : UIView
@property(nonatomic,assign)NSInteger tally;//下标
@property(nonatomic,strong)NSDictionary *dic; //字典（包含图片信息）
@property(nonatomic,strong)NSArray *arrImage;//数组（包含字典）
@property(nonatomic,strong)UIImageView *imgV;//图片视图
@property(nonatomic,strong)UILabel *lblTally;//张数描述
@property(nonatomic,strong)UILabel *lblInfo;//图片描述

/**
 *  初始化方法
 */
-(instancetype)initWithFrame:(CGRect)frame andImageArray:(NSArray *)arrImage;

/**
 *  根据图片地址展示图片
 *
 *  @param path 图片地址
 */
- (void)showToImageWithPath:(NSString *)path;

/**
 *  刷新视图
 */
- (void)reloadImageView;

@end
