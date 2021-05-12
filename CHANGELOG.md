# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.0.2] - 2021-05-12
### Added
- `enableHorizontalScroll` flag which allows you to disable horizontal scrolling behaviour.
- Exposed `mainAxisAlignment` field.

## [0.0.1] - 2021-05-10
### Added
- Ability to define cell widgets using the builder callback.
- Paste action support.
- Backspace press tracking.
- Automatic focus control. You don't need to define the focus switching logic yourself. All you need to do in your cell widgets is to call the `focus.nextFocus()` when the input to the current field is complete.
- Example app.

[Unreleased]: https://github.com/RareScrap/verification_code_builder/compare/v0.0.2...HEAD
[0.0.2]: https://github.com/RareScrap/verification_code_builder/releases/tag/v0.0.2
[0.0.1]: https://github.com/RareScrap/verification_code_builder/releases/tag/v0.0.1