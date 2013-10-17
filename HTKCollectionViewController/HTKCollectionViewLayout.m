//
//  HTKCollectionViewLayout.m
//  HTKCollectionViewController
//
//  Created by Triệu Khang on 16/10/13.
//  Copyright (c) 2013 Triệu Khang. All rights reserved.
//

#import "HTKCollectionViewLayout.h"

@interface HTKCollectionViewLayout()

@property (strong, nonatomic) NSMutableDictionary *layoutInfo;

@end

@implementation HTKCollectionViewLayout

- (CGFloat)heightOfCollectionView
{
    return self.collectionView.frame.size.height;
}

- (CGFloat)widthOfCollectionView
{
    return self.collectionView.frame.size.width;
}

- (void)prepareLayout
{
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    for (NSInteger section = 0; section < sectionCount; section++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < itemCount; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = [self frameForItemAtIndexPath:indexPath];
            cellLayoutInfo[indexPath] = itemAttributes;
        }
        
    }
    
    newLayoutInfo[@"itemCell"] = cellLayoutInfo;
    
    self.layoutInfo = newLayoutInfo;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier,
                                                         NSDictionary *elementsInfo,
                                                         BOOL *stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                          UICollectionViewLayoutAttributes *attributes,
                                                          BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [allAttributes addObject:attributes];
            }
        }];
    }];
    
    return allAttributes;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(10 * [self widthOfCollectionView],
                      self.collectionView.numberOfSections * [self heightOfCollectionView]);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[@"itemCell"][indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat originX = indexPath.row * [self widthOfCollectionView];
    CGFloat originY = indexPath.section * [self heightOfCollectionView];
    
    return CGRectMake(originX, originY, [self widthOfCollectionView], [self heightOfCollectionView]);
}


- (CGRect)getFrameOfIndexPath:(NSIndexPath *)indexPath
{
    NSInteger x = indexPath.row *  [self widthOfCollectionView];
    NSInteger y = indexPath.section * [self heightOfCollectionView];
    
    return CGRectMake(x, y,  [self widthOfCollectionView], [self heightOfCollectionView]);
}

- (NSIndexPath *)indexPathWithPoint:(CGPoint)point
{
    NSInteger row = point.x /  [self widthOfCollectionView];
    NSInteger section = point.y / [self heightOfCollectionView];
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

@end
