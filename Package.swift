// swift-tools-version:5.9
import PackageDescription
let package = Package(
    name: "SnapBeautyDistribution",
    platforms: [.iOS(.v15)],
    products: [.library(name: "SnapBeautySDK", targets: ["SnapBeauty", "SnapBeautyResources"])],
    targets: [
        .binaryTarget(name: "SnapBeauty", path: "Artifacts/SnapBeauty.xcframework"),
        .target(name: "SnapBeautyResources", resources: [.copy("Resources/Assets"), .copy("Resources/Shaders"), .copy("Resources/ShadersSimulator")], linkerSettings: [.linkedLibrary("c++"), .linkedLibrary("z"), .linkedFramework("Metal"), .linkedFramework("CoreVideo"), .linkedFramework("ImageIO"), .linkedFramework("CoreGraphics")])
    ]
)
