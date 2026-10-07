# Image Gallery

A SwiftUI app that shows the [Unsplash](https://unsplash.com) feed in a grid, lets you search for photos, and opens each one full screen with a custom transition. My main goal was keeping it smooth while scrolling through hundreds of images.

## Features

- Infinite feed (`GET /photos`)
- Search, with your last 10 searches shown as suggestions
- Full-screen photo detail that grows out of the grid (tap or drag down to close)
- Loading, empty and error states, with retry
- Images cached in memory and on disk

## Requirements

- Xcode 27
- iOS 16.0 or later
- An Unsplash access key

## Setup

1. Create an account at [unsplash.com/developers](https://unsplash.com/developers), create a new application and copy its **Access Key**.
2. In `ImageGallery/App/Configuration/`, duplicate `Template.xcconfig` and rename the copy to `Environment.xcconfig`.
3. Replace `put_your_access_key` with your key:
   ```
   UNSPLASH_ACCESS_KEY = your_access_key_here
   ```

`Environment.xcconfig` is in `.gitignore`, so the key never gets committed. The project won't build until that file exists, so make sure to do step 2 before running it. If the key is empty, the app shows these instructions instead of the feed.

Keep in mind that Unsplash demo apps are limited to 50 requests per hour. Loading images doesn't count, but feed pages and searches do.

## Architecture

I went with MVVM and split the code into layers, where each one only knows about the layers below it:

- `Feature` knows about `Domain`, plus `NetworkError` (to show the right error message) and the image loader from `Networking`
- `Data` knows about `Domain` and `Networking`

| Folder           | What's in it                                                                                                     |
| ---------------- | ---------------------------------------------------------------------------------------------------------------- |
| `App`            | App entry point, `AppDependencies`, `Router` and configuration                                                   |
| `Domain`         | `Photo`, `Page`, `RecentSearch`, the LRU logic (`RecentSearches`), repository protocols                          |
| `Data`           | `PhotosRepositoryImpl`, `UserDefaultsRecentSearchesRepository`, DTO mapping                                      |
| `Networking`     | `HTTPClient`, `HTTPSession`, `NetworkError`, `ImageLoader`, and the Unsplash endpoints and DTOs in `UnsplashAPI` |
| `Features`       | Feed, Search, PhotoGrid, PhotoDetail                                                                             |
| `SharedUI`       | Reusable views and helpers (`RemoteImage`, `ErrorView`, `BackButton`…)                                           |
| `PreviewContent` | Sample data for SwiftUI previews (debug only)                                                                    |

## Technical choices

### SwiftUI on iOS 16

iOS 16 was the minimum required, so I couldn't use `@Observable` (iOS 17) and used `ObservableObject` instead. Newer APIs only appear behind `#available` checks, like the Liquid Glass back button and soft scroll edges on iOS 26.

### One grid ViewModel for the feed and search

The feed and search results behave the same way: a grid that loads more pages as you scroll. So all of that lives in `PhotoGridViewModel`: loading the next page before you reach the end, not loading the same page twice, removing duplicate photos, knowing when there are no more pages, retrying, and the loading, empty and error states.

`FeedViewModel` and `SearchViewModel` subclass it and only say where the pages come from by overriding `loadPage`. I chose subclassing over composition because on iOS 16 each screen can observe a single `ObservableObject`. If the feed ViewModel contained a separate grid ViewModel, views would have to observe both, and that's easy to get wrong.

### Dependency injection

Everything is passed through initializers. `AppDependencies` creates the HTTP client, the repositories and the image loader once at launch. ViewModels only know about repository protocols, which is what makes them easy to test with mocks.

The image loader is the one exception. It goes through the SwiftUI environment, because it's only used for displaying images, and views deep in the hierarchy need it.

### Networking

I wrote a small HTTP client instead of using a library, since the app only makes a couple of GET requests:

- Each request is described by an `Endpoint` that also defines the type the response decodes into.
- The client depends on an `HTTPSession` protocol rather than `URLSession` directly, so in tests I can return any response I want.
- Every failure becomes a `NetworkError`, so the UI can tell you're offline, rate limited or unauthorized instead of showing a generic error. Cancelled requests aren't treated as errors at all.
- Decoding runs off the main actor with `@concurrent`.

### Pagination

Pages have 30 photos, and the next one starts loading when one of the last 10 cells appears, so you rarely see the loading indicator. For the feed I get the total from Unsplash's `X-Total` header, and search returns it in the body.

`/photos` is a live feed, so if new photos are published while you scroll, the same photo can show up on two pages. I filter those out so the grid never has duplicate IDs.

### Image pipeline

I didn't use `AsyncImage` because it doesn't keep decoded images around, doesn't share identical requests, and its default disk cache is too small for photos. This is how an image gets to a cell:

1. `RemoteImage` first checks the memory cache synchronously. If the image is there, it's shown in the same frame.
2. If not, it asks `ImageLoader`, which checks the memory cache again and, if another cell is already downloading the same image, waits for that download instead of starting a new one.
3. Otherwise the image is requested through a `URLSession` with a 200 MB disk cache, so files downloaded before (even in a previous launch) don't hit the network again.
4. The downloaded data is decoded with ImageIO in the background, stored in the memory cache and returned to the cell.

A few details:

- The grid loads Unsplash's `small` size and the detail loads `regular`. I never download or decode the original files, which can be several thousand pixels wide.
- `ImageLoader` is an actor because the cache and the list of downloads in progress are shared by every cell.
- The memory cache can also be read synchronously, outside the actor. `NSCache` is thread-safe, and it means scrolling back to images you've already seen shows them right away instead of flashing a placeholder.
- Failed downloads aren't cached, so a cell tries again the next time it appears.
- The memory cache is limited by how much memory the decoded images use, not by how many there are.

### Navigation

A `Router` owns the `NavigationStack` path and the photo that's being shown. Views just ask it to navigate or open a photo, and the router doesn't care which screen asked. That made the photo detail work the same way from the feed and from search results.

### Photo detail transition

I wanted the photo to grow out of the cell you tapped. The iOS 18 zoom transition does something similar, but it doesn't exist on iOS 16 and I didn't like how it looked, so I built my own.

The detail is a `fullScreenCover` shown without animation. Inside it, the photo starts at the cell's frame and animates to full screen. Closing it runs the same animation in reverse. I went with a full-screen modal rather than a push because that's how photo viewers usually behave, and it covers the navigation bar and the search field.

### Search and recent searches

You search from the feed. When you submit, the results open in a new screen titled with what you searched for. I search on submit instead of while typing because of the 50-requests-per-hour limit. Even with a debounce you could have unnecessary requests.

Recent searches show up as suggestions in the search field. Each one is saved when you submit it, and it gets the first result's thumbnail the first time it returns results. I keep the last 10: searching for something again moves it to the top, and when there are more than 10, the one used least recently is dropped. Since it's just 10 short entries, I store them in `UserDefaults` behind a `RecentSearchesRepository` protocol.

### Configuration

The access key lives in an `.xcconfig` file that isn't committed and reaches the app through `Info.plist`. `Template.xcconfig` shows what needs to be filled in.

### Offline behavior

Images already downloaded stay in the disk cache and are used without asking the network again. When the network fails, you get a specific message (offline, couldn't connect, and so on) with a retry button.

### Tests

I used Swift Testing, with mocks for the network session and the repositories. The tests cover:

- the endpoints' URLs
- the HTTP client: the authorization header, status codes, network and decoding errors
- reading response headers
- the memory cost of a cached image
- the repositories, including pagination from headers and persisting recent searches
- the recent searches rules (order, limit of 10, duplicates)
- the ViewModels: pagination and recent searches

## Performance

### What keeps scrolling smooth

- `LazyVGrid` only creates cells as they come on screen.
- Images are downloaded at a size close to the one they're shown at (`small` in the grid, `regular` in the detail) and decoded off the main thread.
- Decoded images are cached in memory, files on disk, and the same image is never downloaded twice at the same time.
- The next page is requested before you reach the end of the grid.
- Grid cells only receive simple values (a URL and a description), so SwiftUI can skip cells whose data didn't change.
- Typing in the search field doesn't redraw the grid. The search text lives in the view, not in the ViewModel the grid observes.
- The grid is `Equatable` and ignores its tap closure, so it isn't redrawn just because the screen that contains it was.
- A cell lets go of its image when it disappears, to use less memory while scrolling. When it appears again, the image comes back from the cache.

### Profiling with Instruments

Measured on iPhone 15 Pro Max (iOS 27.0.1), Release build, scrolling the feed through about 200 photos.

#### Allocations

**Results**
Scrolling the feed for 45 seconds, memory rose while the first images loaded and then stayed flat at about 160 MiB. About 130 MiB of that is decoded images kept in the memory cache (200 images, around 0.6 MiB each), and the cache keeps releasing older images as you scroll.

<img src="https://raw.githubusercontent.com/ignacioparadisi/image-gallery/refs/heads/main/images/allocations.png" alt="Allocations Instrument Results" />

#### Time Profiler

**Results**
Image decoding and JSON parsing run on background threads; the main thread is mostly SwiftUI layout and rendering. The thermal state stayed nominal while scrolling.

<img src="https://raw.githubusercontent.com/ignacioparadisi/image-gallery/refs/heads/main/images/time-profiler.png" alt="Time Profile Instrument Results" />

#### Animation Hitches

**Results**
In a 34-second run that included scrolling, opening photos and searching, there were 5 hitches. Four were one or two frames (8–12 ms on a 120 Hz display). The longest, 67 ms, happened when the keyboard appeared for the first time after tapping the search field, which is iOS loading the keyboard rather than the app's own work.

<img src="https://raw.githubusercontent.com/ignacioparadisi/image-gallery/refs/heads/main/images/animation-hitches.png" alt="Animation Hitches Instrument Results" />

#### SwiftUI

**Results**
With the SwiftUI instrument, over 40 seconds of scrolling, opening photos and searching, only 3 updates from the app's own views took longer than usual, each about 0.5 ms. Most of the longer updates (111) were the lazy grid's layout while scrolling, under 3 ms each.

<img src="https://raw.githubusercontent.com/ignacioparadisi/image-gallery/refs/heads/main/images/swiftui-instrument-1.png" alt="SwiftUI Instrument Results 1" />
<img src="https://raw.githubusercontent.com/ignacioparadisi/image-gallery/refs/heads/main/images/swiftui-instrument-2.png" alt="SwiftUI Instrument Results 2" />

## Trade-offs

- **Subclassing the grid ViewModel.** Swift has no abstract methods, so if a subclass forgets to override `loadPage`, it crashes at run time instead of failing to compile. With two subclasses and tests, I was fine with that.
- **The custom transition.** Swiping back isn't interactive. Closing relies on a fixed delay, because waiting for an animation to finish (`withAnimation(completion:)`) needs iOS 17. And on iOS 16.0–16.3 the cover can't have a transparent background.
- **`UserDefaults` for recent searches.** Simple and plenty for 10 entries. If I needed a long history, or to sync it, I'd use CoreData (SwiftData is simpler but it's not supported in iOS 16).
- **Saving thumbnail URLs instead of images.** Keeps storage tiny and reuses the image cache, but if the cache is cleared, thumbnails have to download again.
- **Searching on submit.** Saves requests with the hourly limit, but you don't see results as you type.
- **The access key ships inside the app.** Like any client-side key, it can be extracted. A real app would send requests through its own backend.
- **`nonisolated` on Networking.** The app target is main-actor isolated by default, so networking types opt out one by one. Moving networking into its own Swift package would avoid that.

## What I'd improve with more time

- Prefetch images for photos just below the screen, and cancel downloads no cell needs anymore.
- Save the last loaded feed pages in CoreData so the app works offline.
- Show an alert when the hourly rate limit is reached, and use `X-Ratelimit-Remaining` to warn before it happens.
- Use each photo's BlurHash or dominant color as a placeholder while it loads.
- Interactive drag-to-dismiss, pinch to zoom, and handling rotation in the photo detail.
- Move to `@Observable`, `scrollPosition` and animation completion handlers if the minimum version went up to iOS 17.
- Move networking into a local Swift package.
- More tests: how `ImageLoader` shares downloads, DTO mapping, and UI tests for the main flows.
- Pull to refresh on the feed.
- Add Accessibility with full VoiceOver and Dynamic Type support.
