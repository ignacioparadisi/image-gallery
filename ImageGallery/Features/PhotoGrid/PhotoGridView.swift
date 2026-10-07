//
//  GalleryGridView.swift
//  ImageGallery
//
//  Created by Ignacio Paradisi on 10/6/26.
//

import SwiftUI

struct PhotoGridView: View, Equatable {
    @ObservedObject var viewModel: PhotoGridViewModel
    var hiddenPhotoID: Photo.ID?
    let onSelect: (Photo, CGRect) -> Void
    private let column = GridItem(.adaptive(minimum: 130), spacing: 2)

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.viewModel === rhs.viewModel && lhs.hiddenPhotoID == rhs.hiddenPhotoID
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [column], spacing: 2) {
                ForEach(viewModel.photos) { photo in
                    PhotoGridCell(url: photo.thumbnailURL, description: photo.description)
                        .opacity(photo.id == hiddenPhotoID ? 0 : 1)
                        .overlay {
                            GeometryReader { proxy in
                                Color.clear
                                    .contentShape(.rect)
                                    .onTapGesture {
                                        onSelect(photo, proxy.frame(in: .global))
                                    }
                            }
                        }
                        .accessibilityAddTraits(.isButton)
                        .onAppear {
                            viewModel.loadNextPageIfNeeded(currentPhoto: photo)
                        }
                }
            }
            
            if viewModel.phaseStyle == .footer {
                footer
            }
        }
        .overlay {
            if viewModel.phaseStyle == .fullScreen {
                overlay
            }
        }
        .animation(.default, value: viewModel.phase)
    }
    
    @ViewBuilder
    private var overlay: some View {
        switch viewModel.phase {
        case .empty:
            Text(Localization.PhotoGrid.emptyResults)
                .foregroundStyle(.secondary)
        case .loading:
            ProgressView()
        case .failure(let error):
            ErrorView(error: error) {
                viewModel.retry()
            }
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var footer: some View {
        switch viewModel.phase {
        case .loading:
            ProgressView()
        case .failure(let error):
            ShortErrorView(error: error) {
                viewModel.retry()
            }
        default:
            EmptyView()
        }
    }
}
