@isTest
private class Logger_Test {
	static testMethod void testLogger() {
		Test.setMock(HttpCalloutMock.class, getCreateFileRequestMock());

		Logger.log('test message 1', 'DEBUG');
		Logger.log('test message 2', 'WARNING');
		Logger.log('test message 3', 'ERROR');

		system.assertEquals(3, Logger.messages.size());

		Test.startTest();
			Logger.commitLogs();
		Test.stopTest();

		String fileContent = Logger.createFileContent();
		for (Logger.LogMessage message : Logger.messages) {
			system.assert(fileContent.contains(message.message));
		}
	}

	@TestSetup
	static void setupData() {
		Log_Config__c logConfig = new Log_Config__c(
			AWS_Region__c='us-east-1',
			S3_Bucket_Name__c='test'
		);
		insert logConfig;
	}

	static SingleRequestMock getCreateFileRequestMock() {
		Map<String, String> responseHeaders = new Map<String, String>();

		SingleRequestMock mock = new SingleRequestMock(
			200, 'Success', '', responseHeaders
		);

		return mock;
	}
}