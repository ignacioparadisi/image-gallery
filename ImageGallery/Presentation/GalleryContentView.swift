//
//  GalleryContentView.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import SwiftUI

struct GalleryContentView: View {
    @ObservedObject var viewModel: GalleryViewModel
    
    private var isSearching: Bool {
        if viewModel.searchViewModel == nil {
            return false
        }
        return true
    }
    
    var body: some View {
        ZStack {
            PhotoGridView(viewModel: viewModel.feedViewModel)
                .opacity(isSearching ? 0 : 1)
            
            if let searchViewModel = viewModel.searchViewModel {
                PhotoGridView(viewModel: searchViewModel)
                    .transition(.move(edge: .bottom))
            }
        }
        .animation(.default, value: viewModel.searchViewModel == nil)
    }
}
