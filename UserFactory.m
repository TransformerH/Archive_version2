////
////  UserFactory.m
////  ChatDemo
////
////  Created by 韩雪滢 on 8/31/16.
////  Copyright © 2016 韩雪滢. All rights reserved.
////
//
//#import "UserFactory.h"
//@interface CDUser :NSObject<CDUserModelDelegate>
//
//@property (nonatomic,strong)NSString *userId;
//@property (nonatomic,strong)NSString *username;
//@property (nonatomic,strong)NSString *avatarUrl;
//
//@end
//
//@implementation CDUser
//
//@end
//
//@implementation UserFactory
//
//
//#pragma mark - UserDelegate
//
//- (void)cacheUserByIds:(NSSet *)userIds block:(AVIMBooleanResultBlock)block{
//    block(YES,nil);
//}
//
//- (id<CDUserModelDelegate>)getUserById:(NSString *)userId{
//    CDUser *user = [[CDUser alloc] init];
//    user.userId = userId;
//    user.username = [NSString stringWithFormat:@"%@",userId];
//    user.avatarUrl = @"http://d.hiphotos.baidu.com/exp/w=200/sign=ed98b3e3ba014a90813e41bd99763971/63d0f703918fa0ecfb75685c259759ee3d6ddb35.jpg";
//
//    return user;
//}
//
//@end
