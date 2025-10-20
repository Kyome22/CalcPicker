// swift-tools-version: 6.1

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ExistentialAny"),
]

let package = Package(
    name: "CalcPicker",
    platforms: [
      .iOS(.v18),
      .macOS(.v15),
    ],
    products: [
        .library(
            name: "CalcPicker",
            targets: ["CalcPicker"]
        ),
    ],
    targets: [
        .target(
            name: "CalcPicker",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "CalcPickerTests",
            dependencies: ["CalcPicker"],
            swiftSettings: swiftSettings
        ),
    ]
)
