//
//  SearchView.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var router: Router
    @StateObject private var viewModel: SearchViewModel

    init(viewModel: SearchViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        PhotoGridView(
            viewModel: viewModel,
            hiddenPhotoID: router.presentedPhoto?.id,
            onSelect: router.showPhoto
        )
        .navigationTitle(viewModel.query)
        .navigationBarTitleDisplayMode(.inline)
        .softScrollEdges(.top)
        .onAppear {
            viewModel.loadFirstPageIfNeeded()
        }
    }
}

