global class SendSurveySch implements Schedulable{
    global void execute(SchedulableContext sc){ 
        Database.executeBatch(new SendSurveyBatch('Survey'),200); 
    }
}