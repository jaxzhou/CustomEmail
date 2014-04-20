//
//  TextRange.m
//  Email
//
//  Created by Zhou Jinxiu on 14-4-19.
//  Copyright (c) 2014年 com.vitatlas. All rights reserved.
//

#import "TextRange.h"

@implementation TextPosition


@end

@implementation TextRange


-(id)initWithNSRange:(NSRange)range{
    self = [super init];
    if (self) {
        
        _txtRange = range;
    }
    return self;
}

-(NSInteger)length{
    return _txtRange.length;
}

-(UITextPosition*)start{
    TextPosition *positon = [[TextPosition alloc] init];
    positon.location = _txtRange.location;
    return positon;
}

-(UITextPosition*)end{
    TextPosition *positon = [[TextPosition alloc] init];
    positon.location = _txtRange.location+_txtRange.length;
    return positon;
}

@end
