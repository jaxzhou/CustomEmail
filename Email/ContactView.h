//
//  ContactView.h
//  Email
//
//  Created by Zhou Jinxiu on 14-4-19.
//  Copyright (c) 2014年 com.vitatlas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactItem : UILabel{
    
}

@property (nonatomic,retain) id contact;
@property (nonatomic,assign) BOOL selected;

-(id)initWithContact:(id)contact;


@end

@interface ContactView : UIView <UITextFieldDelegate>{
    NSMutableArray *_contacts;
    UITextField *_inputTextField;
    
    CGFloat _lineHeight;
}

@property (nonatomic,retain) UIFont *font;

-(void)addContact:(id)contact;

-(NSArray*)contacts;

@end
