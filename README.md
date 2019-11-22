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
localhost:3000/commits?url=https://github.com/codacy/codacy-detekt.git&page=1&per_page=2
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

All tests are in the spec folder. Some of them are dependent on an Internet connection, since they test the actual communication with github.

I used another repo in my account as an example url. 

## Structure

All the business logic of the application is contained inside the lib folder. I made this choice so that I could build the application independent from rails, and only use it to handle the requests.

I strived to follow SOLID practices. Especially, I tried to structure it so it would be open for extension, close for modification as it regards to new parameters in the output, for each commit, and to new sources.

The main entry point is `viewer_orchestrator`. It is the class that is called in the rails controller and that triggers all the process of getting the commits. First it tries to get them through the GitHub API, and if that does not work, it clones the repo and uses the Git CLI

For each source (GitHub API or Git CLI), there is an implementation of a parser and a getter. These are instantiated in `viewer_orchestrator` and injected into the `lister` class.

The `lister` class validates the input url, gets the commit through the `getter` , runs through each received commit, and uses the `parser` to build a data structure with each commit. In the end, it returns an array of hashes, each one representing a commit.

The code is protected against malformed url's and injected commands (CLI case). It also times out if any of the sources fails to respond. That value is configurable, in `constants.rb`.

### Adding a new source

In the eventuality of adding a new source, you will have to implement a new `getter`, that returns an array of some data structure that is iterable, and where each element is a commit.

You will then have to also create a `parser`, which mixes in `ParserMixin`, and which has the knowledge of how to convert each above element into a hash with the various commit parameters.

```
{:hash => commit_hash, :message => commit_message, ...}
```

Currently, the correspondence for existing parsers is defined in `constants.rb`, as is the format to output. 

### Adding a new parameter to the output

To add a new parameter to the log output, add it to the output format. You will thenhave to add a correspondence for each one of the sources, depending on the data structure it returns. See current examples in `constants.rb` 

## Things I would like to have done:

- Remove the dependency on my hardcoded repo in the tests.
- Add functionality to specify branch.
- Add more tests to get more coverage.
- Add CI.
- Run static analysis and refactor to improve quality.