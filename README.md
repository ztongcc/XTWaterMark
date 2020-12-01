# XTWaterMark

[![CI Status](https://img.shields.io/travis/zt.cheng/XTWaterMark.svg?style=flat)](https://travis-ci.org/zt.cheng/XTWaterMark)
[![Version](https://img.shields.io/cocoapods/v/XTWaterMark.svg?style=flat)](https://cocoapods.org/pods/XTWaterMark)
[![License](https://img.shields.io/cocoapods/l/XTWaterMark.svg?style=flat)](https://cocoapods.org/pods/XTWaterMark)
[![Platform](https://img.shields.io/cocoapods/p/XTWaterMark.svg?style=flat)](https://cocoapods.org/pods/XTWaterMark)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

XTWaterMark is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'XTWaterMark'
```

## Use

You can generate a single style watermark:

```ruby
    XTMark * mark = [XTMark mark];
    mark.markText = @"WaterMark";
    mark.font = [UIFont systemFontOfSize:14];
    mark.textColor = [UIColor lightGrayColor];
    
    XTMarkOption * option = [XTMarkOption defaultOption];
    option.verticalSpace = 80;
    option.horizontalSpace = 60;
    option.orginalImage = [UIImage imageNamed:@"288x407.jpeg"];
    
    [XTWaterMark generateWaterMark:mark option:option completion:^(UIImage * _Nonnull waterMarkImage) {
    // this will get a water mark iamge. 
    }];
```






## Author

zt.cheng, ztongcc@163.com

## License

XTWaterMark is available under the MIT license. See the LICENSE file for more info.
