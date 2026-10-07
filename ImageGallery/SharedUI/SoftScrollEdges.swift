//
//  SoftScrollEdges.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import SwiftUI

struct SoftScrollEdges: ViewModifier {
    let edges: Edge.Set
    
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .scrollEdgeEffectStyle(.soft, for: edges)
        } else {
            content
        }
    }
}

extension View {
    @ViewBuilder
    func softScrollEdges(_ edges: Edge.Set) -> some View {
        self
            .modifier(SoftScrollEdges(edges: edges))
    }
}
