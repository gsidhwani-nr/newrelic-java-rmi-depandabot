<a href="https://opensource.newrelic.com/oss-category/#community-project"><picture><source media="(prefers-color-scheme: dark)" srcset="https://github.com/newrelic/opensource-website/raw/main/src/images/categories/dark/Community_Project.png"><source media="(prefers-color-scheme: light)" srcset="https://github.com/newrelic/opensource-website/raw/main/src/images/categories/Community_Project.png"><img alt="New Relic Open Source community project banner." src="https://github.com/newrelic/opensource-website/raw/main/src/images/categories/Community_Project.png"></picture></a>

![GitHub forks](https://img.shields.io/github/forks/newrelic/newrelic-java-rmi?style=social)
![GitHub stars](https://img.shields.io/github/stars/newrelic/newrelic-java-rmi?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/newrelic/newrelic-java-rmi?style=social)

![GitHub all releases](https://img.shields.io/github/downloads/newrelic/newrelic-java-rmi/total)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/newrelic/newrelic-java-rmi)
![GitHub last commit](https://img.shields.io/github/last-commit/newrelic/newrelic-java-rmi)
![GitHub Release Date](https://img.shields.io/github/release-date/newrelic/newrelic-java-rmi)


![GitHub issues](https://img.shields.io/github/issues/newrelic/newrelic-java-rmi)
![GitHub issues closed](https://img.shields.io/github/issues-closed/newrelic/newrelic-java-rmi)
![GitHub pull requests](https://img.shields.io/github/issues-pr/newrelic/newrelic-java-rmi)
![GitHub pull requests closed](https://img.shields.io/github/issues-pr-closed/newrelic/newrelic-java-rmi)


# New Relic Java Instrumentation for Java RMI 

Provides instrumentation for the Java RMI on both the server and client side. 

## Installation cn

This use this instrumentation.  
1. Download the latest release.    
2. In the New Relic Java Agent directory (directory containing newrelic.jar), create a directory named extensions if it doe not already exist.   
3. Copy the jars into the extensions directory.   
4. Restart the application.   

## Getting Started

After deployment, you should be able to see:   
The client and server transactions will be tied together with Distributed Tracing.   

### Client
See RMI calls as an external service.    
### Server
See a transaction for the RMI class and method call.   

### Sample RMI Sample
A Sample is available to explore the RMI Transaction.
#### Sample Source  
                         example/newrelic-java-rmi-demo
#### Sample User Guide
                         docs/rmi_sample_userguide.pdf

## Building

Make sure you have OpenJDK 1.8 installed.

If you make changes to the instrumentation code and need to build the instrumentation jars, follow these steps
1. Set environment variable NEW_RELIC_EXTENSIONS_DIR.  Its value should be the directory where you want to build the jars (i.e. the extensions directory of the Java Agent).   
2. Build one or all of the jars.   
a. To build one jar, run the command:  gradlew _moduleName_:clean  _moduleName_:install    
b. To build all jars, run the command: gradlew clean install
3. Restart the application

## Support

New Relic has open-sourced this project. This project is provided AS-IS WITHOUT WARRANTY OR DEDICATED SUPPORT. Issues and contributions should be reported to the project here on GitHub.

>We encourage you to bring your experiences and questions to the [Explorers Hub](https://discuss.newrelic.com) where our community members collaborate on solutions and new ideas.

## Contributing

We encourage your contributions to improve Salesforce Commerce Cloud for New Relic Browser! Keep in mind when you submit your pull request, you'll need to sign the CLA via the click-through using CLA-Assistant. You only have to sign the CLA one time per project. If you have any questions, or to execute our corporate CLA, required if your contribution is on behalf of a company, please drop us an email at opensource@newrelic.com.

**A note about vulnerabilities**

As noted in our [security policy](../../security/policy), New Relic is committed to the privacy and security of our customers and their data. We believe that providing coordinated disclosure by security researchers and engaging with the security community are important means to achieve our security goals.

If you believe you have found a security vulnerability in this project or any of New Relic's products or websites, we welcome and greatly appreciate you reporting it to New Relic through [HackerOne](https://hackerone.com/newrelic).

## License

New Relic Java Instrumentation for RMI is licensed under the [Apache 2.0](http://apache.org/licenses/LICENSE-2.0.txt) License.

>[If applicable: [Project Name] also uses source code from third-party libraries. You can find full details on which libraries are used and the terms under which they are licensed in the third-party notices document.]

