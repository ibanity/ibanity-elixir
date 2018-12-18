# Changelog

## 0.3.2

* Add relationship ids to resources

## 0.3.1

* Sign API schema retrieval with default app key, if available

## 0.3.0

* Use certificate/key content instead of file paths for improved security
* Support for encrypted private key (to a certain extent - limited by Erlang support)
* Fix problems when using other applications than default
* Retry multiple times when fetching the API schema before failing

## 0.2.0

* Support for multiple applications
* Fix some typos in the documentation
* Support for financial institution transactions
* Support for synchronizations
* Navigation withing collections (first, next and previous links)
* Better type handling when deserializing JSON (e.g: DateTime instead of strings)
* Fetch relationships

## 0.1.0

First official release