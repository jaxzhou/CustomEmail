//
//  ContactView.h
//  Email
//
//  Created by Zhou Jinxiu on 14-4-19.
//  Copyright (c) 2014年 com.vitatlas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactView : UIView <UITextInput,UITextInputTraits>{
    NSMutableArray *_contacts;
    NSMutableString *_inputingText;
    id<UITextInputTokenizer> tokenizer;
}

@property (nonatomic, assign) id <UITextInputDelegate> inputDelegate;

-(void)addContact:(id)contact;

@end
