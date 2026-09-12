// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MisakiSwift",
  platforms: [
    .iOS(.v18), .macOS(.v15)
  ],
  products: [
    .library(
      name: "MisakiSwift",
      targets: ["MisakiSwift"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/ml-explore/mlx-swift", from: "0.30.2"),
    .package(url: "https://github.com/mlalma/MLXUtilsLibrary.git", exact: "0.0.6")
  ],
  targets: [
    .target(
      name: "MisakiSwift",
      dependencies: [
        .product(name: "MLX", package: "mlx-swift"),
        .product(name: "MLXNN", package: "mlx-swift"),
        .product(name: "MLXUtilsLibrary", package: "MLXUtilsLibrary")
     ],
     resources: [
       // The eight FILES, flat — not the folder. Copying a folder named
       // `Resources` puts `Resources/` at the bundle's root, and the iOS
       // Simulator's ad-hoc code signing rejects that layout ("bundle format
       // unrecognized"). A device build never signs the bare bundle, so it
       // passed there and failed in every consuming app's simulator build.
       .copy("../../Resources/gb_bart.safetensors"),
       .copy("../../Resources/gb_bart_config.json"),
       .copy("../../Resources/gb_gold.json"),
       .copy("../../Resources/gb_silver.json"),
       .copy("../../Resources/us_bart.safetensors"),
       .copy("../../Resources/us_bart_config.json"),
       .copy("../../Resources/us_gold.json"),
       .copy("../../Resources/us_silver.json")
     ]
    ),
    .testTarget(
      name: "MisakiSwiftTests",
      dependencies: ["MisakiSwift"]
    ),
  ]
)
