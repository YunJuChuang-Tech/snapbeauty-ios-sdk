// SnapBeauty optional Metal GPU inference dependency (Objective-C; imported as Swift module `SnapBeautyGPU`).
// Linking and embedding `SnapBeautyGPU.xcframework` (or SwiftPM product `SnapBeautyGPU`) automatically
// enables full-precision TFLite Metal GPU landmark inference in `SnapBeautyEngine` without code changes.
// Omit this dependency to keep the default lean XNNPACK CPU runtime.
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

__attribute__((visibility("default")))
@interface SnapBeautyGPU : NSObject
/// Plugin version matching `SnapBeautyEngine.version`.
@property (class, nonatomic, readonly) NSString *version;
/// YES when the GPU inference plugin is loaded and a system Metal device is available.
@property (class, nonatomic, readonly) BOOL isSupported;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
