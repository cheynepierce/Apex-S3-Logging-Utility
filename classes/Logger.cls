public class Logger {
	public static List<LogMessage> messages {get; set;}

	/**
	* Add a single LogMessage object to the messages list. 
	*/
	public static void log(String message, String logLevel) {
		if (Logger.messages == null) {
			Logger.messages = new List<LogMessage>();
		}
		
		Logger.messages.add(new LogMessage(message, logLevel));
	}

	/**
	* Write the log message data to S3
	*/
	public static void commitLogs() {
		Log_Config__c logConfig = Log_Config__c.getOrgDefaults();

		S3 s3 = new S3(logConfig.AWS_Region__c);
		s3.createFile(
			logConfig.S3_Bucket_Name__c, 
			Logger.getLogFolderName(), 
			Logger.getLogFileName(), 
			Logger.createFileContent());
	}

	/**
	* Create the log file content, by concatenating the log messages, separated by new lines.
	*/
	public static String createFileContent() {
		String content = '';
		for (LogMessage message : messages) {
			content += Logger.getLogFileLine(message) + '\n';
		}
		return content;
	}

	/**
	* Convert a LogMessage object into a single line of text for the log file.
	*/ 
	public static String getLogFileLine(LogMessage message) {
		return getTimestamp(message.dt) +  ' - ' + 
				message.logLevel + ' - ' + 
				message.message;
	}

	/**
	* Get the folder name for this log file.
	*/
	public static String getLogFolderName() {
		return 'logs';
	}

	/**
	* Name the log file with the current username and the current datetime.
	*/
	public static String getLogFileName() {
		return UserInfo.getUsername() + '-' + getTimestamp(Datetime.now()) + '.log';
	}

	/**
    * Returns the datetime string (YYYY-MM-DDTHHMMSS)
    */
    public static String getTimestamp(Datetime dt) {
        return getString(dt.yearGmt()) + 
                getString(dt.monthGmt()) + 
                getString(dt.dayGmt()) + 'T' + 
                getString(dt.hourGmt()) + 
                getString(dt.minuteGmt()) + 
                getString(dt.secondGmt());
    }

    /**
    * Convert a date/time component to string format (prependig a '0' if necessary).
    */
    public static String getString(Integer comp) {
        String s = String.valueOf(comp);
        if (s.length() == 1) {
            return '0'+s;
        }
        return s;
    }

	public class LogMessage {
		public String message {get; set;}
		public String logLevel {get; set;}
		public String username {get; set;}
		public Datetime dt {get; set;}

		public LogMessage(String message, String logLevel) {
			this.message = message;
			this.logLevel = logLevel;
			this.username = UserInfo.getName();
			this.dt = Datetime.now();
		}
	}
}