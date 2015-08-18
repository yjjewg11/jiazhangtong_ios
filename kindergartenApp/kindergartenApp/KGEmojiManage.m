//
//  KGEmojiManage.m
//  kindergartenApp
//
//  Created by You on 15/8/4.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGEmojiManage.h"
#import "AFHTTPRequestOperation.h"
#import "EmojiDomain.h"

#define key_Result    @"result"
#define key_FileName  @"fileName"

@implementation KGEmojiManage


+ (KGEmojiManage *)sharedManage {
    static KGEmojiManage *_sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedService = [[KGEmojiManage alloc] init];
    });
    
    return _sharedService;
}

- (NSMutableString *)chatHTMLInfo {
    if(!_chatHTMLInfo) {
        _chatHTMLInfo = [[NSMutableString alloc] init];
    }
    
    return _chatHTMLInfo;
}

- (NSMutableDictionary *)emojiMDict {
    if(!_emojiMDict) {
        _emojiMDict = [[NSMutableDictionary alloc] init];
    }
    return _emojiMDict;
}


//在子线程中同步下载表情
- (void)downloadEmoji:(NSArray *)emojiArray {
    
    _emojiArray = emojiArray;
    
    for(EmojiDomain * domain in emojiArray) {
        [self downloadFileURL:domain];
    }
}


/**
 * 下载文件
 */
- (void)downloadFileURL:(EmojiDomain *)emojiDomain
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //检查本地文件是否已存在
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.png", KGEmojiPath, emojiDomain.emojiName];
    NSLog(@"fileName:%@", fileName);
    //检查附件是否存在
    if ([fileManager fileExistsAtPath:fileName]) {
        [self.emojiMDict setObject:fileName forKey:emojiDomain.emojiName];
    }else{
        //创建附件存储目录
        if (![fileManager fileExistsAtPath:KGEmojiPath]) {
            [fileManager createDirectoryAtPath:KGEmojiPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        //下载附件
        NSURL *url = [[NSURL alloc] initWithString:emojiDomain.descriptionUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.inputStream   = [NSInputStream inputStreamWithURL:url];
        operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:fileName append:NO];
        
        //下载进度控制
        /*
         [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
         NSLog(@"is download：%f", (float)totalBytesRead/totalBytesExpectedToRead);
         }];
         */
        
        //已完成下载
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [self.emojiMDict setObject:fileName forKey:emojiDomain.emojiName];
            NSLog(@"requestFinished:%@====%@", url, fileName);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            //下载失败
            [self requestFailed:emojiDomain];
        }];
        
        [operation start];
    }
}


- (void)requestFailed:(EmojiDomain *)domain {
    NSLog(@"emoji requestFailed:%@====%@", domain.emojiName, domain.descriptionUrl);
}


- (void)resetChatHTML {
    _chatHTMLInfo = [NSMutableString new];
}

@end
