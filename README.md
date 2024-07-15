# Reddit Clone

A Flutter-based Reddit clone application that demonstrates key features of the popular social media platform.

## Features

- User authentication (Login/Register)
- Create, read, update, and delete posts
- Comment on posts and reply to comments
- Upvote and downvote posts and comments
- User profiles
- Awards system
- Video playback support

## Getting Started

### Prerequisites

- Flutter SDK (Channel stable, 3.10.0 or later)
- Dart SDK (2.19.0 or later)

### Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/mahmoudhs1998/reddit-clone.git
    ```
2. Navigate to the project directory:
    ```sh
    cd reddit-clone
    ```
3. Install dependencies:
    ```sh
    flutter pub get
    ```
4. Run the app:
    ```sh
    flutter run
    ```

## Dependencies

- [get](https://pub.dev/packages/get): State management and navigation
- [shared_preferences](https://pub.dev/packages/shared_preferences): Local data storage
- [timeago](https://pub.dev/packages/timeago): Human-readable time formatting
- [chewie](https://pub.dev/packages/chewie): Video player UI
- [video_player](https://pub.dev/packages/video_player): Video playback

## Architecture

This project follows a simple MVC (Model-View-Controller) architecture using the GetX package:

- **Models**: Represent the data structures (User, Post, Comment)
- **Views**: UI components and screens
- **Controllers**: Handle business logic and state management

## Contributing
## License

This project is open source and available under the [MIT License](LICENSE).
Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the [MIT License](LICENSE)
