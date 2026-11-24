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
    .package(url: "https://github.com/stackotter/libjpegturbo", from: "0.1.4"),
    .package(url: "https://github.com/the-swift-collective/libwebp", from: "1.4.2"),
    .package(url: "https://github.com/the-swift-collective/zlib", from: "1.3.3"),
  ],
  targets: [
    .target(
      name: "TIFF",
      dependencies: [
        .product(name: "LZMA2", package: "MetaLZMA2"),
        .product(name: "ZStandard", package: "MetaZStandard"),
        .product(name: "JPEGTurbo", package: "libjpegturbo"),
        .product(name: "WebP", package: "libwebp"),
        .product(name: "ZLib", package: "zlib"),
      ],
      exclude: tiffExclude,
      publicHeadersPath: "include",
      cxxSettings: [
        // libjpeg-turbo builds every precision, so tif_jpeg.c is the 8 bit codec and tif_jpeg_12.c the 12 bit one
        .define("HAVE_JPEGTURBO_DUAL_MODE_8_12", to: "1"),
        .define("_ALLOW_COMPILER_AND_STL_VERSION_MISMATCH", .when(platforms: [.windows])),
        .define("_ALLOW_KEYWORD_MACROS", to: "1", .when(platforms: [.windows])),
        .define("static_assert(_conditional, ...)", to: "", .when(platforms: [.windows])),
      ]
    ),
  ],
  cLanguageStandard: .gnu17,
  cxxLanguageStandard: .cxx17
)
