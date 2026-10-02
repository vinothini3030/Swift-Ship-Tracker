// Sample data for testing the tracker / Agentforce action
Sender__c s = new Sender__c(Name='Demo Sender', Sender_Contact__c='9876543210', Sender_Email__c='sender@example.com');
insert s;

List<Parcel__c> parcels = new List<Parcel__c>{
    new Parcel__c(Name='Books Box',   Status__c='Booked',           Weight__c=2.5,  Estimated_Delivery_Date__c=Date.today().addDays(5), Sender__c=s.Id),
    new Parcel__c(Name='Laptop',      Status__c='In Transit',       Weight__c=3.2,  Estimated_Delivery_Date__c=Date.today().addDays(2), Sender__c=s.Id),
    new Parcel__c(Name='Gift Hamper', Status__c='Out for Delivery', Weight__c=1.8,  Estimated_Delivery_Date__c=Date.today().addDays(1), Sender__c=s.Id)
};
insert parcels;

insert new Receiver__c(Name='Demo Receiver', Receiver_Contact__c='9123456780', Receiver_Email__c='receiver@example.com', Sender__c=s.Id, Parcel__c=parcels[0].Id);
insert new Delivery__c(Name='Delivery 1', Estimated_Delivery_Date__c=Date.today().addDays(2), Sender__c=s.Id, Parcel__c=parcels[1].Id,
                       Current_Location__Latitude__s=13.0827, Current_Location__Longitude__s=80.2707);
System.debug('Seeded ' + parcels.size() + ' parcels');
