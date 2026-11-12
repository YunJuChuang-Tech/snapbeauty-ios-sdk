import Foundation
public enum SnapBeautyResources {
    public static var assets: URL { Bundle.module.bundleURL.appendingPathComponent("Assets", isDirectory: true) }
    public static var shaders: URL {
        #if targetEnvironment(simulator)
        return Bundle.module.bundleURL.appendingPathComponent("ShadersSimulator", isDirectory: true)
        #else
        return Bundle.module.bundleURL.appendingPathComponent("Shaders", isDirectory: true)
        #endif
    }
}
