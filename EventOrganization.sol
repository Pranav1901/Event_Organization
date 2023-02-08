//SPDX-License-Identifier: Unlicense

pragma solidity >=0.5.0 <0.9.0;

contract EventContract {

    // A structure for Event
    struct Event{
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
    }
    // A Map to store the event with a specific id
    mapping(uint=>Event) public events;
    // A Map to store the address of the person who is purchasing the ticket with the event id and number of tickets of the particular event
    mapping(address=>mapping(uint=>uint)) public tickets;
    //id counter for event
    uint public nextId;
    
    
    // Function to create a Event
    function createEvent(string memory name, uint date, uint price, uint ticketCount) external {
    
        //The timestamp i.e the date of the event to be organised should we greater than the current timestamp
        require(date>block.timestamp,"You can organize event for future date");
        //The tickets of the events should be greater than 0
        require(ticketCount>0,"You can organize event only if you create more than 0 tickets");
        //IF everything is validated then the event will be created and we will increment the event counter
        events[nextId] = Event(msg.sender,name,date,price,ticketCount,ticketCount);
        nextId++;
    }
    
    // Function to buy a ticket of a event
    function buyTicket(uint id,uint quantity) external payable{
    
        // Checking the timestampof the event by its id and verify that the event is not over 
        require(events[id].date!=0,"Event does not exist");
        require(events[id].date>block.timestamp,"Event has been ended");
        // A variable to store a event
        Event storage _event = events[id];
        //The amount of the ether sent by the attende of the event should be equal to the event price * quantity of the tickets that need to be purchase
        require(msg.value==(_event.price*quantity),"Ethere is not enough");
        // The quanity of the tickets that is been purchase should be greater than the quantity of ticket remained
        require(_event.ticketRemain>=quantity,"Not enough tickets");
        // If everything is validated than we will reduce the qunatity of ticket from events ticket count and increment the quantity in tickets Map
        _event.ticketRemain-=quantity;
        tickets[msg.sender][id]+=quantity;
    }
    // Function to transfer a ticket
    function transferTicket(uint id,uint quantity,address to)external{
        
        // Checking the timestampof the event by its id and verify that the event is not over 
        require(events[id].date!=0,"Event does not exist");
        require(events[id].date>block.timestamp,"Event has already occoured");
        //The sender attende should have that much quantity of ticket which he is sending to another attende
        require(tickets[msg.sender][id]>=quantity,"You do not have enough tickets");
        //If everything is validated then reduce the ticket quantity from senders and increment to recivers in the ticket Map
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;
    }
}
