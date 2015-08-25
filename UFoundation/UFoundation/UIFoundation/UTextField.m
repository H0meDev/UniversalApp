//
//  BaseTextField.m
//  UFoundation
//
//  Created by Think on 15/5/12.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "UTextField.h"
#import "UDefines.h"

@implementation UTextField

@synthesize backgroundView = _backgroundView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initalize
        _textInsets = edgeMake(0, 0, 0, 0);
        
        [self backgroundView];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Properties

- (UImageView *)backgroundView
{
    if (_backgroundView) {
        return _backgroundView;
    }
    
    UImageView *backgroundView = [[UImageView alloc]init];
    backgroundView.backgroundColor = sysClearColor();
    _backgroundView = backgroundView;
    
    return _backgroundView;
}

- (void)setFrame:(CGRect)frame
{
    CGRect rframe = rectMake(frame.origin.x + _textInsets.left,
                             frame.origin.y + _textInsets.top,
                             frame.size.width - _textInsets.left - _textInsets.right,
                             frame.size.height - _textInsets.top - _textInsets.bottom);
    [super setFrame:rframe];
    
    self.backgroundView.frame = frame;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.superview) {
        [self.superview addSubview:self.backgroundView];
        [self.superview insertSubview:self.backgroundView belowSubview:self];
    }
}

- (void)setTextInsets:(UIEdgeInsets)textInsets
{
    CGRect frame = self.backgroundView.frame;
    frame = rectMake(frame.origin.x + textInsets.left,
                     frame.origin.y + textInsets.top,
                     frame.size.width - textInsets.left - textInsets.right,
                     frame.size.height - textInsets.top - textInsets.bottom);
    // Resize
    [super setFrame:frame];
    
    _textInsets = textInsets;
}

- (void)setBackgroundColor:(UIColor *)color
{
    [super setBackgroundColor:sysClearColor()];
    
    self.backgroundView.backgroundColor = color;
}

- (void)removeFromSuperview
{
    [self.backgroundView removeFromSuperview];
    
    [super removeFromSuperview];
}

@end
