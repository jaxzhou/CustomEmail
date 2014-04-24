//
//  ContactView.m
//  Email
//
//  Created by Zhou Jinxiu on 14-4-19.
//  Copyright (c) 2014年 com.vitatlas. All rights reserved.
//

#import "ContactView.h"
#import "TextRange.h"

@implementation ContactItem

-(id)initWithContact:(id)contact{
    self = [super init];
    if (self) {
        _contact = contact;
        [self setTextColor:[UIColor blueColor]];
        [self setHighlightedTextColor:[UIColor whiteColor]];
        NSString *display = [_contact objectForKey:@"name"] ? : [_contact objectForKey:@"mail"];
        if (display) {
            CGSize size = [display sizeWithAttributes:[NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName]];
            [self setFrame:CGRectMake(4, 2, size.width+8, size.height+4)];
            [self setText:display];
            [self setTextAlignment:NSTextAlignmentCenter];
        }

    }
    return self;
}

-(void)setSelected:(BOOL)selected{
    _selected = selected;
    [self setHighlighted:YES];
}


@end

@implementation ContactView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _contacts = [NSMutableArray array];
        _font = [UIFont systemFontOfSize:15];
        _lineHeight = frame.size.height;
        _inputTextField = [[UITextField alloc] initWithFrame:self.bounds];
        [_inputTextField setDelegate:self];
        [_inputTextField setFont:_font];
        [_inputTextField setKeyboardType:UIKeyboardTypeEmailAddress];
        [_inputTextField addTarget:self action:@selector(inputTextChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_inputTextField];
    }
    return self;
}

-(void)layoutSubviews{
    CGFloat x = 4;
    CGFloat y = (_lineHeight - self.font.lineHeight)/2;
    
    for (ContactItem *item in _contacts) {
        CGRect itemRect  = [item frame];
        if (x > 4 && itemRect.size.width + x > self.bounds.size.width - 4) {
            y += _font.lineHeight + 4;
            x = 4;
        }
        itemRect.origin.y = y;
        itemRect.origin.x = x;
        x += itemRect.size.width;
        [item setFrame:itemRect];
    }
    CGSize inputSize = [_inputTextField sizeThatFits:CGSizeMake(self.bounds.size.width, _font.lineHeight)];
    if (x > 4 && inputSize.width + x > self.bounds.size.width - 4 ) {
        y += _font.lineHeight + 4;
        x = 4;
    }
    [_inputTextField setFrame:CGRectMake(x, y, self.bounds.size.width-x,  _font.lineHeight+4)];
}

-(void)setFont:(UIFont *)font{
    _font = font;
    [_inputTextField setFont:_font];
}

-(void)addContact:(id)contact{
    ContactItem *item = [[ContactItem alloc] initWithContact:contact];
    [item setFont:_font];
    [_contacts addObject:item];
    [self addSubview:item];
    [self setNeedsLayout];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField text] && [[textField text] length] > 0) {
        NSString *txt = [textField text];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:[txt stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:@"mail"];
        [self addContact:dic];
        [textField setText:@" "];
    }
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@" "] || [string isEqualToString:@","]) {
        [self textFieldShouldReturn:_inputTextField];
        return NO;
    }else if([string isEqualToString:@""]){
        if ([[textField text] isEqualToString:@" "]) {
            [self deleteBackward];
        }else if(range.location == 0){
            [textField setText:@" "];
        }
        return NO;
    }
    [self setNeedsLayout];
    return YES;
}

-(void)deleteBackward{
    if ([_contacts count] > 0) {
        ContactItem *item = [_contacts lastObject];
        if ([item selected]) {
            [item removeFromSuperview];
            [_contacts removeLastObject];
            [self setNeedsLayout];
        }else{
            [item setSelected:YES];
        }
    }
}

-(BOOL)becomeFirstResponder{
    return [_inputTextField becomeFirstResponder];
}

-(NSArray*)contacts{
    NSMutableArray *contacts = [NSMutableArray array];
    for (ContactItem *item in _contacts) {
        [_contacts addObject:[item.contact copy]];
    }
    return contacts;
}

@end
