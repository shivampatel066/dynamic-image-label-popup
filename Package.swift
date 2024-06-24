// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.


import PackageDescription

let package = Package(
    name: "dynamicImageHeightLabelPopup",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "dynamicImageHeightLabelPopup",
            targets: ["dynamicImageHeightLabelPopup"]),
    ],
    targets: [
        .target(
            name: "dynamicImageHeightLabelPopup",
            dependencies: [],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "dynamicImageHeightLabelPopupTests",
            dependencies: ["dynamicImageHeightLabelPopup"]),
    ]
)
