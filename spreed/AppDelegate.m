//
//  AppDelegate.m
//  spreed
//
//  Created by dniced on 6/23/14.
//  Copyright (c) 2014 dcompton. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

int i = 0;
float wpmCount = 300.0;
float lastTimerInterval;

NSArray *textContent;
NSTimer *readTimer;

- (NSString*) splitString:(NSString*) word{
    
    int separator = (int)[word length]/2;
    // we want 7 charachters to the left of the separator and seven to the right

    /*
        There will be 7 characters before the middle character.
        "12345AbC123456"
        "ABcD"
        "amendment"
     */
    int spaceLeft = 15 - separator-1; // words to the left of the separator
    
    NSMutableString *blah = [[NSMutableString alloc] init];
    for(int i=0; i<spaceLeft; i++)
    {
        [blah appendString:@""];
    }
    for (int i = 0; i < [word length]; i++) {
        NSString *ch = [word substringWithRange:NSMakeRange(i, 1)];
        if(i!=separator){
            [blah appendString:ch];
        }
        else{
            [blah appendString:@"<span style=\"color:black;\">"];
            [blah appendString:ch];
            [blah appendString:@"</span>"];
        }
    }
 

    return [NSString stringWithString:blah];
}

- (IBAction)sliderChanged:(id)sender
{
    NSSlider *slider = (NSSlider *)sender;
    wpmCount = slider.intValue;
    [self.wpmLabel setStringValue:[NSString stringWithFormat:@"%f", wpmCount]];
    [readTimer invalidate];
    readTimer = [NSTimer scheduledTimerWithTimeInterval:60/wpmCount
                                                 target:self
                                               selector:@selector(updateLabel)
                                               userInfo:nil
                                                repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:readTimer forMode:NSRunLoopCommonModes];
}

- (void) updateLabel {
    if(i < [textContent count]){
        NSString * divStart = @"<div style=\"text-align:center; letter-spacing:3px;font-family:Consolas, sans-serif, Monospace; width:100%; font-size:30px; \">";
        NSString * content = [self splitString:[textContent[i] lowercaseString]];
        NSString * divEnd = @"</div>";
        NSString * html = [NSString stringWithFormat:@"%@%@%@", divStart, content, divEnd ];
        [self.textView.mainFrame loadHTMLString:html baseURL:nil];
        i++;

        //NSLog(@"%@", textContent[i]);
        
    }
    else{
        [readTimer invalidate];
        readTimer = nil;
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    wpmCount = self.speedSlider.intValue;
    [self.wpmLabel setStringValue:[NSString stringWithFormat:@"%f", wpmCount]];

     readTimer = [NSTimer scheduledTimerWithTimeInterval:60/wpmCount
                                                        target:self
                                                      selector:@selector(updateLabel)
                                                      userInfo:nil
                                                       repeats:YES];
    
    // TODO: Add button to choose file type
    NSString * path = @"/Users/dniced/Desktop/article.txt";
    

    NSFileHandle * fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    if(fileHandle == nil){
        NSLog(@"Failed to open file!");
    }
    else{
        NSString * file = [NSString stringWithContentsOfFile:path
            encoding:NSASCIIStringEncoding
            error:nil];
        // remove extraneous spaces
        NSError * error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[ \n]+" options:NSRegularExpressionCaseInsensitive error:&error];
        NSString *modifiedString = [regex stringByReplacingMatchesInString:file options:0 range:NSMakeRange(0, [file length]) withTemplate:@" "];
        
        textContent = [modifiedString componentsSeparatedByString:@" "];
        //NSLog(@"file contents: %@", file);
    }
    [fileHandle closeFile];
    
    [[NSRunLoop mainRunLoop] addTimer:readTimer forMode:NSRunLoopCommonModes];

}

@end
