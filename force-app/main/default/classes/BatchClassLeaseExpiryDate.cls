public class BatchClassLeaseExpiryDate implements Database.Batchable<sObject>, Schedulable {
     //SENARYO: Leasing Team çalışanları Opportunity üzerinde kira anlaşması için çalışmaktadırlar. Eğer bir 
     //Contract’ın sona erme tarihi yakınsa, Leasing Team çalışanları müşteri ile iletişime geçip 
     //contract yenilenmesi hakkında görüşmelidir.
     //Eğer Contract yenilenecek ise yeni bir Opportunity oluşturulmalı ve anlaşma görüşmelerine 
     //başlanmalıdır. Contract end date’den 5 gün öncesinde Leasing Team çalışanlarına hatırlatma
     //maili gönderilmeye başlanmalı ve hafta içi her gün bu hatırlatma maili gönderilmelidir.

     
    //1- kalibi olusturduk
    //2- return girdik. Asset,Leasingadmin vs.. lookup fieldi oldugu icin syntaxi __r seklinde
    //3- mail gondermek icin execute methodda calistik 
    //4- ann windowsta calistirdik
    //5- schedulable implement yapiyoruz. 
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        
        
        return Database.getQueryLocator([SELECT Id, EndDate, ContractNumber, Asset_Manager__r.Email, Leasing_Admin__r.Email, Leasing_Analyst__r.Email 
                                         FROM Contract 
                                         WHERE EndDate = NEXT_N_DAYS:5]);
    }
    
    public void execute(Database.BatchableContext BC, List<Contract> contList){
        
        //Contract objecti ile calisip, sorgulayacagiz.
        List<Messaging.SingleEmailMessage> emails = new  List<Messaging.SingleEmailMessage>(); //birden fazla contract dondurdugu icin, birden fazla mail gonderecegiz. 
        
        for(Contract cont : contList){
            Messaging.SingleEmailMessage email = new  Messaging.SingleEmailMessage();//her bir contract icin ayri bir mail olusturuyruz
            
            //=========bos bir list olusturup userlarin emaillerini giriyoruz.
            List<String> emailAddress = new List<String>();
            emailAddress.add(cont.Asset_Manager__r.Email);
            emailAddress.add(cont.Leasing_Admin__r.Email);
            emailAddress.add(cont.Leasing_Analyst__r.Email);
            email.setToAddresses(emailAddress);
            
            //==========Subject
            email.setSubject('Contract bitmek uzere, kontrol edilmeli.'); 
            
            //======body
            email.setPlainTextBody('Merhaba, '+'\n'+'Contract kisa surede bitecektir. Lütfen müsteri ile irtibata geciniz. '+'\n'
                                   +'Contract Number : '+cont.ContractNumber + '\n'
                                   +'Contract End Date : '+cont.EndDate);
            
            //==========liste aktariyoruz
            emails.add(email);
            
        } 
        //==========donguden cikip send yapiyoruz
        Messaging.sendEmail(emails);
    }
    
    
    public void finish(Database.BatchableContext BC){
        //finish methodu icinde islem yapmadigimiz icin bos biraktik.
    }
    /*BatchClassLeaseExpiryDate contBatch = new BatchClassLeaseExpiryDate();
    Database.executeBatch(contBatch); ile calistir*/ 
    
    //============Schedulable 
    public void execute(SchedulableContext sc){
       BatchClassLeaseExpiryDate contBatch = new BatchClassLeaseExpiryDate();
       Database.executeBatch(contBatch); 
        
        //hafta ici her sabah 8.30 da calismasi isteniyor.
        //setup=> apex class => Schedule Apex burda tam saatleri secebiliyorz sadece
        
        //cron expr kullanabiliriz.
        
       /* BatchClassLeaseExpiryDate contBatch = new BatchClassLeaseExpiryDate();
        String cronExp = '0 30 8 ? * MON-FRI';
        System.schedule('Contract End Date', cronExp, contBatch); ile ayarlayabiliriz. bunu ann windowsta calistiracagiz*/
        
    }
}