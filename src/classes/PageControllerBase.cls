// Written by David Habib, copyright (c) 2012 Groundwire, 1402 3rd Avenue, Suite 1000, Seattle, WA 98101
// This program is released under the GNU Affero General Public License, Version 3. http://www.gnu.org/licenses/

public abstract with sharing class PageControllerBase {
	
  	private ComponentControllerBase componentController;
	
  	public virtual ComponentControllerBase getComponentController() {
    	return componentController;
  	}

  	public virtual void setComponentController(ComponentControllerBase compController) {
    	componentController = compController;
  	}
	
  	public PageControllerBase getThis() {
    	return this;
  	}
	
	abstract public string getStrSoql();
	
	public list<string> strFields { get; set; } 
	
	public string strNameField { get; set; }
	
	public string strObjectType { get; set; }

	abstract public PageReference NewItem();
	
	public AUC_CTRL_SoqlListView ctrlSoqlListView {
		get {
			if (ctrlSoqlListView == null) {
				ctrlSoqlListView = (AUC_CTRL_SoqlListView) getComponentController();
			}
			return ctrlSoqlListView;
		}
		set;
	}
	
	public virtual PageReference EditItem(ID idItem) {
		return new PageReference('/' + idItem + '/e?retURL=' + ApexPages.currentPage().getURL());
	}	

}