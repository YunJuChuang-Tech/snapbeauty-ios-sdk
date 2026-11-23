// swift-tools-version:5.9
import PackageDescription
let package = Package(
    name: "SnapBeautyDistribution",
    platforms: [.iOS(.v15)],
    products: [.library(name: "SnapBeautySDK", targets: ["SnapBeauty", "SnapBeautyResources"]), .library(name: "SnapBeautyGPU", targets: ["SnapBeautyGPU"])],
    targets: [
        .binaryTarget(name: "SnapBeauty", path: "Artifacts/SnapBeauty.xcframework"),
        .binaryTarget(name: "SnapBeautyGPU", path: "Artifacts/SnapBeautyGPU.xcframework"),
        .target(name: "SnapBeautyResources", dependencies: ["SnapBeauty"], resources: [.copy("Resources/Assets"), .copy("Resources/Shaders"), .copy("Resources/ShadersSimulator")], linkerSettings: [.linkedLibrary("c++"), .linkedLibrary("z"), .linkedFramework("Metal"), .linkedFramework("CoreVideo"), .linkedFramework("ImageIO"), .linkedFramework("CoreGraphics")])
    ]
)
