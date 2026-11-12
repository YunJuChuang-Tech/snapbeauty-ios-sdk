// snapbeauty iOS SDK public interface (Objective-C; imported as Swift module `SnapBeauty`).
// Not thread-safe: use one engine from one queue.
#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>
#import <Metal/Metal.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSErrorDomain const SnapBeautyErrorDomain;
/// Native engine status codes (xm_status), separate from LicenseStatus.code.
FOUNDATION_EXPORT NSErrorDomain const SnapBeautyEngineErrorDomain;

typedef NS_ENUM(NSInteger, SnapBeautyLicenseCode) {
    SnapBeautyLicenseValid=0, SnapBeautyLicenseGrace, SnapBeautyLicenseMissing,
    SnapBeautyLicenseMalformed, SnapBeautyLicenseUnknownKey, SnapBeautyLicenseBadSignature,
    SnapBeautyLicenseAppMismatch, SnapBeautyLicenseNotYetValid, SnapBeautyLicenseExpired,
    SnapBeautyLicenseClockRollback, SnapBeautyLicenseVersionMismatch, SnapBeautyLicenseLeaseRequired,
    SnapBeautyLicenseStorageError, SnapBeautyLicenseIdentityError,
    SnapBeautyLicenseCertificateInvalid, SnapBeautyLicenseLeaseInvalid, SnapBeautyLicenseLeaseExpired,
    SnapBeautyLicenseOfflineGrace, SnapBeautyLicenseRevoked, SnapBeautyLicenseCacheRollback
};

NS_SWIFT_NAME(LicenseStatus)
@interface SnapBeautyLicenseStatus : NSObject
@property (nonatomic, readonly) SnapBeautyLicenseCode code;
@property (nonatomic, readonly) int64_t expiresAt; // Unix seconds
@property (nonatomic, readonly) uint32_t featureBits; // beauty=1, makeup=2, multiface=4
@property (nonatomic, readonly, copy) NSSet<NSString *> *features;
@property (nonatomic, readonly, copy) NSString *licenseId;
@property (nonatomic, readonly) int64_t revision;
@property (nonatomic, readonly, copy) NSString *network;
@property (nonatomic, readonly) BOOL usable;
- (instancetype)init NS_UNAVAILABLE;
@end

/// Process-wide offline authorization. Call before constructing engines; call again to renew.
@interface SnapBeauty : NSObject
+ (SnapBeautyLicenseStatus *)initializeWithLicense:(NSString *)license NS_SWIFT_NAME(initialize(license:));
+ (SnapBeautyLicenseStatus *)licenseStatus;
/// Main-queue callback once per authorization error transition; nil removes it.
/// Unusable authorization leaves input pixels unchanged and applies no effects.
+ (void)setLicenseErrorHandler:(nullable void (^)(SnapBeautyLicenseStatus *status))handler NS_SWIFT_NAME(setLicenseErrorHandler(_:));
/// Renews now (e.g. network restored / foreground), skipping failure backoff. Never blocks.
+ (void)refreshLeaseAsync;
+ (void)refreshLicenseAsync;
@end

/// Skin parameters. 0 turns an effect off; `smoothing` ranges 0-6, the others 0-1.
NS_SWIFT_NAME(SkinParams)
@interface SnapBeautySkinParams : NSObject <NSCopying>
@property (nonatomic) float smoothing; // 磨皮，0–6
@property (nonatomic) float brightening; // 美白
@property (nonatomic) float rosiness; // 红润
@property (nonatomic) float sharpness; // 锐化
@property (nonatomic) float texture; // 清晰
@property (nonatomic) float blemishRemoval; // 祛斑痘
@property (nonatomic) float eyeBrightening; // 亮眼
@property (nonatomic) float teethWhitening; // 美牙
@property (nonatomic) float undereyeBags; // 去黑眼圈
@property (nonatomic) float smileLines; // 去法令纹
@property (nonatomic) float faceContour; // 五官立体
@end

/// Face shape parameters, 0-1. Bidirectional ones are neutral at 0.5, the rest at 0.
NS_SWIFT_NAME(FaceParams)
@interface SnapBeautyFaceParams : NSObject <NSCopying>
@property (nonatomic) float faceSlimming; // neutral 0
@property (nonatomic) float faceVTaper; // neutral 0
@property (nonatomic) float faceNarrowing; // neutral 0
@property (nonatomic) float faceShortening; // neutral 0
@property (nonatomic) float faceShrinking; // neutral 0
@property (nonatomic) float cheekboneWidth; // neutral 0
@property (nonatomic) float jawWidth; // neutral 0
@property (nonatomic) float eyeScale; // neutral 0
@property (nonatomic) float eyeRoundness; // neutral 0
@property (nonatomic) float chinLength; // neutral 0.5
@property (nonatomic) float foreheadHeight; // neutral 0.5
@property (nonatomic) float noseWidth; // neutral 0
@property (nonatomic) float mouthSize; // neutral 0.5
@property (nonatomic) float lipFullness; // neutral 0.5
@property (nonatomic) float eyePosition; // neutral 0.5
@property (nonatomic) float eyeCornerOpening; // neutral 0
@property (nonatomic) float eyelidFold; // neutral 0
@property (nonatomic) float eyeDistance; // neutral 0.5
@property (nonatomic) float eyeTilt; // neutral 0.5
@property (nonatomic) float noseLength; // neutral 0.5
@property (nonatomic) float philtrumLength; // neutral 0.5
@property (nonatomic) float mouthCorners; // neutral 0
@property (nonatomic) float browPosition; // neutral 0.5
@property (nonatomic) float browDistance; // neutral 0.5
@property (nonatomic) float browThickness; // neutral 0.5
@end

