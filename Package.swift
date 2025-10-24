// swift-tools-version: 6.2
import PackageDescription

let package = Package(
	name: "Wayfinder",
	platforms: [.iOS(.v26)],
	products: PackageProduct.allCases.map(\.description),
	dependencies: ExternalDependency.allCases.map(\.packageDependency),
	targets: [InternalTarget.allCases.map(\.target)].flatMap { $0 }
)

// MARK: - Package Products
private enum PackageProduct: CaseIterable {
	case Wayfinder

	var name: String { "Wayfinder" }
	var targets: [String] { InternalTarget.allCases.map(\.title) }

	var description: PackageDescription.Product {
		.library(name: name, targets: targets)
	}
}

// MARK: - Internal Targets
private enum InternalTarget: CaseIterable {
	case navigation
	case demo
	case interface
	case models

	var targetDependency: Target.Dependency { .target(name: title) }

	var target: Target {
		.target(name: title, dependencies: dependencies)
	}

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
		case .navigation:
			[] // standalone map/navigation logic

		case .models:
			[] // pure model types, no dependencies

		case .interface:
			// Interface connects to both core layers
			targetDependencies(.target(.models), .target(.navigation))

		case .demo:
			// Demo depends on interface (which depends on models + navigation)
			targetDependencies(.target(.interface))
		}
	}
}

// MARK: - External Dependencies
private enum ExternalDependency: CaseIterable {
	case routing

	var packageDependency: Package.Dependency {
		switch self {
		case .routing:
			.package(url: "git@github.com:olijujuangreen/Routing.git", branch: "main")
		}
	}

	var targetDependency: Target.Dependency {
		switch self {
		case .routing:
			.product(name: "Routing", package: "Routing")
		}
	}
}

// MARK: - DependencyType Helper
private enum DependencyType {
	case target(InternalTarget)
	case package(ExternalDependency)
}

private func targetDependencies(_ dependencies: DependencyType...) -> [Target.Dependency] {
	dependencies.map { dependency in
		switch dependency {
		case .target(let target): .target(name: target.title)
		case .package(let package): package.targetDependency
		}
	}
}
