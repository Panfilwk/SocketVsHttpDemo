#! /bin/bash

echo "Building Elm pages..."
elm make client.elm

echo "Launching Tornado server..."
../.env/bin/python server.py

echo "Cleaning up..."
rm index.html