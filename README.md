# NASA's Astronomy Picture of the Day (APOD)

Project for Flutter experiments and learning 🔬👨‍💻🚧

It uses NASA's [APOD API](https://api.nasa.gov/) to fetch the Astronomy Picture of the Day and its
past entries.

### Instructions

1. Get an API key from [Nasa's API](https://api.nasa.gov/) and update the `config/local.env` file
   with the key.
2. Get dependencies and generate `*.g.dart` files

    ```bash
    flutter pub get
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
