#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>

// RichS: Added Imports
#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "RSQuickLookZIP.h"
#import "RSGlobals.h"

OSStatus GenerateThumbnailForURL(void *thisInterface, QLThumbnailRequestRef thumbnail, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options, CGSize maxSize);
void CancelThumbnailGeneration(void *thisInterface, QLThumbnailRequestRef thumbnail);

/* -----------------------------------------------------------------------------
    Generate a thumbnail for file

   This function's job is to create thumbnail for designated file as fast as possible
   ----------------------------------------------------------------------------- */

OSStatus GenerateThumbnailForURL(void *thisInterface, QLThumbnailRequestRef thumbnail, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options, CGSize maxSize)
{
    return noErr;
    
    float _scale = maxSize.height / RS_HEIGHT;
    NSSize _scaleSize = NSMakeSize(_scale, _scale);
    CGSize _thumbSize = NSSizeToCGSize((CGSize) { maxSize.width * (RS_WIDTH/RS_HEIGHT), maxSize.height});
    
    WebView* _webView = [RSQuickLookZIP quicklookWebViewForZIP:(__bridge NSURL *)url forSize:_scaleSize];
    if ( nil != _webView ) {
        // Draw the webview in the correct context
		CGContextRef _context = QLThumbnailRequestCreateContext(thumbnail, _thumbSize, false, NULL);
		if (_context) {
			NSGraphicsContext* _graphicsContext = [NSGraphicsContext graphicsContextWithGraphicsPort:(void *)_context flipped:_webView.isFlipped];
			[_webView displayRectIgnoringOpacity:_webView.bounds inContext:_graphicsContext];
			QLThumbnailRequestFlushContext(thumbnail, _context);
			CFRelease(_context);
		}
    }
    
    return noErr;
}

void CancelThumbnailGeneration(void *thisInterface, QLThumbnailRequestRef thumbnail)
{
    // Implement only if supported
}