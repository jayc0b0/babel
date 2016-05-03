# babel: a library for all

![Version number](https://img.shields.io/badge/Version-Pre--Release-blue.svg)

## About

Babel is a webapp, built in Rails, and essentially like the offspring of Plex (In its ability to be a repository of media
for the consumption of any with access to the server) and Libgen (In its ability to be an easily searchable database of books).
Currently, development is still incredibly early, but I wanted to start a repo with a readme as a means of keeping track of what
needs to be done.

As of now, this looks as follows:

More timely development info can be found [here](https://oasis.sandstorm.io/shared/TfyswbVN0sr_Wo1NZ5gC37g3dkXpi_rDin_0H8oLP6F).
If you would like to contribute to the board or make a request, please open an issue or pull request or send an email to me at
JaOrner@gmail.com

**Base functionality**
* Initial database schema
  * Book Table
    * Title
    * Author
    * Year Published
    * Publisher
    * Genre Tags
    * Tags
    * Filename
    * Path
    * Extension
  * User Table (To be added later)
    * Username
    * Email
    * Etc...

* Basic Database Functions
  * Adding files from directory
  * Searching by tag or field
  * Fetching file from database

## Usage / Contributing

Most of Babel is still pretty early in development, but if you'd like to help out, you've just got to do these three things:

1. Clone this repository
2. Run 'bundle install' to get the gems all set up
3. Create a folder in the project root directory called 'books' and put your files in there.
4. Get an ISBNDB API key and put it in config/isbndb.yml as detailed [here](https://github.com/sethvargo/isbndb#basic-setup)
(I don't want to share my API key for obvious security reasons. Also, I don't want you mooching. :p)
