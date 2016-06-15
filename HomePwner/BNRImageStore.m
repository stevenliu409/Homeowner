//
//  BNRImageStore.m
//  HomePwner
//
//  Created by Steven Liu on 2016-06-15.
//  Copyright © 2016 Steven Liu. All rights reserved.
//

#import "BNRImageStore.h"

@interface BNRImageStore ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation BNRImageStore


+ (instancetype)sharedStore
{
    static BNRImageStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}

- (instancetype)initPrivate
{
    if (self = [super init]) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (instancetype)init
{
    [NSException raise:@"singleton"
                format:@"Use +[BNRImageStore sharedStore"];
    return nil;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    [self.dictionary setObject:image forKey:key];
}

- (UIImage *)imageForKey:(NSString *)key
{
    return [self.dictionary objectForKey:key];
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return ;
    }
    [self.dictionary removeObjectForKey:key];
}

@end
