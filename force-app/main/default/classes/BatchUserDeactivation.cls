public class BatchUserDeactivation implements Database.Batchable<sObject>, Database.Stateful ,Schedulable{ //1- implement yaptik
    //19- Scheduable ekliyoruz. her pazar gunu gitmesini istedigimiz icin
    
    //Database.Stateful u birbiri ile haberlesme olarak dusunebiliriz. bunu yazmazsak 100 tane user deactive edilse bile 
    //methodlar kendini surekli yeniledigi icin, execute dan finish e bilgi gitmeyecek. ve ilk girdigimiz  amountOfDeactivedUsers =0 gorecegiz.
    
    List<String> usersDeactivated = new List<String>(); //12.a- deaktive yaptigimiz userlari ekleyecegimiz bos bir list.
    
    List<String> systemUser = new List<String>{ //4- senaryomuzda silinmeyecek userlari liste ekledik 
        'Chatter Expert', 'Automated Process', 'Data.com Clean', 'Integration User', 'Security User', 'Platform Integration User','sales force'
            };
                Integer amountOfDeactivedUsers =0;  //16- kac tane user deactive ettigimizi gormek icin sayac olusturduk        
    
    public Database.QueryLocator start(Database.BatchableContext bc){ //2. start methodu olusturduk
        //start methodunun amaci scorp u belirlemektir. execute da hangi recorlarla islem yapacagimizi belirleriz.
        //o yuzden getQueryLocator sorgulamasi yapariz. queryler start icinde calistirilir
        
        //5-metadata da sorgulama yapiyoruz. Account acc = [SELECT Rating  vs..] gibi.. metadata da Variable_Value__c sorguluyoruz
        List<Global_Variable__mdt> globVariable = [SELECT Variable_Value__c FROM Global_Variable__mdt WHERE DeveloperName = 'AutoDeactivationDay'];
        
        //6-numOfExpiry diye bir variable olusturudk. bnu gun hesabinda kullanacagiz. integer formatinda
        Integer numOfExpiryDay = Integer.valueOf(globVariable[0].Variable_Value__c);
        //7-last logini hesapliyoruz
        Datetime lastLogin = Datetime.now() - numOfExpiryDay;
        
        //8- return direk database sorgusunu yazabilirz.
        return Database.getQueryLocator([SELECT Id, Name, Firstname, Lastname,isActive, lastLoginDate //getqueryLocator in 2. si bu.
                                         FROM User
                                         WHERE (LastLoginDate <= :lastLogin OR (LastLoginDate = null AND CreatedDate <= :lastLogin))
                                         //LastLoginDate den kucuk olanlar ve lastlogindate=null ise createddate ile islem yapmalyim
                                         AND Name NOT IN :systemUser //systemuser lar olmayacagi icin Not In
                                         AND isActive = true]); //aktive olanlar
    }
    public void execute (Database.BatchableContext bc, List<User> userList){//3-execute methodu olusturudk.
        //execute cift parametrelidir. returnden donen datayi alip saklayacak, kullanacak.(scope)
        
        //9- 8 de return eden user listelerini pasif hale getirmemeiz lazim
        if(!userList.isEmpty()){//bos olmayanlari tek tek alip pasif yapacagiz. (userList.size()>0 da yapabiliriz.)
            for(User usr:userList){
                usr.isActive= FALSE;
                
                usersDeactivated.add(usr.FirstName + ' '+usr.LastName);//13- deaktive ettigimiz userlari 12.a da tanimladigimiz liste ekliyoruz.
                
                amountOfDeactivedUsers++;//17- user her deactive edildiginde sayaci bir arttiriyoruz
            }
            //10- update yapiyoruz
            Database.update(userList, false); //Partial Success kismi. hata olanlar kalacak, digerleri calisacak.
        }  
        //11- BatchUserDeactivation batchObj = new BatchUserDeactivation();
        //    Database.executeBatch(batchObj); 
        //    veya 
        //    Database.executeBatch(new BatchUserDeactivation());
        //    ile calistir.
    }
    public void finish (Database.BatchableContext bc){//12-bilgilendirme yapacagiz. deaktive ettigimiz userlarin bilgilendirmesini yapacagiz.
        //user bilgilerini tutabilmek icin bir list olusturalim. 
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); //14-messaging classimizda bir email olusturacagiz
        //RecipientEmails, Subject, Body    email in kisimlari. flow daki vs gibi
        
        //15- email i dolduruyoruz
        List<String> toEmails = new List<String>{'salesforcular@gmail.com'};  
            email.setToAddresses(toEmails); //alici email adreslerini girecegimiz setToAddresses methodu. 
        //list seklinde parametre aldigi icin oncesinde bir list tanimlayalim
        
        email.setSubject('User Deactivation Job Result'); //string aldigi icin direkt elle girdik
        
        email.setPlainTextBody('Merhaba, ' +'\n' //email in body kismi === '\n' newline.. bir alt satira gecme
                               + 'Asagidaki kullanicilar uzun sure Login olmadigindan BatchUserDeactivation Batch Job tarafindan Deactive edilmistir.'+'\n'
                               +'Deactivate edilen User sayisi : ' + amountOfDeactivedUsers + '\n' 
                               +'Deactivate edilen User Bilgileri: '+'\n'
                               +usersDeactivated+ '\n'); 
        
        //18-simdi maili gonderme
        //sendEmail list formatinda parametre aldigi icin list olusturalim
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>(); 
        emails.add(email); //yukarda olsuturdugumuz email i ekledik
        Messaging.sendEmail(emails);
    }
    //20-schedulable method
    public void execute(SchedulableContext sc){//sc parametresini biz verdik
       BatchUserDeactivation batchObj = new BatchUserDeactivation(); //ann windwsta yaptigimiz islemi direk methodun icinde yapacagiz
       Database.executeBatch(batchObj); 
    } 
}