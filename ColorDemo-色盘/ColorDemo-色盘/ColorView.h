//
//  ColorView.h
//  ColorDemo-色盘
//
//  Created by cxb on 2017/5/16.
//  Copyright © 2017年 pgq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ColorViewType) {
    RGB_Hue_Brightness = 0,//颜色、色温、亮度调节
    Hue_Brightness,//色温、亮度调节
    Brightness,//亮度调节
};


@interface ColorView : UIView
+ (instancetype)createWithFrmae:(CGRect)frame colorType:(ColorViewType)type;
/**
 重要属性，决定显示啥样子的ColorView,默认为 RGB_Hue_Brightness
 */
@property (nonatomic, assign) ColorViewType colorType;


/**
 当前的颜色此方法仅用于RGB

 @param block 颜色回调
 */
- (void)nowColor:(void(^)(UIColor * color))block;

/**
 色温

 @param block 色温
 */
- (void)showNowColor:(void(^)(UIColor * color))block;

/**
 色温值

 @param block 回调
 */
- (void)nowYW:(void(^)(CGFloat y , CGFloat w))block;

/**
 单调光

 @param block 回调
 */
- (void)onlyBrightness:(void(^)(CGFloat brightness))block;

@end
