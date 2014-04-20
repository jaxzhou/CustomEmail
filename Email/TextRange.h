//
//  TextRange.h
//  Email
//
//  Created by Zhou Jinxiu on 14-4-19.
//  Copyright (c) 2014年 com.vitatlas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextPosition : UITextPosition

@property (nonatomic,assign) NSInteger location;

@end

@interface TextRange : UITextRange{
    NSRange _txtRange;
}

-(NSInteger)length;

-(id)initWithNSRange:(NSRange)range;

@end
