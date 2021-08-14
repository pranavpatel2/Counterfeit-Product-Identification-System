pragma solidity 0.5.0;

contract fakeProduct{
    
     address owner;
     
      modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    struct product {
        string brand;
        string model;
        string description;
        string manufactuerName;
        string manufactuerLocation;
        string manufactuerTimestamp;
        string owner;
    }
    
    
    struct customer {
        string name;
    }
    
    
    struct retailer {
        string name;
        string shopaddress;
    }
    
    struct company{
        string name;
        string companyaddress;
    }
    
    mapping (string => product) productArray ;
    mapping (string => customer) customerArray;
    mapping (string => retailer) retailerArray;
    mapping (string => company) companyArray;
    
    
    
    function addProduct(string memory code,string  memory brand,string  memory model, string  memory description, 
            string  memory manufactuerName ,string  memory manufactuerLocation ,
            string  memory manufactuerTimestamp,string memory productOwner) public {
                
        product memory newproduct;
        newproduct.brand = brand;
        newproduct.model = model;
        newproduct.description = description;
        newproduct.manufactuerName = manufactuerName;
        newproduct.manufactuerLocation = manufactuerLocation;
        newproduct.manufactuerTimestamp = manufactuerTimestamp;
        newproduct.owner=productOwner;
        productArray[code] = newproduct;
        
    }
    
    
    function addCustomer(string memory name,string memory email) public {
        
        customer memory newcustomer;
        newcustomer.name=name;
        customerArray[email]=newcustomer;
    }
    
    
    function addRetailer(string memory name,string memory retailer_address ,string memory email) public {
        
        retailer memory newRetailer;
        newRetailer.name = name;
        newRetailer.shopaddress = retailer_address;
        retailerArray[email] = newRetailer;
    }
    
    function addCompany(string memory name,string memory company_address ,string memory email) public {
        
        company memory newCompany;
        newCompany.name = name;
        newCompany.companyaddress = company_address;
        companyArray[email] = newCompany;
    }
    
    function getProductDetails(string memory code) public view returns(string  memory ,string  memory , string  memory , 
            string  memory  ,string  memory ,string  memory,string  memory){
                
                
        return    (productArray[code].brand ,productArray[code].model ,productArray[code].description, productArray[code].manufactuerName,
                    productArray[code].manufactuerLocation, productArray[code].manufactuerTimestamp,productArray[code].owner);
        
    }
    
    function getCustomer(string memory email) public view returns(string memory){
        
        return customerArray[email].name;
    }
    
    
    function getRetailer(string memory email) public view returns(string memory,string memory){
        
        return (retailerArray[email].name,retailerArray[email].shopaddress);
    }
    
     function getCompany(string memory email) public view returns(string memory,string memory){
        
        return (companyArray[email].name,companyArray[email].companyaddress);
    }
    
    function changeOwner(string memory code,string memory email) public {
        
        productArray[code].owner=email;
    }
    
    function getOwner(string memory code) public view returns(string memory){
        return productArray[code].owner;
    }
    
}