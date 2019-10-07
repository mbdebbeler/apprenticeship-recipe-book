[![Build Status](https://travis-ci.org/mbdebbeler/apprenticeship-recipe-book.svg?branch=master)](https://travis-ci.org/mbdebbeler/apprenticeship-recipe-book)

## Description

A recipe app for the command line that takes a text file and returns a grocery list.

### Installation
Download or clone this repository with the green "clone or download" button at the top of this page.

This project was built in Elixir and uses mix to start the game and run the accompanying test suite. To run this application you'll first need to install Elixir (which comes with mix) from [this page here](https://elixir-lang.org/install.html "Install Elixir"). Once installed you can run the commands detailed below from the project's root directory.

### Testing
Navigate to this project's directory and run the following mix command: `mix test`

### Starting the Game
Run the following mix command to build an executable of the app: `mix escript.build`

Then run this command to open and use the app: `./recipe_book`
