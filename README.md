# pub_dev_browser_lib

A Flutter library for browsing project documentation from
[pub.dev](https://pub.dev).

![](demo.gif)

This library is primarily designed to be used in the
[pub_dev_browser](example/pub_dev_browser) application but includes reusable
widgets and components. It provides full-text search with various filters using
the [pub_api_client](https://pub.dev/packages/pub_api_client) library and fuzzy
matching package name search using the
[fuzzywuzzy](https://pub.dev/packages/fuzzywuzzy) and
[flutter_typeahead](https://pub.dev/packages/flutter_typeahead) packages. The
[flutter_markdown](https://pub.dev/packages/flutter_markdown) package is used to
render `README.md` files from GitHub repositories.

## Features

- **BLoC Architecture**: Utilizes the BLoC pattern for managing state and
  business logic, ensuring a clear separation of concerns and making the
  codebase more maintainable and testable.
- **Type-Safe Routing**: Implements routing using the
  [go_router_builder](https://pub.dev/packages/go_router_builder) package.
- **Search Screen**: Implements a search screen with text-highlighting for
  full-text search queries. It supports configurable tags and sorting orders,
  and includes a fuzzy matching package name search feature.
- **Paginated Search Results**: Provides a paginated search results screen where
  queries can be progressively built using tappable elements of results such as
  topics, platforms, SDKs, and publishers.
- **Package Details Page**: Features a comprehensive package details page that
  includes:
  - Human-readable duration since the last update
  - Publisher information
  - Supported SDKs and platforms
  - Scores for Pub Points, Likes, and Popularity
  - Tappable dependencies that navigate directly to the package
  - Rendered `README.md` files from GitHub repositories

## Getting Started

To explore all the functionalities provided by this library, run the
[pub_dev_browser](example/pub_dev_browser) (`example/pub_dev_browser`) Flutter
application. This application integrates all the features mentioned above into a
single browser for [pub.dev](https://pub.dev).

## Usage

Clone the repository:

```sh
git clone https://github.com/tyler-conrad/pub_dev_browser_lib.git
```

Get the dependencies, and build the library:

```sh
cd pub_dev_browser_lib
flutter pub get
flutter pub run build_runner build
```

Navigate to the example application directory:

```sh
cd example/pub_dev_browser
```

Run the application on your desired device:

```sh
dart run -d <device>
```

Replace `<device>` with the device ID. For example, to run on macOS:

```sh
dart run -d macos
```

## Additional information

For more detailed information on how to use and extend this library, refer to
the [documentation](https://tyler-conrad.github.io/doc/pub_dev_browser_lib). If
you encounter any issues or have suggestions for improvements, feel free to open
an issue or submit a pull request on the GitHub repository.

## Tested On

- macOS Sequoia 15.1
- Flutter 3.24.4 • channel stable • https://github.com/flutter/flutter.git
- Framework • revision 603104015d (3 weeks ago) • 2024-10-24 08:01:25 -0700
- Engine • revision db49896cf2
- Tools • Dart 3.5.4 • DevTools 2.37.3