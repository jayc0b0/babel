# babel: a library for all

Babel is a webapp, built in Rails, and essentially like the offspring of Plex (In its ability to be a repository of media
for the consumption of any with access to the server) and Libgen (In its ability to be an easily searchable database of books).
Currently, development is still incredibly early, but I wanted to start a repo with a readme as a means of keeping track of what
needs to be done.

As of now, this looks as follows:

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
