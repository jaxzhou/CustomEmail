//
//  ContactView.m
//  Email
//
//  Created by Zhou Jinxiu on 14-4-19.
//  Copyright (c) 2014年 com.vitatlas. All rights reserved.
//

#import "ContactView.h"
#import "TextRange.h"

@implementation ContactView
@synthesize inputDelegate;
@synthesize tokenizer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _contacts = [NSMutableArray array];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(UIKeyboardType)keyboardType{
    return UIKeyboardTypeEmailAddress;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGFloat x = 2.0;
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (NSDictionary *c in _contacts) {
        NSString *display = [c objectForKey:@"name"] ? [c objectForKey:@"name"] : [c objectForKey:@"mail"];
        CGSize nameSize = [display sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName]];
        CGFloat fullWidth = nameSize.width + 10;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, 2, fullWidth, self.bounds.size.height-4) cornerRadius:10];
        CGContextAddPath(context, path.CGPath);
        [[UIColor greenColor] setFill];
        CGContextFillPath(context);
        
        [[UIColor whiteColor] setFill];
        
        CGRect nameRect =CGRectMake(x+5, (self.bounds.size.height-nameSize.height)/2, nameSize.width, self.bounds.size.height-4);
        [display drawInRect:nameRect withAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName]];
        x += fullWidth;
        [@"," drawAtPoint:CGPointMake(x+1, CGRectGetMaxY(nameRect)) withAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName]];
        x += 2.0;
    }
    if (_inputingText) {
        UIFont *font = [UIFont systemFontOfSize:15];
        [_inputingText drawAtPoint:CGPointMake(x, (self.bounds.size.height-font.lineHeight)/2) withAttributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]];
    }
}

- (NSComparisonResult)comparePosition:(UITextPosition *)position toPosition:(UITextPosition *)other{
    return [[NSNumber numberWithInteger:[(TextPosition*)position location]]  compare:[NSNumber numberWithInteger:[(TextPosition*)other location]]];
}

- (NSInteger)offsetFromPosition:(UITextPosition *)from toPosition:(UITextPosition *)toPosition{
    return [(TextPosition*)toPosition location] - [(TextPosition*)from location];
}

- (NSString *)textInRange:(UITextRange *)range{
    if ([(TextPosition*)range.start location] < [_contacts count]) {
        id c = [_contacts objectAtIndex:[(TextPosition*)range.start location]];
        return [c objectForKey:@"mail"];
    }else{
        NSRange txtRange = NSMakeRange([(TextPosition*)range.start location]-[_contacts count], [(TextRange*)range length]);
        if (txtRange.location!=NSNotFound) {
            return [_inputingText substringWithRange:txtRange];
        }
        return nil;
    }
}

- (void)replaceRange:(UITextRange *)range withText:(NSString *)text{
    if ([(TextPosition*)range.start location] < [_contacts count]) {
        
    }else{
        NSInteger s = [(TextPosition*)range.start location]-[_contacts count];
        [_inputingText replaceCharactersInRange:NSMakeRange(s, [(TextRange*)range length]) withString:text];
    }
}

-(UITextPosition*)beginningOfDocument{
    TextPosition *pos = [[TextPosition alloc] init];
    pos.location = 0;
    return pos;
}

-(UITextPosition*)endOfDocument{
    TextPosition *pos = [[TextPosition alloc] init];
    pos.location = [_contacts count] + _inputingText.length;
    return pos;
}

- (UITextRange *)textRangeFromPosition:(UITextPosition *)fromPosition toPosition:(UITextPosition *)toPosition{
    NSInteger start = [(TextPosition*)fromPosition location];
    NSInteger end = [(TextPosition*)toPosition location];
    return [[TextRange alloc] initWithNSRange:NSMakeRange(start, end-start)];
}

- (UITextPosition *)positionFromPosition:(UITextPosition *)position offset:(NSInteger)offset{
    TextPosition *pos = [[TextPosition alloc] init];
    pos.location = offset;
    return pos;
}

- (UITextPosition *)positionFromPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction offset:(NSInteger)offset{
    TextPosition *pos = [[TextPosition alloc] init];
    pos.location = offset + [(TextPosition*)position location];
    return pos;
}

