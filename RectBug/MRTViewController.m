//
//  MRTViewController.m
//  RectBug
//
//  Created by Michele Titolo on 2/20/14.
//  Copyright (c) 2014 Michele TItolo. All rights reserved.
//

#import "MRTViewController.h"

@interface MRTViewController ()

@property (nonatomic, copy) NSString* baseString;
@property (nonatomic, strong) NSMutableDictionary* attributes;
@property (nonatomic, strong) NSParagraphStyle* paragraphStyle;

@end

@implementation MRTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.baseString = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"threadless" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableParagraphStyle* style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = 0.9;
    self.attributes = [@{NSFontAttributeName: [UIFont systemFontOfSize:70], NSParagraphStyleAttributeName: style} mutableCopy];
    self.paragraphStyle = style;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)runPressed:(id)sender
{
    [self calculateStringForFrame:CGRectMake(100, 100, 100, 100)];
}

- (IBAction)attributeSwitchChanged:(id)sender
{
    if (((UISwitch*)sender).on) {
        NSLog(@"Paragraph style added");
        [self.attributes setObject:self.paragraphStyle forKey:NSParagraphStyleAttributeName];
    }
    else {
        NSLog(@"Paragraph style removed");
        [self.attributes removeObjectForKey:NSParagraphStyleAttributeName];
    }
}

- (void)calculateStringForFrame:(CGRect)frame
{
    
    NSString* newString = self.baseString;
    
    NSStringDrawingContext* context = [[NSStringDrawingContext alloc] init];
    context.minimumScaleFactor = 1.0;
    
    NSAttributedString* attrString = [[NSAttributedString alloc] initWithString:newString attributes:self.attributes];
    
    CGRect newFrame = [attrString boundingRectWithSize:frame.size options:NSStringDrawingUsesLineFragmentOrigin context:context];
    

    while (newFrame.size.width > frame.size.width) {
        
        newString = [newString substringFromIndex:newString.length/2];
        
        NSAttributedString* newAttrString = [[NSAttributedString alloc] initWithString:newString attributes:self.attributes];
        
        newFrame = [newAttrString boundingRectWithSize:frame.size options:NSStringDrawingUsesLineFragmentOrigin context:context];
    }
    
    NSLog(@"New string length: %d\nFrame: %@", newString.length, NSStringFromCGRect(newFrame));
}

@end
