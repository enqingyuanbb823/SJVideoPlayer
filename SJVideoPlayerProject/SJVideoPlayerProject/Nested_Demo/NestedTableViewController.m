//
//  NestedTableViewController.m
//  SJVideoPlayerProject
//
//  Created by 畅三江 on 2018/1/11.
//  Copyright © 2018年 SanJiang. All rights reserved.
//

#import "NestedTableViewController.h"
#import "SJVideoPlayer.h"
#import "NestedTableViewCell.h"
#import "PlayerCollectionViewCell.h"
#import <Masonry.h>


static NSString *const NestedTableViewCellID = @"NestedTableViewCell";

@interface NestedTableViewController ()<NestedTableViewCellDelegate>

@property (nonatomic, strong, readwrite) SJVideoPlayer *videoPlayer;

@end

@implementation NestedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Nested scrollView(嵌套view)";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerClass:NSClassFromString(NestedTableViewCellID) forCellReuseIdentifier:NestedTableViewCellID];
    
    self.tableView.rowHeight = [NestedTableViewCell height];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _videoPlayer.disableRotation = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _videoPlayer.disableRotation = YES;
}

- (void)dealloc {
    [_videoPlayer stop];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 99;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NestedTableViewCell *cell = (NestedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NestedTableViewCellID forIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (void)clickedPlayWithNestedTabCell:(NestedTableViewCell *)tabCell
                                 col:(UICollectionView *)collectionView
                             colCell:(PlayerCollectionViewCell *)colCell {
    
    [self _removeOldPlayer];
    
    [self _createNewPlayerWithPlayerSuperView:colCell.backgroundImageView
                                  assetURLStr:@"http://pu.latin5.com/bd1c831d-7024-4b17-a03e-e8ab89bb2a4b.m3u8" beginTime:0
                                   scrollView:collectionView
                                    indexPath:[collectionView indexPathForCell:colCell]
                                 superviewTag:colCell.backgroundImageView.tag
                                scrollViewTag:collectionView.tag
                             parentScrollView:self.tableView
                              parentIndexPath:[self.tableView indexPathForCell:tabCell]];
    
//    __weak typeof(self) _self = self;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        __strong typeof(_self) self = _self;
//        if ( !self ) return ;
//        [self clickedPlayWithNestedTabCell:tabCell col:collectionView colCell:colCell];
//    });
}

- (void)_removeOldPlayer {
    // clear old player
    SJVideoPlayer *oldPlayer = _videoPlayer;
    if ( !oldPlayer ) { return;}
    
    // fade out
    [oldPlayer stopAndFadeOut];
}

- (void)_createNewPlayerWithPlayerSuperView:(UIView *)playerSuperView
                                assetURLStr:(NSString *)assetURLStr
                                  beginTime:(NSTimeInterval)beginTime
                                 scrollView:(__unsafe_unretained UIScrollView *__nullable)scrollView
                                  indexPath:(__weak NSIndexPath *__nullable)indexPath
                               superviewTag:(NSInteger)superviewTag
                              scrollViewTag:(NSInteger)scrollViewTag
                           parentScrollView:(__unsafe_unretained UIScrollView *__nullable)parentScrollView
                            parentIndexPath:(NSIndexPath *__nullable)parentIndexPath {
    // create new player
    _videoPlayer = [SJVideoPlayer player];
    _videoPlayer.view.alpha = 0.001;
    [playerSuperView addSubview:_videoPlayer.view];
    [_videoPlayer.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    // fade in
    [UIView animateWithDuration:0.5 animations:^{
        _videoPlayer.view.alpha = 1;
    }];
    
    _videoPlayer.asset =
    [[SJVideoPlayerAssetCarrier alloc] initWithAssetURL:[NSURL URLWithString:assetURLStr]
                                              beginTime:0
                                             scrollView:scrollView
                                              indexPath:indexPath
                                           superviewTag:superviewTag
                                          scrollViewTag:scrollViewTag
                                       parentScrollView:parentScrollView
                                        parentIndexPath:parentIndexPath];
    
    _videoPlayer.autoplay = YES;
}

@end

