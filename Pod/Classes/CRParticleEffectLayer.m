//
//  CRParticleEffectLayer.m
//  CRMagicGesture
//
//  Created by Ihor Teltov on 1/31/16.
//  Copyright © 2016 Cleveroad Inc. All rights reserved.
//

#import "CRParticleEffectLayer.h"

NSString * const kCRParticleEffectImageNameHearts   = @"CRParticleEffect.bundle/cr_hearts";
NSString * const kCRParticleEffectImageNameDiamonds = @"CRParticleEffect.bundle/cr_diamonds";
NSString * const kCRParticleEffectImageNameClubs    = @"CRParticleEffect.bundle/cr_clubs";
NSString * const kCRParticleEffectImageNameSpades   = @"CRParticleEffect.bundle/cr_spades";

@implementation CRParticleEffectLayer

#pragma mark - Init

- (instancetype)init
{
    UIImage *defaultImage = [UIImage imageNamed:kCRParticleEffectImageNameHearts];
    if (!defaultImage) {
        defaultImage = [UIImage new];
    }
    return [self initWithImages:@[defaultImage]];
}

- (instancetype)initWithImages:(NSArray<UIImage *> *)images
{
    return [self initWithImages:images emitterCellConfigBlock:nil];
}

- (instancetype)initWithImages:(NSArray<UIImage *> *)images emitterCellConfigBlock:(CREmitterCellConfigBlock)configBlock
{
    self = [super init];
    if (self) {
        _color = [UIColor colorWithRed:1.0 green:0.2 blue:0.1 alpha:0.75];
        
        self.emitterSize = (CGSize){10.0f, 10.0f};
        self.emitterShape = kCAEmitterLayerCircle;
        self.renderMode = kCAEmitterLayerAdditive;
        self.contentsScale = [UIScreen mainScreen].scale;
        self.scale = 1;
        
        NSMutableArray *emitterCells = [NSMutableArray new];
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger index, BOOL * _Nonnull stop) {
            CAEmitterCell *cell = [self createEmitterCellWithImage:image
                                                              name:@(index).stringValue
                                                             color:self.color];
            if (configBlock) {
                configBlock(cell, index);
            }
            [emitterCells addObject:cell];
        }];
        self.emitterCells = emitterCells;
    }
    return self;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _color = [aDecoder decodeObjectForKey:@"color"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.color forKey:@"color"];
}

#pragma - Setup emitter cells

- (void)setColor:(UIColor *)color
{
    _color = color;
    for (CAEmitterCell *emitterCell in self.emitterCells) {
        emitterCell.color = color.CGColor;
    }
}

- (void)setScale:(float)scale
{
    [super setScale:scale / self.contentsScale];
}

- (CAEmitterCell *)createEmitterCellWithImage:(UIImage *)image name:(NSString *)name color:(UIColor *)color
{
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    cell.contents = (id)image.CGImage;
    cell.name = name;
    cell.color = color.CGColor;
    
    cell.birthRate = 50;
    cell.lifetime = 0.5f;
    cell.lifetimeRange = 1.0f;
    
    cell.velocity = 70;
    cell.velocityRange = 20;
    
    cell.emissionLongitude = 0;
    cell.emissionRange = 2 * M_PI;
    
    cell.scale = 0.5f;
    cell.scaleSpeed = 0.25f;
    cell.scaleRange = 0.1f;
    
    CGFloat alpha;
    [color getWhite:NULL alpha:&alpha];
    cell.alphaSpeed = - (cell.lifetime + cell.lifetimeRange) * alpha;
    
    return cell;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:self];
    CRParticleEffectLayer *newParticleEffectLayer = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
    return newParticleEffectLayer;
}

#pragma mark -

- (void)finishAndRemoveFromSuperlayer
{
    if (self.superlayer) {
        self.birthRate = 0;
        float maximumLifetime = 0.0f;
        for (CAEmitterCell *emitterCell in self.emitterCells) {
            float cellLifetime = fmaxf(0, emitterCell.lifetime) + fabsf(emitterCell.lifetimeRange);
            maximumLifetime = fmaxf(maximumLifetime, cellLifetime);
        }
        maximumLifetime *= self.lifetime;
        __weak typeof(self) wself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(maximumLifetime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [wself removeFromSuperlayer];
        });
    }
}

@end
