//
//  PageView.h
//  CycleBannerDemo
//
//  Created by apple on 17/1/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PageViewDelegate <NSObject>

- (void)pageViewDidClick: (NSInteger)index;

@end

@interface PageView : UIImageView

@property (nonatomic, copy) void (^clickBlock)(NSInteger );
@property (nonatomic, weak) id<PageViewDelegate>delegate;
@property (nonatomic, copy) NSArray *imageArr;

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectColor;

@end
