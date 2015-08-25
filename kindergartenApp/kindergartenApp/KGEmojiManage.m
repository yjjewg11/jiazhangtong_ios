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
#define key_RightBracket @"]"
#define key_LeftBracket  @"["

@implementation KGEmojiManage


+ (KGEmojiManage *)sharedManage {
    static KGEmojiManage *_sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedService = [[KGEmojiManage alloc] init];
    });
    
    return _sharedService;
}


- (NSMutableDictionary *)emojiMDict {
    if(!_emojiMDict) {
        _emojiMDict = [[NSMutableDictionary alloc] init];
    }
    return _emojiMDict;
}

- (NSMutableDictionary *)emojiInfoMDict {
    if(!_emojiInfoMDict) {
        _emojiInfoMDict = [[NSMutableDictionary alloc] init];
    }
    return _emojiInfoMDict;
}


//在子线程中同步下载表情
- (void)downloadEmoji:(NSArray *)emojiArray {
    
    _emojiArray = emojiArray;
    
    for(EmojiDomain * domain in emojiArray) {
        [self downloadFileURL:domain];
        [self.emojiInfoMDict setObject:domain.descriptionUrl forKey:domain.emojiName];
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


//键盘回退
- (NSString *)keyboardBack:(NSString *)inputString {
    NSString *string = nil;
    NSInteger stringLength = inputString.length;
    if (stringLength > Number_Zero) {
        if ([key_RightBracket isEqualToString:[inputString substringFromIndex:stringLength-Number_One]]) {
            if ([inputString rangeOfString:key_LeftBracket].location == NSNotFound){
                string = [inputString substringToIndex:stringLength];
            } else {
                NSRange range = [inputString rangeOfString:key_LeftBracket options:NSBackwardsSearch];
                NSString * str = [inputString substringFromIndex:range.location];
                if([self judgeEmojiExist:str]) {
                    string = [inputString substringToIndex:range.location];
                }else {
                    string = inputString;
                }
            }
        } else {
            string = [inputString substringToIndex:stringLength];
        }
    }
    
    return string;
}

//判断指定字符串是否是表情
- (BOOL)judgeEmojiExist:(NSString *)str {
    BOOL judge = NO;
    for(NSString * tempStr in self.emojiMDict.allKeys) {
        if([str isEqualToString:tempStr]) {
            judge = YES; break;
        }
    }
    return judge;
}

//替换表情为html
- (NSString *)textConventHTMLText:(NSString *)text {
    if (text.length > Number_Zero) {
        NSRange right = [text rangeOfString:key_RightBracket options:NSBackwardsSearch];
        NSRange left  = [text rangeOfString:key_LeftBracket options:NSBackwardsSearch];
        NSRange rang = NSMakeRange(left.location, right.location - left.location + Number_One);
        if(left.length>Number_Zero && right.length>Number_Zero) {
            NSString * emojiNameStr = [text substringWithRange:rang];
            NSString * htmlStr = [self getEmojiHTML:emojiNameStr];
            if(htmlStr) {
                text = [text stringByReplacingOccurrencesOfString:emojiNameStr withString:htmlStr];
                return [self textConventHTMLText:text];
            }
        }
    }
    return text;
}

- (NSString *)getEmojiHTML:(NSString *)key {
    NSString * url = [self.emojiInfoMDict objectForKey:key];;
    if(url) {
        key = [[key stringByReplacingOccurrencesOfString:key_RightBracket withString:String_DefValue_Empty] stringByReplacingOccurrencesOfString:key_LeftBracket withString:String_DefValue_Empty];
        return [NSString stringWithFormat:@"<img alt=\"%@\" src=\"%@\" />", key, url];
    }
    return String_DefValue_Empty;
}


@end
