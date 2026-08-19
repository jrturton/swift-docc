/*
 This source file is part of the Swift.org open source project

 Copyright (c) 2026 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
 See https://swift.org/CONTRIBUTORS.txt for Swift project authors
*/

import SymbolKit

extension [[PlatformName?]: SymbolGraph.Symbol.DeclarationFragments] {
    /// The declaration fragments for the group with the highest priority platform.
    func mainRenderFragments() -> SymbolGraph.Symbol.DeclarationFragments? {
        self.min(by: { lhs, rhs in
            PlatformName.isInOrder(
                lhs.key.compactMap { $0 }.min()?.rawValue,
                rhs.key.compactMap { $0 }.min()?.rawValue
            )
        })?.value
    }

    func renderDeclarationTokens() -> [DeclarationRenderSection.Token]? {
        mainRenderFragments()?.declarationFragments.renderDeclarationTokens()
    }
    
    /// The declarations sorted by platform priority, with the list of platforms per declaration also sorted by priority.
    func sortedByPlatformPriority() -> [(platforms: Self.Key, declaration: Self.Value)] {
        map { platforms, declaration in
            let sortedPlatforms = platforms
                .sorted { PlatformName.isInOrder($0?.rawValue, $1?.rawValue) }
            return (sortedPlatforms, declaration)
        }.sorted {
            PlatformName.isInOrder($0.platforms.first??.rawValue, $1.platforms.first??.rawValue)
        }
    }
}

extension [SymbolGraph.Symbol.DeclarationFragments.Fragment] {
    func renderDeclarationTokens() -> [DeclarationRenderSection.Token] {
        map { .init(fragment: $0, identifier: nil) }
    }
}

extension SymbolGraph.Symbol.DeclarationFragments {
    /// The declaration fragments represented as text
    func spelling() -> String {
        declarationFragments.map { $0.spelling }.joined()
    }
}
