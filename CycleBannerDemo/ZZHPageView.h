//
//  ZZHPageView.h
//  CycleBannerDemo
//
//  Created by apple on 17/1/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZZHPageViewDelegate <NSObject>

@optional
- (void)pageViewDidClick:(NSInteger)index;

@end

@interface ZZHPageView : UIImageView

@property (nonatomic, copy)NSArray * imageArr;
@property (nonatomic, strong)UIColor * normalColor;
@property (nonatomic, copy) void (^clickBlock)(NSInteger );
@property (nonatomic, weak) id<ZZHPageViewDelegate>delegate;
@property (nonatomic,strong)UIColor * selectColor;

+(instancetype)pageView;

@end
