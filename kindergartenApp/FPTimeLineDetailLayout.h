//
//  FPTimeLineDetailLayout.h
//  kindergartenApp
//
//  Created by Mac on 16/2/18.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FPTimeLineDetailLayoutDelegate <NSObject>

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout cellCenteredAtIndexPath:(NSIndexPath *)indexPath page:(int)page;

@end


@interface FPTimeLineDetailLayout : UICollectionViewFlowLayout

@property (weak, nonatomic) id<FPTimeLineDetailLayoutDelegate> delegate;

@end
