pragma solidity ^0.4.17;
 
 
contract CampaignFactory {
    address[] public deployedCampaigns ; 
    
    function createCampaign(uint minimum) public {
        address campaignAddress = new Campaign(minimum, msg.sender);
        deployedCampaigns.push(campaignAddress);
    }
    
    function getDeployedCampaigns() public view  returns(address[]){
        return deployedCampaigns;
    }
} 
 
 
contract Campaign {
    
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping(address=>bool) approvals;
    }
    
    
    Request[] public requests; 

    address public manager; 
    uint public minimumContribution; 
    mapping(address=>bool) public approvers;
    uint public approversCount; 

    function Campaign (uint minCont , address managerAddress) public {
        
        manager = managerAddress ; 
        minimumContribution = minCont ;
    
    }
    
    function contribute () public payable {

        require(msg.value >= minimumContribution);
        approvers[msg.sender] = true;
        approversCount++;
    } 
    
    function createRequest (string description, uint value, address recipient) public restricted{

        Request memory req = Request({
            description:description,
            value:value,
            recipient:recipient,
            complete:false,
            approvalCount:0
        });
        
        requests.push(req);
    }
    
    
    function approveRequest(uint index) public {

        Request storage request = requests[index];
        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);
        request.approvals[msg.sender] = true;
        request.approvalCount++;    
    }
    
    function finalizeRequest (uint index )public restricted {
        Request storage request = requests[index];
        
        require(request.approvalCount > (approversCount/2));
        require(!request.complete);
        request.recipient.transfer(request.value);
        request.complete = true;
    }
    
    function getSummary () public view returns(uint, uint, uint, uint, address) {
        return(
            minimumContribution,
            this.balance,
            requests.length,
            approversCount,
            manager
        );
    }

    function getRequestCount () public view returns (uint) {
        return requests.length;
    } 

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
}