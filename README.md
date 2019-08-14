# NYTime

NYArticleTestApp
A simple app to hit the NY Times Most Popular Articles API and:

Show a list of articles newest first(sorted based on date)
Shows details when items on the list are tapped.
Show Cached articles if network not available
We'll are using the most viewed section of this API. http://api.nytimes.com/svc/mostpopular/v2/mostviewed/{section}/{period}.json?apikey= sample-key To test this API, For testAPI we used

all-sections for the section path component in the URL
7 for period
This is configurable in Constants.Swift file in Project. We used MVVM Design pattern and swift generic approach to develop this application. For CI/CD App using XcodeServer + Fastlane combination.

We are generating TestCase and Coverage report using three tools, you can opt out any one as per your connivance:

XcodeServer TestCase and Coverage report.
Fastlane+scan+slather TestCase and Coverage reports.
SonarQube TestCase and Coverage reports.
