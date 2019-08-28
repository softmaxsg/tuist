import Basic
import Foundation
import XcodeProj

public enum SDKStatus {
    case required
    case optional
}

public enum Dependency: Equatable {
    public enum PackageType: Equatable {
        case remote(url: String, productName: String, versionRequirement: VersionRequirement)
        case local(path: RelativePath)
    }
    
    public enum VersionRequirement: Equatable {
        case upToNextMajorVersion(String)
        case upToNextMinorVersion(String)
        case range(from: String, to: String)
        case exact(String)
        case branch(String)
        case revision(String)

        var xcodeprojValue: XCRemoteSwiftPackageReference.VersionRequirement {
            switch self {
            case let .branch(branch):
                return .branch(branch)
            case let .exact(version):
                return .exact(version)
            case let .range(from, to):
                return .range(from: from, to: to)
            case let .revision(revision):
                return .revision(revision)
            case let .upToNextMinorVersion(version):
                return .upToNextMinorVersion(version)
            case let .upToNextMajorVersion(version):
                return .upToNextMajorVersion(version)
            }
        }
    }

    case target(name: String)
    case project(target: String, path: RelativePath)
    case framework(path: RelativePath)
    case library(path: RelativePath, publicHeaders: RelativePath, swiftModuleMap: RelativePath?)
    case package(PackageType)
    case sdk(name: String, status: SDKStatus)
    case cocoapods(path: RelativePath)
}
