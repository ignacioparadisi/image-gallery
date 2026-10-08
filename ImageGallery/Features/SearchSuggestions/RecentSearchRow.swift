import SwiftUI

struct RecentSearchRow: View {
    let search: RecentSearch

    var body: some View {
        HStack(spacing: 12) {
            RemoteImage(url: search.thumbnailURL)
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            Text(search.query)
                .foregroundStyle(.primary)
        }
    }
}
