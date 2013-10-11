# GIGEST

[![Build Status](https://travis-ci.org/winston/gigest.png?branch=master)](https://travis-ci.org/winston/gigest)

**GI**tHub **GE**ms **ST**ats. Discover Gems usage for a GitHub user or org!
Checkout [Gigest App](http://gigest.herokuapp.com/)!

Do you want to know which are the most/least frequently used Gems for a GitHub user or organization?
GIGEST gives you the ability to do that by inspecting the Gemfiles across all repos for a GitHub account.


## Installation

    gem install 'gigest'


## Usage

1) Authenticate. You have [4 ways to do it](http://octokit.github.io/octokit.rb/#Authentication).

    analytics = Gigest::Analytics.new(login: "winston", password: "secret")

Authenticating with your username and password will give GIGEST access to public and private repos within your GitHub account and organization/s.

Authenticating with an OAuth access token will give GIGEST access to repos depending on the [scopes which the OAuth access token was granted](http://developer.github.com/v3/oauth/#scopes).

2) Process for a GitHub user or GitHub Organization.

    analytics.process_for("winston")

This can take a while if the GitHub account contains A LOT of repos. Sit back and relax.

3) Get summary.

    analytics.summary

Returns you a Hash in the format:

    {
      gem1: [repo1, repo2],
      gem2: [repo1, repo2, repo3, repo4]
    }

4) Get statistics.

    analytics.statistics

Returns you an Array in the format:

    [
      {gem_name: "gem1", repositories: ["repo1", "repo2"], count: 2, percentage: 100.0},
      {gem_name: "gem2", repositories: ["repo1"], count: 1, percentage: 50.0}
    ]


## Contributing

Pull Requests are very welcomed (with specs, of course)!

To run all specs, just execute `rake` or `rspec`.


## Author

GIGEST is maintained by [Winston Teo](mailto:winstonyw+gigest@gmail.com).

[You should follow Winston on Twitter](http://www.twitter.com/winstonyw), or find out more on [WinstonYW](http://www.winstonyw.com) and [LinkedIn](http://sg.linkedin.com/in/winstonyw).


## License

Copyright © 2013 Winston Teo Yong Wei. Free software, released under the MIT license.
