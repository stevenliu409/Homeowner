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
    if (self = [super init])
    {
        _dictionary = [[NSMutableDictionary alloc] init];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(clearCache:)
                   name:UIApplicationDidReceiveMemoryWarningNotification
                 object:nil];
    }
    return self;
}

- (instancetype)init
{
    [NSException raise:@"singleton"
                format:@"Use +[BNRImageStore sharedStore"];
    return nil;
}

- (NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:key];
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    self.dictionary[key] = image;
    
    NSString *imagePath = [self imagePathForKey:key];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    // Images are saved to the file system right away because it takes to long to save an image during the transition to background state
    [imageData writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)key
{
    UIImage *result = self.dictionary[key];
 
    // if image is not in the dictionary find it in the file system
    if (!result)
    {
        NSString *imagePath = [self imagePathForKey:key];
        result = [UIImage imageWithContentsOfFile:imagePath];
        
        // if result is in the file system save it to the dictionary
        if (result)
        {
            self.dictionary[key] = result;
        }
        else
        {
            NSLog(@"Error: unable to find %@", imagePath);
        }
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key)
    {
        return;
    }
    [self.dictionary removeObjectForKey:key];
    
    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath
                                               error:nil];
}

- (void)clearCache:(NSNotificationCenter *)nc
{
    NSLog(@"flushing %lu images out of the cache", (unsigned long) [self.dictionary count]);
    [self.dictionary removeAllObjects];
}

@end
