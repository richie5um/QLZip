//
//  RSQuickLookZIP.m
//  QLZip
//
//  Created by RichS on 7/14/14.
//  Copyright (c) 2014 RichS. All rights reserved.
//

#import "RSQuickLookZIP.h"
#import <zipzap/zipzap.h>
#import "RSGlobals.h"

@implementation RSQuickLookZIP

+(NSString*)htmlForZIP:(NSURL*)url {
    ZZArchive* archive = [ZZArchive archiveWithContentsOfURL:url];
    if ( nil != archive ) {
        NSMutableString* content = [NSMutableString stringWithString:@"<table class=\"example-table\"><tr><th>Filename</th><th>Compressed Size</th><th>Uncompressed Size</th></tr>"];
        for ( ZZArchiveEntry *entry in archive.entries ) {
            NSString* details = [NSString stringWithFormat:@"<tr><td>%@</td><td>%lu</td><td>%lu</td></tr>", entry.fileName, entry.compressedSize, (unsigned long)entry.uncompressedSize];
            [content appendString:details];
        }
        [content appendString:@"</table>"];
        
        // Render the output to a webview
        NSString* style = [NSString stringWithFormat:@"<style> \
                           .example-table { \
                           font-family: sans-serif; \
                           -webkit-font-smoothing: antialiased; \
                           display: block; \
                           } \
                           .example-table th { \
                           background-color: rgb(112, 196, 105); \
                           font-weight: normal; \
                           color: white; \
                           padding: 5px 10px; \
                           text-align: center; \
                           } \
                           .example-table td { \
                           background-color: rgb(238, 238, 238); \
                           padding: 5px 10px; \
                           color: rgb(111, 111, 111); \
                           }</style>"];
        NSString* html = [NSString stringWithFormat:@"<html>%@<body>%@</body></html>", style, content];
        return html;
    }
    
    return @"";
}

@end
