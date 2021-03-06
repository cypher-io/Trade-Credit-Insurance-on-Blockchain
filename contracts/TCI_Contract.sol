pragma solidity ^0.4.8;


//----------------------------------------------------
//------------------ TCI -----------------------------
//----------------------------------------------------
contract TCI_Contract{ //is Invoice

  /**********
  Definition of the data
  **********/
  struct Contract{
      bytes32 IdTransaction;
      bytes32 amount;
      bytes32 currency;
      bool IsRecovered;
      bool IsInDefault;
      bool sellerGotPaid;
  }

  address _creator;
  Contract public TCI;

  /**********
  Events
  **********/
  //For the API query
  event InDefault (string state);

  /**********
  Restriction
  **********/
  modifier creatorOnly(){
    if (msg.sender != _creator) throw;
    _;
  }

  /**********
  Constructor
  **********/
  function TCI_Contract (bytes32 idTransaction, bytes32 amount, bytes32 currency){
      //Initialisation
      _creator = msg.sender;
      TCI.IdTransaction = idTransaction;
      TCI.amount = amount;
      TCI.currency = currency;
  }

  /**********
  Set StatusPayement
  **********/
  function SetStatusPayement (bool value){
    TCI.sellerGotPaid = value;
  }

  /**********
  Default Payement
  **********/
  // IsVerified is for the decision that we put brut
  function defaultPayment(bool IsVerified) creatorOnly(){
    if(IsVerified){
        //Payement in ether
        /*if (!_seller.adresse.send(TCI.amount)){
            throw;
            return false;
        }
        else {
            sendAmount(_seller.adresse, TCI.amount);
            return true;
        }*/
        TCI.IsInDefault = true;
        //InDefault("Your claim has been sent.");
        //update();
    }
    else{
        //InDefault("Sorry but the payement has been sent.");
    }
  }

  /**********
  Display contract
  **********/
  function displayContractTCI() public constant returns (bool, bytes32, bytes32, bytes32){
      return(TCI.IsInDefault, TCI.IdTransaction, TCI.amount, TCI.currency);
  }

  /**********
  Call the API
  **********/
  /*function __callback(bytes32 myid, string result) { //Get the response of oraclize
    if (msg.sender != oraclize_cbAddress()) throw;
    InDefault("You were recovered.");
    TCI.IsRecovered = true;
  }
  function update() payable { //Oraclize query, /!\ Payable
    InDefault("Your claim has been sent.");
    string memory link = strConcat("json(https://api-demo.single-invoice.co/v2.0/coverage/:", TCI.IdTransaction, "/claim/attachments)");
    oraclize_query("URL", link); // /!\API key ?? I have to mention that
  }*/

  /**********
  Self destruct
  **********/
  function kill() creatorOnly() {
      //with return the ether to the creator
      suicide(_creator);
  }


}
