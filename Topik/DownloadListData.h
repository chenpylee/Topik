//
//  DownloadListData.h
//  Topik
//
//  Created by Lee Haining on 13-12-1.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadListData : NSObject
@property(nonatomic,strong)NSMutableArray *lectureArray;
@property(nonatomic,strong)NSMutableDictionary *lectureDictionary;
@property(nonatomic,strong)NSMutableDictionary *videoLectureDictionary;
@end
