# Sinatra Dashboard

This project intents to be a playground for building a web app with sinatra.

## Usage

To run the app you need either ruby (v 3.1) or docker installed.

If you want to run the app with docker you can use the following command:

```bash
docker build -t sin:test . && docker run -p 9393:9393 -p 9292:9292 sin:test
```

Then you will have:

* prometheus metrics exposed on port 9393
* app exposed on port 9292

For running it directly you can either use `make` or bundler directly:

```bash
# For using make
make install
make run

# For using bundler
bundler install
bundler exec puma -C config/puma.rb
```
