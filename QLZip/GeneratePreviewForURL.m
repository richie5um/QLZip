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
    
    // RichS: Cleverly, we can cheat and display everything as HTML :-)
    NSDictionary *props = @{
        (__bridge NSString *)kQLPreviewPropertyTextEncodingNameKey:@"UTF-8",
        (__bridge NSString *)kQLPreviewPropertyMIMETypeKey:@"text/html"
    };
    
    NSString* html = [RSQuickLookZIP htmlForZIP:(__bridge NSURL *)url];
    
    // RichS: Need to, at some point, validate that the briding casts are correct and not leaking memory.
    QLPreviewRequestSetDataRepresentation(preview, (CFDataRef)CFBridgingRetain([html dataUsingEncoding:NSUTF8StringEncoding]), kUTTypeHTML, (CFDictionaryRef)CFBridgingRetain(props));
    
    return noErr;
}

void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview)
{
    // Implement only if supported
}
