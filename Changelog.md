# Changelog

## 0.5.0

* Add support for periodic and bulk payments
* Raise exception when a DateTime cannot be parsed from the response
* Add support for filtering on XS2A list financial institutions call
* Fix incorrect field types for financial institution

## 0.4.0

* Update financial institution attributes
* Add billing and consent products
* Provide http request error responses as tuples
* Fix pagination
* Decouple sandbox and XS2A resources

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
