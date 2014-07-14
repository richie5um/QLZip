#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>

// RichS: Added Imports
#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "RSQuickLookZIP.h"
#import "RSGlobals.h"

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options);
void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview);

/* -----------------------------------------------------------------------------
   Generate a preview for file

   This function's job is to create preview for designated file
   ----------------------------------------------------------------------------- */

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options)
{
    if (QLPreviewRequestIsCancelled(preview)) return noErr;
    
    NSDictionary *props = @{
        (__bridge NSString *)kQLPreviewPropertyTextEncodingNameKey:@"UTF-8",
        (__bridge NSString *)kQLPreviewPropertyMIMETypeKey:@"text/html"
    };
    
    NSString* html = [RSQuickLookZIP htmlForZIP:(__bridge NSURL *)url];
    
    QLPreviewRequestSetDataRepresentation(preview, (CFDataRef)CFBridgingRetain([html dataUsingEncoding:NSUTF8StringEncoding]), kUTTypeHTML, (CFDictionaryRef)CFBridgingRetain(props));
    
    return noErr;
    
    
    
    
    
    
    
    
    
    
    CGSize maxSize = CGSizeMake(RS_WIDTH, RS_HEIGHT);
    float _scale = maxSize.height / RS_HEIGHT;
    NSSize _scaleSize = NSMakeSize(_scale, _scale);
    CGSize _thumbSize = NSSizeToCGSize((CGSize) { maxSize.width * (RS_WIDTH/RS_HEIGHT), maxSize.height});
    
    WebView* _webView = [RSQuickLookZIP quicklookWebViewForZIP:(__bridge NSURL *)url forSize:_scaleSize];
    if ( nil != _webView ) {
        //_thumbSize = [_webView frame].size;
        
        // Draw the webview in the correct context
        CGContextRef _context = QLPreviewRequestCreateContext(preview, _thumbSize, false, NULL);
		if (_context) {
			NSGraphicsContext* _graphicsContext = [NSGraphicsContext graphicsContextWithGraphicsPort:(void *)_context flipped:_webView.isFlipped];
			[_webView displayRectIgnoringOpacity:_webView.bounds inContext:_graphicsContext];
            QLPreviewRequestFlushContext(preview, _context);
			CFRelease(_context);
		}
        NSLog( @"QLZip: 7" );
    }
    
    return noErr;
}

void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview)
{
    // Implement only if supported
}
