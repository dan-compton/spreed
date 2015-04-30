//
//  AppDelegate.h
//  spreed
//
//  Created by dniced on 6/23/14.
//  Copyright (c) 2014 dcompton. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (weak) IBOutlet NSTextField *wpmLabel;

@property (strong, nonatomic) IBOutlet WebView * textView;
@property (weak) IBOutlet NSSlider *speedSlider;

@property (assign) IBOutlet NSWindow *window;
- (NSString*) splitString:(NSString*) word;
@end
