// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Wayfinder",
	platforms: [.iOS(.v26)],
	products: PackageProduct.allCases.map(\.description),
	dependencies: ExternalDependency.allCases.map(\.packageDependency),
	targets: InternalTarget.allCases.map(\.target)
)

// MARK: - Package Products
private enum PackageProduct: CaseIterable {
	case Wayfinder

	var name: String { "Wayfinder" }
	var targets: [String] { InternalTarget.allCases.map(\.title) }
	var description: PackageDescription.Product { .library(name: name, targets: targets) }
}

// MARK: - Internal Targets
/// To add a new internal target:
/// 1. Add a new case to `InternalTarget`.
/// 2. Implement `title` and `dependencies`.
/// 3. Add any resources or build settings as needed.
private enum InternalTarget: CaseIterable {
	case navigation
	case demo
	case interface
	case models

	var targetDependency: Target.Dependency { .target(name: title) }
	var target: Target { .target(name: title, dependencies: dependencies) }

	var title: String {
		switch self {
		case .navigation: "Navigation"
		case .demo: "Demo"
		case .interface: "Interface"
		case .models: "Models"
		}
	}

	var dependencies: [Target.Dependency] {
		switch self {
		case .navigation: []
		case .demo: targetDependencies(.target(.interface), .target(.models))
		case .interface: targetDependencies(.target(.models), .target(.navigation))
		case .models: []
		}
	}
}

// MARK: - External Dependencies
/// To add a new external dependency:
/// 1. Add a new case to `ExternalDependency`.
/// 2. Provide the URL and branch/version.
/// 3. Define `targetDependency` for import.
private enum ExternalDependency: CaseIterable {
	case routing

	var packageDependency: Package.Dependency {
		switch self {
		case .routing: .package(url: "git@github.com:olijujuangreen/Routing.git", branch: "main")
		}
	}

	var targetDependency: Target.Dependency {
		switch self {
		case .routing: .product(name: "Routing", package: "Routing")
		}
	}
}

// MARK: - DependencyType Helper
private enum DependencyType {
	case target(InternalTarget)
	case package(ExternalDependency)
}

/// Maps dependency declarations to SwiftPM `Target.Dependency` values.
private func targetDependencies(_ dependencies: DependencyType...) -> [Target.Dependency] {
	dependencies.map { type in
		switch type {
		case .target(let target): .target(name: target.title)
		case .package(let package): package.targetDependency
		}
	}
}
