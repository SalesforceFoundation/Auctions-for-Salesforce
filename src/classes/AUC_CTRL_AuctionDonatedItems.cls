// Written by David Habib, copyright (c) 2009, 2010, 2011 Groundwire, 1402 3rd Avenue, Suite 1000, Seattle, WA 98101
// This program is released under the GNU Affero General Public License, Version 3. http://www.gnu.org/licenses/

public with sharing class AUC_CTRL_AuctionDonatedItems extends PageControllerBase {

	// constructor
	public AUC_CTRL_AuctionDonatedItems() {
		strFields = new list<string>{'Name', 'Amount', 'StageName', 'CloseDate', 'GW_Auctions__Number_Available__c'};				        	
       	strNameField = 'GW_Auctions__Auction_Donated_Item_Name__c';
       	strObjectType = 'Opportunity'; 				
	}
	
	
	public override string getStrSoql() {		
		string strSoql = 'select Id, GW_Auctions__Auction_Donated_Item_Name__c, Name, Amount, CloseDate, StageName, GW_Auctions__Number_Available__c from opportunity ' + 
        		'where RecordTypeId=\'' + AUC_AuctionMaintenance.recordtypeIdAuctionDonatedItem  + 
        		'\' and CampaignId=\'' + ctrlSoqlListView.auctionMaintenance.campaignIdAuctionDonors + '\'';
		if (ctrlSoqlListView.strAlphaFilter != null) {
			strSoql += ' and GW_Auctions__Auction_Donated_Item_Name__c like \'' + ctrlSoqlListView.strAlphaFilter + '%\'';
		}        		
       	return strSoql;			
	}

	public override PageReference NewItem() { 
		PageReference p = new PageReference('/apex/GW_Auctions__AuctionNewDonatedItemWizard?auctionId=' + ctrlSoqlListView.auctionId);
		return p;		
	}
	

	//==================== TEST METHOD(s) ======================================
	static testmethod void CodeCoverageTests() {
    	// create needed data
    	Auction__c auction = new Auction__c (
			Name = 'Test Auction',
			Auction_Date__c = System.Today()
		);  
		insert auction;  	
    	
    	Campaign campaign = [select Id, Auction__c from Campaign where Auction_Campaign_Type__c=:AUC_AuctionConstants.CAMPAIGN_TYPE_AuctionItemDonors and Auction__c = :auction.id];
    	System.assertEquals(auction.id, campaign.Auction__c);
    	
		AUC_AuctionMaintenance am = new AUC_AuctionMaintenance();
    	Opportunity oppDonatedItem = new Opportunity (
    		Name = 'Test Opportunity',
    		Auction_Donated_Item_Name__c = 'Test Auction Donated item',
    		Amount = 100,
    		CampaignId = campaign.id,
    		RecordTypeId = AUC_AuctionMaintenance.recordtypeIdAuctionDonatedItem,
    		StageName = 'Won Not Thanked',
    		CloseDate = System.Today()
    	);
    	insert oppDonatedItem;

		am.auctionId = auction.Id;
		System.assertEquals(campaign.Id, am.campaignIdAuctionDonors);
		
		//point to our VF page
		PageReference p = new PageReference('Page.AuctionDonatedItems');
		p.getParameters().put('auctionId', auction.id); 
		Test.setCurrentPageReference(p);
		
		//instantiate the controller 
		AUC_CTRL_AuctionDonatedItems pageCtrl = new AUC_CTRL_AuctionDonatedItems();
		AUC_CTRL_SoqlListView compCtrl = new AUC_CTRL_SoqlListView();
		compCtrl.pageController = pageCtrl;
		system.assert(pageCtrl.strFields != null);
		system.assert(pageCtrl.strNameField != null);
		system.assert(pageCtrl.getStrSoql() != null);
		system.assert(pageCtrl.NewItem() != null);
		
	}


}