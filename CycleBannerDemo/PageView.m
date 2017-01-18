//
//  PageView.m
//  CycleBannerDemo
//
//  Created by apple on 17/1/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "PageView.h"
#import "ZZHImageView.h"
#define COUNT 3

@interface PageView ()<UIScrollViewDelegate>


@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation PageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self getUI];
    }
    return self;
}


- (void)getUI{
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.pageIndicatorTintColor = [UIColor cyanColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageControl.hidesForSinglePage = YES;
    [self addSubview:self.pageControl];
}

#pragma mark fram 改变调用
-(void)layoutSubviews{
    //imageView 的宽高
    CGFloat scrollW = self.frame.size.width;
    CGFloat scrollH = self.frame.size.height;
    //imageView 的个数
    NSInteger count = self.scrollView.subviews.count;
    NSLog(@"count: %ld", count);
    //pageControl的坐标
    CGFloat pageW = 100;
    CGFloat pageH = 50;
    CGFloat pageX = scrollW - pageW;
    CGFloat pageY = scrollH - pageH;
    self.pageControl.frame = CGRectMake(pageX, pageY, pageW, pageH);
    
    self.scrollView.frame = self.bounds;
    
    for (int i = 0 ; i< count;i++){
        
        ZZHImageView * imageView = self.scrollView.subviews[i];
        
        imageView.frame = CGRectMake(i*scrollW, 0, scrollW, scrollH);
        
    }
    self.scrollView.contentSize = CGSizeMake(scrollW*count, 0);
    
    self.pageControl.numberOfPages = self.imageArr.count;
    
    [self updateImage];
    
}

#pragma mark  更新图片 渲染
- (void)updateImage{
    
    //始终让中间的图片显示
    //图片变换顺序后 设置scrollView contentOffset 显示中间
    for (int i = 0; i < COUNT; i++) {
        ZZHImageView *imageView = self.scrollView.subviews[i];
        NSInteger index = self.pageControl.currentPage;
        if(i == 0){
            
            index--;
            
        }else if (i == 2){
            index++;
        }
        
        if (index < 0) {
            //第一张的前一张是最后一张
            index = self.imageArr.count - 1;
        } else if (index >= self.imageArr.count) {
            //最后一张的的后一张是第一张
            index = 0;
        }
        //把index赋给imageView  起到媒介作用， 后面拿到tag 就是pageControl的index
        imageView.tag = index;
        imageView.image = [UIImage imageNamed:self.imageArr[index]];
        
    }
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    
}

- (void)imageViewClick:(ZZHImageView *)imageView{
    
    
    NSInteger index = imageView.tag;
    [self.delegate pageViewDidClick:index];
    
    self.clickBlock(index);

}

-(void)setNormalColor:(UIColor *)normalColor{
    
    _normalColor = normalColor;
    self.pageControl.pageIndicatorTintColor = normalColor;
    
}
-(void)setSelectColor:(UIColor *)selectColor{
    
    _selectColor = selectColor;
    self.pageControl.currentPageIndicatorTintColor = selectColor;
}

#pragma mark -set
-(void)setImageArr:(NSArray *)imageArr{
    
    _imageArr = imageArr;
    
    for (int i = 0; i < COUNT; i++) {
        
        ZZHImageView *imageView = [[ZZHImageView alloc] init];
        imageView.image = [UIImage imageNamed:_imageArr[i]];
        [imageView addTarget:self action:@selector(imageViewClick:)];
        [self.scrollView addSubview:imageView];
    }
     [self startTimer];
}

#pragma mark - 定时器处理
- (void)startTimer
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(next) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)next
{
    
    [self.scrollView setContentOffset:CGPointMake(2 * self.scrollView.frame.size.width, 0) animated:YES];
    
}

#pragma mark - scrollview
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //找到位于最中间的imageView;
    //scroll滚动时 判断三个图片的x与scrollView的contentOffset的x 的绝对值最小的就是即将停在最中间的imageView
    NSInteger page = 0;
    CGFloat minDistance = MAXFLOAT;
    for (int i = 0; i < COUNT; i++) {
        ZZHImageView *imageView = self.scrollView.subviews[i];
        CGFloat distance = ABS(imageView.frame.origin.x - scrollView.contentOffset.x);
        if (distance < minDistance) {
            minDistance = distance;
            //拿到中间位置的tag 设置 pageControl 的currentPage
            page = imageView.tag;
        }
    }
    self.pageControl.currentPage = page;
}

//手动拖拽结束后重新渲染
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateImage];
}
//定时器 动画结束后重新渲染
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    [self updateImage];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}


@end
