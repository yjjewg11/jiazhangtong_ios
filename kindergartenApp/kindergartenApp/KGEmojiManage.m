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


- (NSMutableArray *)emojiNameArray {
    if(!_emojiNameArray) {
        _emojiNameArray = [[NSMutableArray alloc] init];
    }
    return _emojiNameArray;
}


//在子线程中同步下载表情
- (void)downloadEmoji:(NSArray *)emojiArray {
    
    _emojiArray = emojiArray;
    
    NSInteger index = Number_One;
    for(EmojiDomain * domain in emojiArray) {
        [self downloadFileURL:domain.descriptionUrl
                     savePath:KGEmojiPath
                     fileName:[NSString stringWithFormat:@"[%@]", domain.datavalue]
                          tag:index];
        index++;
    }
}


/**
 * 下载文件
 */
- (void)downloadFileURL:(NSString *)aUrl savePath:(NSString *)aSavePath fileName:(NSString *)aFileName tag:(NSInteger)aTag
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //检查本地文件是否已存在
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.png", aSavePath, aFileName];
    
    //检查附件是否存在
    if ([fileManager fileExistsAtPath:fileName]) {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        NSData *audioData = [NSData dataWithContentsOfFile:fileName];
        [dic setObject:audioData forKey:key_Result];
        [dic setObject:aFileName forKey:key_FileName];
//        [self requestFinished:dic tag:aTag];
        [self requestFinished:aUrl name:aFileName];
    }else{
        //创建附件存储目录
        if (![fileManager fileExistsAtPath:aSavePath]) {
            [fileManager createDirectoryAtPath:aSavePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        //下载附件
        NSURL *url = [[NSURL alloc] initWithString:aUrl];
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
            
            NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
            NSData *audioData = [NSData dataWithContentsOfFile:fileName];
            [dic setObject:audioData forKey:key_Result];
            [dic setObject:aFileName forKey:key_FileName];
//            [self requestFinished:dic tag:aTag];
            [self requestFinished:aUrl name:aFileName];
            NSLog(@"requestFinished:%@====%@", url, fileName);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            //下载失败
            [self requestFailed:aUrl name:fileName];
        }];
        
        [operation start];
    }
}


- (void)requestFinished:(NSString *)url name:(NSString *)name {
    [self.emojiNameArray addObject:name];
}

- (void)requestFailed:(NSString *)url name:(NSString *)name {
    NSLog(@"requestFailed:%@====%@", url, name);
}

@end