/// Immutable caller-owned snapshot. RGBA8, tightly packed, row zero is the image top.
NS_SWIFT_NAME(RgbaImage)
@interface SnapBeautyRgbaImage : NSObject
@property (nonatomic, readonly) NSInteger width;
@property (nonatomic, readonly) NSInteger height;
@property (nonatomic, readonly, copy) NSData *data;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_SWIFT_NAME(SnapBeautyEngine)
@interface SnapBeautyEngine : NSObject

/// SDK version, e.g. "1.0.0".
@property (class, nonatomic, readonly) NSString *version;
+ (BOOL)isSupported;

/// Number of faces found in the last processed frame.
@property (nonatomic, readonly) NSInteger faceCount;
@property (nonatomic, readonly) BOOL faceDetected;
@property (nonatomic, readonly, copy) NSString *detectDelegate;
@property (nonatomic) BOOL debugLipFull;
@property (nonatomic) BOOL debugCaptureLipInput;

/// Maximum tracked faces, clamped to 1-4, default 1; requires multiface authorization.
/// Parameter setters take effect on the next frame.
@property (nonatomic) NSInteger maxFaces;
/// Adaptive frame cost budget in milliseconds, default 1000/30; 0 disables adaptation.
@property (nonatomic) float frameBudgetMs;
/// Face cap used for the last frame (at most maxFaces).
@property (nonatomic, readonly) NSInteger activeFaceLimit;
/// Last engine frame and tracking cost in milliseconds.
@property (nonatomic, readonly) float lastCostMs;
@property (nonatomic, readonly) float lastDetectMs;

/// Clears tracking and temporal smoothing. Serialize with process on the same queue.
- (void)resetSmoothing NS_SWIFT_NAME(resetSmoothing());
/// Stops the session and clears frame diagnostics; parameters are retained for reuse.
/// Objective-C uses close because NSObject's release is reserved by ARC.
- (void)close NS_SWIFT_NAME(release());
/// Original view and unusable authorization both preserve the input without effects or marks.
- (void)setShowOriginal:(BOOL)value;

/// The Metal device the engine renders with.
@property (nonatomic, readonly) id<MTLDevice> device;

/// Skin parameters; take effect on the next frame.
@property (nonatomic, copy) SnapBeautySkinParams *skin;

/// Face shape parameters; take effect on the next frame.
@property (nonatomic, copy) SnapBeautyFaceParams *face;

/// @param assetsPath  directory of the SDK's `Assets` folder (copied into the app bundle).
/// @param shadersPath directory of the SDK's `Shaders` folder (manifest.json + snapbeauty.metallib).
- (nullable instancetype)initWithAssetsPath:(NSString *)assetsPath
                                shadersPath:(NSString *)shadersPath
                                      error:(NSError **)error NS_DESIGNATED_INITIALIZER;

/// Convenience: `resourcesPath` contains both `Assets` and `Shaders` subfolders.
- (nullable instancetype)initWithResourcesPath:(NSString *)resourcesPath error:(NSError **)error;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// Sets the filter; nil or @"origin" turns it off. `strength` is 0-1.
- (void)setFilter:(nullable NSString *)filterId strength:(float)strength NS_SWIFT_NAME(setFilter(_:strength:));

/// Sets the makeup; nil removes it. `strength` is 0-1.
- (void)setMakeup:(nullable NSString *)makeupId strength:(float)strength NS_SWIFT_NAME(setMakeup(_:strength:));

/// Processes one BGRA camera frame and returns a BGRA texture (CPU-readable, shared storage).
/// @param timestamp   frame timestamp in nanoseconds (frames with the same timestamp reuse tracking).
/// @param showOriginal return the unprocessed input instead of the effect.
- (nullable id<MTLTexture>)processPixelBuffer:(CVPixelBufferRef)pixelBuffer
                                  frontCamera:(BOOL)frontCamera
                                    timestamp:(int64_t)timestamp
                                 showOriginal:(BOOL)showOriginal
                                        error:(NSError **)error
    NS_SWIFT_NAME(process(pixelBuffer:frontCamera:timestamp:showOriginal:));

/// Host camera/RTC bytes, upright tightly packed RGBA8, no mirror, dimensions 1-4096.
/// Nanosecond timestamps are nonnegative and monotonic. Output bytes are owned snapshots.
- (nullable SnapBeautyRgbaImage *)processRgba:(NSData *)data width:(NSInteger)width height:(NSInteger)height
                                timestampNs:(int64_t)timestamp error:(NSError **)error
    NS_SWIFT_NAME(processRgba(_:width:height:timestampNs:));
- (nullable SnapBeautyRgbaImage *)captureFrame:(NSError **)error NS_SWIFT_NAME(captureFrame());
- (nullable SnapBeautyRgbaImage *)captureTexture:(id<MTLTexture>)texture error:(NSError **)error NS_SWIFT_NAME(captureTexture(_:));
- (nullable SnapBeautyRgbaImage *)captureLipMask:(NSError **)error NS_SWIFT_NAME(captureLipMask());
- (nullable SnapBeautyRgbaImage *)captureLipInput:(NSError **)error NS_SWIFT_NAME(captureLipInput());
- (nullable NSString *)captureLipDebugJson NS_SWIFT_NAME(captureLipDebugJson());

@end

NS_ASSUME_NONNULL_END
