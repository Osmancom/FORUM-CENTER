public class BatchApex implements Database.Batchable<sObject> {
    
   // Start Methodu: Start metodu, Batch Apex işleminin başlatılmasını sağlayan ana yöntemdir. 
   // Bu yöntem, veri kümesinin nasıl seçileceğini belirler ve veri kümesinin bir liste şeklinde döndürülmesi gerekiyor.
    public Database.QueryLocator start(Database.BatchableContext BC){
   //soql sorgusunu burda yapiyoruz. bize lazim olacak recordlari burda topluyoruz.
        
        return null;
 }
 
    public void execute(Database.BatchableContext BC, List<sObject> accList){
   //Execute yöntemi, her döngüde veri kümesinin bir parçasını işleyen yöntemdir. 
   //Bu yöntem, veri kümesinin bir parçası olan kayıtları alır ve bunları işler. 
   //asil islemlrin yapildigi yer. 
   
   //start methodunda toptan yapilan sorgulari, execute 200 200 alip islem yapiyor.
       
 }
        
    
    public void finish(Database.BatchableContext BC){
      //Finish yöntemi, Batch Apex işleminin tamamlanmasını sağlar. Bu yöntem, işleme sonucu olarak oluşabilecek raporları veya kayıtları kaydedebilir
        //bilgilendirme kismi. mail gonderme, task atama vs islemeler yapilabilir
        
        //implement etmek zorunlu ama kullanmak zorunlu degil. bir kez calisir.
    }
}