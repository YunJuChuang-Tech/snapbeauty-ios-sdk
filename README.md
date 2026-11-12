# SnapBeauty iOS SDK

SnapBeauty iOS SDK 1.3.0 for Swift Package Manager. iOS 15 or later; arm64 devices and Apple Silicon simulators. Intel simulators are not supported.

## Integration

In Xcode, add this repository as a package dependency and select version 1.3.0. Add the single `SnapBeautySDK` product to the app target. The SDK binary, its models, shaders, and platform-specific Metal library are supplied together by that product.

```swift
import SnapBeauty
import SnapBeautyResources

let status = SnapBeauty.initialize(license: licenseText)
let engine = try SnapBeautyResources.makeEngine()
```

Initialize a valid license before creating an engine. Missing or invalid authorization returns the original image without effects. Use one engine on one queue.

## Host makeup resources

The SDK does not contain makeup textures or lip colors. To use host-owned makeup, provide `makeup/<layer>/<layer>_NN.webp` (layers: `blush`, `eyeshadow`, `eyebrow`) and `makeup/lip/lip_NN.json`. Copy the SDK `Assets` directory to an app-owned writable directory, add the host `makeup` directory alongside `snapbeauty`, and pass it as `SnapBeautyResources.makeEngine(assets: combinedAssetsURL)`. The sample project validates its host-provided files and follows this arrangement. Choose and manage the destination's lifecycle in the app; never modify the signed package resource bundle.

## License

Proprietary; use requires a SnapBeauty SDK license. Third-party components and resources remain subject to their own licenses and attribution requirements. See `NOTICE.md`, `THIRD-PARTY-NOTICES.txt`, and `Licenses/`.
