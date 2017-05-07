//
//  FavoriteViewController.m
//  Dai-Hentai
//
//  Created by DaidoujiChen on 2017/5/7.
//  Copyright © 2017年 DaidoujiChen. All rights reserved.
//

#import "FavoriteViewController.h"
#import "PrivateListViewController.h"
#import "FilesManager.h"

@interface FavoriteViewController ()

@end

@implementation FavoriteViewController

#pragma mark - Method to Override

#define pageCout 40

- (void)fetchGalleries {
    if ([self.pageLocker tryLock]) {
        NSInteger index = self.pageIndex * pageCout;
        NSArray *hentaiInfos = [Couchbase sortFrom:CouchbaseStoreTypeFavorite start:index length:pageCout];
        if (hentaiInfos && hentaiInfos.count) {
            [self.galleries addObjectsFromArray:hentaiInfos];
            [self.collectionView reloadData];
            self.pageIndex++;
            self.isEndOfGalleries = hentaiInfos.count < 40;
        }
        else {
            self.isEndOfGalleries = YES;
        }
        [self.pageLocker unlock];
    }
}

- (void)showMessageTo:(MessageCell *)cell onLoading:(BOOL)isLoading {
    cell.activityView.hidden = YES;
    cell.messageLabel.text = @"你還沒有加入任何最愛呦 O3O";
}

- (void)onCellBeSelectedAction:(HentaiInfo *)info {
    [self performSegueWithIdentifier:@"PushToGallery" sender:info];
}

- (void)initValues {
    [super initValues];
}

#pragma mark - IBAction

- (IBAction)refreshAction:(id)sender {
    if (self.galleries.count) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    }
    [self reloadGalleries];
}

@end
