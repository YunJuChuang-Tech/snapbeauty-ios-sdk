import Foundation
import SnapBeauty

public enum SnapBeautyResources {
    public static var assets: URL { Bundle.module.bundleURL.appendingPathComponent("Assets", isDirectory: true) }
    public static var shaders: URL {
        #if targetEnvironment(simulator)
        return Bundle.module.bundleURL.appendingPathComponent("ShadersSimulator", isDirectory: true)
        #else
        return Bundle.module.bundleURL.appendingPathComponent("Shaders", isDirectory: true)
        #endif
    }

    /// Creates an engine with the bundled resources, or the provided combined Assets directory.
    public static func makeEngine(assets: URL? = nil) throws -> SnapBeautyEngine {
        try SnapBeautyEngine(assetsPath: (assets ?? self.assets).path, shadersPath: shaders.path)
    }
}
