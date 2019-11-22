# Commit viewer

This is an application which given a git url, returns a paginated list of commits of that repository. It tries to get them first through the github api, and if that does not work, it clones the repo temporarely and obtains the commits from there. 

The **choosen stack** was:

- Ruby 2.6.3
- Rails 6.0.0, initialized in API mode, with no database or ORM.

## How to run

To run the application, please install the Ruby version above. Then run the following command to install all the dependencies (including Rails):

```bash
bundle install
```

To run the server:

```
rails server
```

There is only one endpoint, at `/commits`. It receives a get request with an `url`, `page`  and `per_page ` in the query string. They must respect the following conditions:

- `url` is as given by the *clone or download* button in the github repo, I.E. the HTTPS link ending with a `.git` extension. **REQUIRED.**
- `page` is the page to get, defaults to 1. **OPTIONAL.**
- `per_page` is the number of commits per page, defaults to 10.  **OPTIONAL.**

**Example:**

```
commits?url=https://github.com/codacy/codacy-detekt.git&page=1&per_page=2
```

## How to run tests

To run all:

```
rspec
```

To run specific:

```
rspec path_to_file
```

All tests are in the spec folder.

## Structure

All the business logic of the application is contained inside the lib folder. I made this choice so that I could build the application independent from rails, and only use it to handle the requests.

The main entry point is `viewer_orchestrator`. It is the class that is called in the rails controller and that triggers all the process of getting the commits. First it tries to get them through the GitHub API, and if that does not work, it clones the repo and uses the Git CLI

For each source (GitHub API or Git CLI), there is an implementation of a parser and a getter. These are instantiated in `viewer_orchestrator` and injected into the `lister` class.

The `lister` class gets the commit through the `getter` , runs through each received commit, and uses the `parser` to build a data structure with each commit. In the end, it returns an array of hashes, each one representing a commit.

### Adding a new source

In the eventuality of adding a new source, you will have to implement a new `getter`, that returns an array of some data structure that is iterable, and where each element is a commit.

You will then have to also create a `parser`, which mixes in `ParserMixin`, and which has the knowledge of how to convert each above element into a hash with the various commit parameters.

```
{:hash => commit_hash, :message => commit_message, ...}
```

Currently, the correspondence for existing parsers is defined in `constants.rb`, as is the format to output. 

## 