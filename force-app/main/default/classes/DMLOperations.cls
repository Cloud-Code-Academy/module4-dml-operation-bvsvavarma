/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Satya Buddharaju Venkata
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance
        Account acc = new Account();
        // Set some fields on the Account
        acc.Name = 'Cloud Code Academy Exercise';
        acc.Rating = 'Hot';
        acc.Industry = 'Education';
        // Insert the Account into the database
        insert acc;
        // Return the Id of the newly created Account
        if(acc != null){
            return acc.Id;
        } else{
            return null;
        }
        
    }

    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline
        Account acc = New Account(Name=name, Industry=industry);
        // Insert the Account
        insert acc;
    }

    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance
        Contact con = new Contact();
        // Set some fields on the Contact
        con.firstName = 'Satya';
        con.LastName = 'Buddharaju';
        // Set the AccountId field to the given accountId
        con.AccountId = accountId;
        // Insert the Contact into the database
        insert con;
        // Return the Id of the newly created Contact
        if(con != null){
            return con.Id;
        }else{
            return null;
        }   
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        List<Contact> conList = [SELECT Id, FirstName, LastName 
                                    FROM Contact 
                                        WHERE Id = :contactId
                                            WITH USER_MODE];
    
        // Update the Contact's last name
        for(Contact con : conList){
            con.LastName = newLastName;
        }
        update conList;
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        List<Opportunity> optyList = [SELECT Id, StageName 
                                        FROM Opportunity 
                                            WHERE Id = :oppId
                                                WITH USER_MODE];
        // Update the Opportunity's stage
        for(Opportunity opty : optyList){
            opty.StageName = newStage;
        }
        // Update the Opportunity in the database
        update optyList;
    }

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        // [SELECT Id FROM Account WHERE Id = :accountId]
        List<Account> accList = [SELECT Id, Name, Industry 
                                    FROM Account 
                                        WHERE Id = :accountId
                                            WITH USER_MODE];
        // Update the Account with the given Id with the new name and industry
        List<Account> accountToUpdate = new List<Account>();
            for(Account acc : accList){
                acc.Name = newName;
                acc.Industry = newIndustry;
                accountToUpdate.add(acc);
            }
           
            if(!accountToUpdate.isEmpty()){
                update accountToUpdate;
            }
    }


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        
        // Loop through each Opportunity in the list
        for(Opportunity opty : opportunities){
            // Set the Opportunity's Stage to Qualification
            opty.StageName = 'Qualification';
            // Set the Opportunity's Close Date to 3 months from today
            Date dt = Date.today();
            opty.CloseDate = dt.addMonths(3);
             // Set the Opportunity's Amount to 50000
            opty.Amount = 50000;
        }     
        // Upsert the opportunities List so that records are either updated or created
        upsert opportunities;
    }

    /**
     * Question 8
     * Insert or update opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * HINT: The account may or may not exists in the database but is required for opportunity creation. Consider how upsert operation can help with this.
     * HINT: There should not be duplicate opportunites based on the name
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        Account acc = new Account(Name = accountName);
        upsert acc;
        List<Opportunity> opoprtunityToInsert = new List<Opportunity>();
        // Loop through each Opportunity name
            for(String name : oppNames) {
                // Create an Opportunity with the given name
                Opportunity opty = new Opportunity();
                opty.Name = name;
                opty.StageName = 'Prospecting';
                opty.CloseDate = Date.Today() + 5;
                opty.AccountId = acc.Id;
                opoprtunityToInsert.add(opty);
            }
            // Add the Opportunity to the list
            if(!opoprtunityToInsert.isEmpty()){
                insert opoprtunityToInsert;
            }
            
    }
    
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		// Query for the Account
		List<Account> accList = [SELECT Id, Name, Description FROM Account WHERE Name = :accountName];
		
        Account acc = new Account();
        // if the Account exists, update the description
        if(!accList.isEmpty()){
            acc.Name = accountName;
            acc.Description = 'Updated Account';
        } else{
            acc.Name = 'Test Account';
            acc.Description = 'New Account';
        }
		// Upsert the Account
        upsert acc;	

        return acc;
	}

    /**
     * Question 10
	 * Manage the association between Contacts and Accounts
	 * Ensure that for each Contact in the provided list, there is a corresponding Account Name that matches the Contact's last name.
	 * If such an Account does not exist, the method creates it; if it does, the method ensures the Contact is associated with it. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
     * Example Contact.LastName = 'Doe' Link to Account.Name = 'Doe' 
     * Example Contact.LastName = 'Jane' Link to Account.Name = 'Jane'
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
		//Set for Contact Last Names
        Set<String> contactLastNames = new Set<String>();
        for(Contact contact : contactsToUpsert){
            contactLastNames.add(contact.LastName);
        }
        //Map to hold exsing Accounts with contact Last Name
        Map<String, Account> accountMap = new Map<String, Account>();

        List<Account> existingAccounts = [Select Id, Name 
                                            FROM Account 
                                                WHERE Name IN :contactLastNames 
                                                    WITH USER_MODE];
        for(Account acc: existingAccounts) {
            accountMap.put(acc.Name, acc);
        }

        //List to Hold Accounts not exists with contact Last Name
        List<Account> accountToInsert = new List<Account>();
        
        for(Contact con : contactsToUpsert){
            if(con.LastName != null){
                String conLastName = con.LastName;
                //If Account not exits then create a new account
                if(!accountMap.containsKey(conLastName)){
                    Account acc = new Account(Name = conLastName);
                    accountToInsert.add(acc);
                }else{
                    //If account Exits then Link Contact Account Id with Account Id
                    con.AccountId = accountMap.get(conLastName).Id;
                } 
            }
        }
        //If New Accounts Exits then insert
        if(!accountToInsert.isEmpty()){
            upsert accountToInsert;
            //Add Newly inserted Accounts to Map
            for( Account account : accountToInsert){
                accountMap.put(account.Name, account);
            }
        }

        //Link New Created Account Id to Contact
        for(Contact con : contactsToUpsert){
            if(con.AccountId == null && con.LastName != null){
                con.AccountId = accountMap.get(con.LastName).Id;
            }
        }
            
            upsert contactsToUpsert;
    }
	

    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        List<Lead> leadsToInsert = new List<Lead>();
        // Loop through each Lead name
        for(String name : leadNames) {
            Lead l = new Lead();
            l.LastName = name;
            l.Company = 'CCA';   
            l.Email = 'buddharaju.varma@gmail.com';
            leadsToInsert.add(l);
        }
        // Insert the Leads
        if(!leadsToInsert.isEmpty()) {
            insert leadsToInsert;
        }
        // Delete the Leads
        delete leadsToInsert;
    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
        List<Case> caseToInsertList = new List<Case>();
        // Insert the cases
        for(Integer i = 0; i < numOfCases; i++){
            Case caseToInsert = new Case();
            caseToInsert.Status = 'New';
            caseToInsert.Origin = 'Web';
            caseToInsert.AccountId = accountId;
            caseToInsertList.add(caseToInsert);
        }
        if(!caseToInsertList.isEmpty()){
            insert caseToInsertList;
        }
        // Delete the cases
        delete caseToInsertList;
    }
}