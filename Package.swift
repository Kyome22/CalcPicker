// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CalcPicker",
    platforms: [
      .iOS(.v17),
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
            swiftSettings: [.enableUpcomingFeature("ExistentialAny")]
        ),
        .testTarget(
            name: "CalcPickerTests",
            dependencies: ["CalcPicker"],
            swiftSettings: [.enableUpcomingFeature("ExistentialAny")]
        ),
    ]
)
