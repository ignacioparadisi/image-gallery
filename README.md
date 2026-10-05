# Setup

This project uses the [Unsplash API](https://unsplash.com/developers) which needs an access key to be able to use it.

1. Create an account in [Unsplash API](https://unsplash.com/developers)
2. Create an application to have the access key.
3. Duplicate the `Template.xccofing` under `ImageGallery/App/Configuration`.
4. Rename this copy to `Environment.xcconfig`
5. Set `UNSPLASH_ACCESS_KEY` to your own access key.

# Architecture

# Image Caching

- AsyncImage doesn't cache images before iOS 27.
- Using CGImage for the loader to work in any platform
- Using an actor for safe concurrent access

# Networking

- nonisolated is used because by default every class/struct runs in the Main Actor. Using a class by another actor would force us to use `await`. nonisolated makes it possible to use the class from other actors because is no longer isolated by the main actor.