- (UITextPosition *)positionWithinRange:(UITextRange *)range farthestInDirection:(UITextLayoutDirection)direction{
    return range.end;
}

- (UITextRange *)characterRangeByExtendingPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction{
    NSInteger loc = [(TextPosition*)position location];
    return [[TextRange alloc] initWithNSRange:NSMakeRange(loc, 1)];
}

- (void)setMarkedText:(NSString *)markedText selectedRange:(NSRange)selectedRange{
    
}

-(UITextRange*)markedTextRange{
    return [[TextRange alloc] initWithNSRange:NSMakeRange([_contacts count]+[_inputingText length], 0)];
}

-(UITextRange*)selectedTextRange{
    return nil;
}

- (UITextWritingDirection)baseWritingDirectionForPosition:(UITextPosition *)position inDirection:(UITextStorageDirection)direction{
    return UITextWritingDirectionLeftToRight;
}

- (void)setBaseWritingDirection:(UITextWritingDirection)writingDirection forRange:(UITextRange *)range{
    
}

- (CGRect)firstRectForRange:(UITextRange *)range{
    NSInteger loc = [(TextPosition*)range.start location];
    if (loc < [_contacts count]) {
        float x = 2.0;
        for (NSInteger i = 0; i < loc; i ++) {
            id c =  [_contacts objectAtIndex:i];
            NSString *display = [c objectForKey:@"name"] ? [c objectForKey:@"name"] : [c objectForKey:@"mail"];
            CGSize nameSize = [display sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName]];
            CGFloat fullWidth = nameSize.width + 10;
            x += fullWidth;
            x += 2.0;
        }
        
        id c =  [_contacts objectAtIndex:loc];
        NSString *display = [c objectForKey:@"name"] ? [c objectForKey:@"name"] : [c objectForKey:@"mail"];
        CGSize nameSize = [display sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName]];
        CGFloat fullWidth = nameSize.width + 10;
        return CGRectMake(x, 0, fullWidth, self.bounds.size.height);
    }else{
        float x = 2.0;
        for (NSInteger i = 0; i < [_contacts count]; i ++) {
            id c =  [_contacts objectAtIndex:i];
            NSString *display = [c objectForKey:@"name"] ? [c objectForKey:@"name"] : [c objectForKey:@"mail"];
            CGSize nameSize = [display sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName]];
            CGFloat fullWidth = nameSize.width + 10;
            x += fullWidth;
            x += 2.0;
        }
        NSInteger len = [(TextPosition*)range.start location] - [_contacts count];
        NSString *preTxt = [self textInRange:[[TextRange alloc] initWithNSRange:NSMakeRange([_contacts count], len)]];
        CGSize txtSize = [preTxt sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName]];
        x += txtSize.width;
        return CGRectMake(x, 0, [UIFont systemFontOfSize:15].pointSize, self.bounds.size.height);
    }
}

- (CGRect)caretRectForPosition:(UITextPosition *)position{
    NSInteger loc = [(TextPosition*)position location];
    if (loc < [_contacts count]) {
        float x = 2.0;
        for (NSInteger i = 0; i < loc; i ++) {
            id c =  [_contacts objectAtIndex:i];
            NSString *display = [c objectForKey:@"name"] ? [c objectForKey:@"name"] : [c objectForKey:@"mail"];
            CGSize nameSize = [display sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName]];
            CGFloat fullWidth = nameSize.width + 10;
            x += fullWidth;
            x += 2.0;
        }
        
        id c =  [_contacts objectAtIndex:loc];
        NSString *display = [c objectForKey:@"name"] ? [c objectForKey:@"name"] : [c objectForKey:@"mail"];
        CGSize nameSize = [display sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName]];
        CGFloat fullWidth = nameSize.width + 10;
        return CGRectMake(x, 0, fullWidth, self.bounds.size.height);
    }else{
        float x = 2.0;
        for (NSInteger i = 0; i < [_contacts count]; i ++) {
            id c =  [_contacts objectAtIndex:i];
            NSString *display = [c objectForKey:@"name"] ? [c objectForKey:@"name"] : [c objectForKey:@"mail"];
            CGSize nameSize = [display sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName]];
            CGFloat fullWidth = nameSize.width + 10;
            x += fullWidth;
            x += 2.0;
        }
        NSInteger len = [(TextPosition*)position location] - [_contacts count];
        NSString *preTxt = [self textInRange:[[TextRange alloc] initWithNSRange:NSMakeRange([_contacts count], len)]];
        CGSize txtSize = [preTxt sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName]];
        x += txtSize.width;
        return CGRectMake(x, 0, [UIFont systemFontOfSize:15].pointSize, self.bounds.size.height);
    }
}

