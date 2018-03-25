# Custom Apex Logging Utility

### Purpose
This is an Apex utility for writing custom debug log messages to a file in S3.

### Deployment
<a href="https://githubsfdeploy.herokuapp.com?owner=cheynepierce&repo=Apex-S3-Logging-Utility">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>

### Create a File
1. Create a new organizational level AWS Configuration custom setting, and set your AWS access key and secret key.

2. Create a bucket in S3 where you want to store log files. Take note of the bucket name and region.

3. Create a new organizational level Log Config custom setting and set your S3 region and bucket name where you want to store logs.

4. Create a log file from within any Apex class or trigger:

```
//This will create a new line in the log file.
Logger.log('Log message', 'Log level');

//This will create the file in S3
Logger.commitLogs();
```
