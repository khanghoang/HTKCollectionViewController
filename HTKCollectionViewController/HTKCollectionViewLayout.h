//
//  HTKCollectionViewLayout.h
//  HTKCollectionViewController
//
//  Created by Triệu Khang on 16/10/13.
//  Copyright (c) 2013 Triệu Khang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTKCollectionViewLayout : UICollectionViewLayout

- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath;
+ (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath;

@end