- (NSArray *)selectionRectsForRange:(UITextRange *)range{
    NSMutableArray  *arr = [NSMutableArray array];
    [arr addObject:[NSValue valueWithCGRect:[self firstRectForRange:range]]];
    return arr;
}

- (UITextPosition *)closestPositionToPoint:(CGPoint)point{
    NSInteger loc = 0;
    float x = 2.0;
    for (NSInteger i = 0; i < [_contacts count]; i ++) {
        id c =  [_contacts objectAtIndex:i];
        NSString *display = [c objectForKey:@"name"] ? [c objectForKey:@"name"] : [c objectForKey:@"mail"];
        CGSize nameSize = [display sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName]];
        CGFloat fullWidth = nameSize.width + 10;
        if (point.x > x && point.x < x + fullWidth) {
            loc = i;
            break;
        }
        x += fullWidth;
        x += 2.0;
    }
    if (point.x > x) {
        NSString *preTxt = _inputingText;
        CGSize txtSize = [preTxt sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName]];
        if (x + txtSize.width > point.x) {
            loc = (point.x - x)/[UIFont systemFontOfSize:15].pointSize;
            loc += [_contacts count];
        }
    }
    TextPosition *pos = [[TextPosition alloc] init];
    pos.location = loc;
    return pos;
}

- (UITextPosition *)closestPositionToPoint:(CGPoint)point withinRange:(UITextRange *)range{
    
    NSInteger loc = 0;
    float x = 2.0;
    for (NSInteger i = 0; i < [_contacts count]; i ++) {
        id c =  [_contacts objectAtIndex:i];
        NSString *display = [c objectForKey:@"name"] ? [c objectForKey:@"name"] : [c objectForKey:@"mail"];
        CGSize nameSize = [display sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName]];
        CGFloat fullWidth = nameSize.width + 10;
        if (point.x > x && point.x < x + fullWidth) {
            loc = i;
            break;
        }
        x += fullWidth;
        x += 2.0;
    }
    if (point.x > x) {
        NSString *preTxt = _inputingText;
        CGSize txtSize = [preTxt sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName]];
        if (x + txtSize.width > point.x) {
            loc = (point.x - x)/[UIFont systemFontOfSize:15].pointSize;
            loc += [_contacts count];
        }
    }
    TextPosition *pos = [[TextPosition alloc] init];
    pos.location = loc;
    return pos;
}

- (UITextRange *)characterRangeAtPoint:(CGPoint)point{
    TextPosition *pos = (TextPosition *)[self closestPositionToPoint:point];
    TextRange *range = [[TextRange alloc] initWithNSRange:NSMakeRange(pos.location, 1)];
    return range;
}

- (void)unmarkText{
    
}
- (id<UITextInputTokenizer>)tokenizer {
    if (tokenizer == nil) {
        tokenizer = [[UITextInputStringTokenizer alloc] initWithTextInput:self];
    }
    return tokenizer;
}

- (BOOL)hasText{
    return YES;
}

- (void)insertText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        if (_inputingText) {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:_inputingText forKey:@"mail"];
            [_contacts addObject:dic];
            _inputingText = nil;
            [self setNeedsDisplay];
        }
    }else{
        if (!_inputingText) {
            _inputingText = [NSMutableString stringWithString:@""];
        }
        [_inputingText appendString:text];
        [self setNeedsDisplay];
    }
}

- (void)deleteBackward{
    if (_inputingText && [_inputingText length] > 0) {
        [_inputingText deleteCharactersInRange:NSMakeRange(_inputingText.length-1, 1)];
    }else if([_contacts count] > 0){
        [_contacts removeLastObject];
    }
    [self setNeedsDisplay];
}

-(BOOL)canBecomeFirstResponder{
    return true;
}

-(void)addContact:(id)contact{
    [_contacts addObject:contact];
    
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self becomeFirstResponder];
}
@end
