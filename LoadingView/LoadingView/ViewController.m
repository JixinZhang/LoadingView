//
//  ViewController.m
//  LoadingView
//
//  Created by WSCN on 8/22/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "ViewController.h"
#import "LoadingView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()
@property (nonatomic, strong) LoadingView *loadingView;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UILabel *speedLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.loadingView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.loadingView];
    
    self.slider = [[UISlider alloc] init];
    self.slider.frame = CGRectMake(100, kScreenHeight - 50, 200, 30);
    self.slider.minimumValue = 5.0f;
    self.slider.maximumValue = 20.0f;
    [self.slider setValue:10 animated:YES];
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider];
    
    self.speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreenHeight - 50, 70, 30)];
    self.speedLabel.font = [UIFont systemFontOfSize:10.f];
    self.speedLabel.text = @"速度：10";
    [self.view addSubview:self.speedLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sliderValueChanged:(UISlider *)sender {
    UISlider *slider = sender;
    self.speedLabel.text = [NSString stringWithFormat:@"速度：%.1f",slider.value];
    [self.loadingView setSpeedOfLoadingView:slider.value];
}

@end
