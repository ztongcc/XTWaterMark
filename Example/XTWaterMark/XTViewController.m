//
//  XTViewController.m
//  XTWaterMark
//
//  Created by zt.cheng on 11/30/2020.
//  Copyright (c) 2020 zt.cheng. All rights reserved.
//

#import "XTViewController.h"
#import <XTWaterMark.h>


@interface XTViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation XTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.image = [UIImage imageNamed:@"288x407.jpeg"];
    
    
    // huhui
}


- (IBAction)onGenerateWaterMark:(UIButton *)sender {
    XTMark * mark = [XTMark mark];
    mark.markText = @"WaterMark";
    mark.font = [UIFont systemFontOfSize:14];
    mark.textColor = [UIColor lightGrayColor];
    
    XTMarkOption * option = [XTMarkOption defaultOption];
    option.verticalSpace = 80;
    option.horizontalSpace = 60;
    option.orginalImage = [UIImage imageNamed:@"288x407.jpeg"];
    
    [XTWaterMark generateWaterMark:mark option:option completion:^(UIImage * _Nonnull waterMarkImage) {
        self.imageView.image = waterMarkImage;
    }];
}

- (IBAction)onGenerateComplexWaterMark:(id)sender {
    XTMark * mark1 = [XTMark mark];
    mark1.markText = @"WaterMark";
    mark1.font = [UIFont systemFontOfSize:14];
    mark1.textColor = [UIColor lightGrayColor];
    
    XTMark * mark2 = [XTMark mark];
    mark2.markText = @"ztongcc@163.com";
    mark2.font = [UIFont systemFontOfSize:10];
    mark2.textColor = [[UIColor magentaColor] colorWithAlphaComponent:0.8];
    mark2.margin = UIEdgeInsetsMake(0, 20, 0, 30);
    
    XTMarkOption * option = [XTMarkOption defaultOption];
    option.verticalSpace = 80;
    option.horizontalSpace = 60;
    option.orginalImage = [UIImage imageNamed:@"288x407.jpeg"];
    
    [XTWaterMark generateWaterMarks:@[mark1, mark2] option:option completion:^(UIImage * _Nonnull waterMarkImage) {
        self.imageView.image = waterMarkImage;
    }];
}

- (IBAction)onGenerateInvisibleWaterMark:(id)sender {
    XTMark * mark = [XTMark mark];
    mark.markText = @"WaterMark";
    mark.font = [UIFont systemFontOfSize:14];
    mark.textColor = [UIColor lightGrayColor];
    
    XTMarkOption * option = [XTMarkOption defaultOption];
    option.verticalSpace = 20;
    option.horizontalSpace = 60;
    option.orginalImage = [UIImage imageNamed:@"288x407.jpeg"];
    
    [XTWaterMark generateInvisibleWaterMark:mark option:option completion:^(UIImage * _Nonnull waterMarkImage) {
        self.imageView.image = waterMarkImage;
    }];
}

- (IBAction)onShowInvisibleWaterMark:(id)sender {
    [XTWaterMark visibleWatermark:self.imageView.image completion:^(UIImage * _Nonnull image) {
        self.imageView.image = image;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
