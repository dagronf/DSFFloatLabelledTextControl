// swift-tools-version: 5.4

import PackageDescription

let package = Package(
	name: "DSFFloatLabelledTextField",
	platforms: [
		.macOS(.v10_11)
	],
	products: [
		.library(
			name: "DSFFloatLabelledTextField",
			targets: ["DSFFloatLabelledTextField"]
		),
	],
	targets: [
		.target(
			name: "DSFFloatLabelledTextField",
			dependencies: []
		)
	],
	swiftLanguageVersions: [.v5]
)
