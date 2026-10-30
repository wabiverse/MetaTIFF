// swift-tools-version: 5.10
import PackageDescription

var tiffExclude = ["mkg3states.c"]
#if !os(Windows)
  tiffExclude += ["tif_win32.c"]
#endif
#if os(Windows)
  tiffExclude += ["tif_unix.c"]
#endif

let package = Package(
  name: "MetaTIFF",
  platforms: [
    .macOS(.v14),
    .visionOS(.v1),
    .iOS(.v17),
    .tvOS(.v17),
    .watchOS(.v10),
  ],
  products: [
    .library(
      name: "TIFF",
      type: .dynamic,
      targets: ["TIFF"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/wabiverse/MetaLZMA2.git", from: "1.0.0"),
    .package(url: "https://github.com/wabiverse/MetaZStandard.git", from: "1.0.0"),
    .package(url: "https://github.com/wabiverse/MetaTurboJPEG.git", from: "1.0.0"),
    .package(url: "https://github.com/the-swift-collective/libwebp", from: "1.4.1"),
    .package(url: "https://github.com/the-swift-collective/zlib", from: "1.3.1"),
  ],
  targets: [
    .target(
      name: "TIFF",
      dependencies: [
        .product(name: "LZMA2", package: "MetaLZMA2"),
        .product(name: "ZStandard", package: "MetaZStandard"),
        .product(name: "TurboJPEG", package: "MetaTurboJPEG"),
        .product(name: "WebP", package: "libwebp"),
        .product(name: "ZLib", package: "zlib"),
      ],
      exclude: tiffExclude,
      publicHeadersPath: "include",
      cxxSettings: [
        .define("FROM_TIF_JPEG_12", to: "1"),
        .define("HAVE_JPEGTURBO_DUAL_MODE_8_12", to: "1"),
        .define("BITS_IN_JSAMPLE", to: "12"),
        .define("_ALLOW_COMPILER_AND_STL_VERSION_MISMATCH", .when(platforms: [.windows])),
        .define("_ALLOW_KEYWORD_MACROS", to: "1", .when(platforms: [.windows])),
        .define("static_assert(_conditional, ...)", to: "", .when(platforms: [.windows])),
      ]
    ),
  ],
  cLanguageStandard: .gnu17,
  cxxLanguageStandard: .cxx17
)
