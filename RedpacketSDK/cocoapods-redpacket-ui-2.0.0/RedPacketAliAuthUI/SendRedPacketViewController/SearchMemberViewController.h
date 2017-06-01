//
//  SearchMemberViewController.h
//  RedpacketLib
//
//  Created by Mr.Yan on 16/6/5.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RPRefreshTableViewController.h"
#import "RPRedpacketModel.h"

@protocol SearchMemberViewDelegate <NSObject>
@optional
- (void)receiverInfos:(NSArray<RPUserInfo *>*)userInfos;
- (void)getGroupMemberListCompletionHandle:(void (^)(NSArray<RPUserInfo *> * groupMemberList))completionHandle;

@end

@interface SearchMemberViewController : RPRefreshTableViewController

@property (nonatomic, weak) id<SearchMemberViewDelegate> delegate;

@end
