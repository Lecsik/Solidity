
/**
 * This file was generated by TONDev.
 * TONDev is a part of TON OS (see http://ton.dev).
 */
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

// This is class that describes you smart contract.
contract nft_token {
   
    struct TokenBook {
        string nameOfBook;    
        uint numberOfPages;
        uint price;

    }

    TokenBook[] tokensArr;
    mapping (uint=>uint) tokenToOwner;

        modifier checkTokenOwnerAndAccept(uint tokenId) {

        require(msg.pubkey() == tokenToOwner[tokenId], 101);

		tvm.accept();
		_;
	}

    function createTokenBook(string nameOfBook, uint numberOfPages ) public {
        tvm.accept();
        
        uint count = 0;
        for (uint index = 0; index < (uint)(tokensArr.length); index++) {
            if(tokensArr[index].nameOfBook == nameOfBook) count++;
        }
        require((count == 0), 101);
        
        tokensArr.push(TokenBook(nameOfBook, numberOfPages, 0));
        uint keyAsLastNum = tokensArr.length -1;
        tokenToOwner[keyAsLastNum] = msg.pubkey();
      
    }

   function getTokenOwner(uint tokenId) public view returns (uint){
       return tokenToOwner[tokenId];
   }

    function getTokenInfo(uint tokenId) public view returns (string tokenNameOfBook, uint tokenNumberOfPages, uint tokenPrice ){
        tokenNameOfBook = tokensArr[tokenId].nameOfBook;
        tokenNumberOfPages = tokensArr[tokenId].numberOfPages;
        tokenPrice = tokensArr[tokenId].price;
    }

    function changeOwner(uint tokenId, uint pubKeyOfNewOwner) public  checkTokenOwnerAndAccept(tokenId){

        tokenToOwner[tokenId] = pubKeyOfNewOwner;
    }

        function changeNameOfBook(uint tokenId, string nameOfBook) public  checkTokenOwnerAndAccept(tokenId){
        tokensArr[tokenId].nameOfBook = nameOfBook;
    }

        function changeNumberOfPages(uint tokenId, uint numberOfPages) public checkTokenOwnerAndAccept(tokenId){
        tokensArr[tokenId].numberOfPages = numberOfPages;
    }

   ////выставить токен на продажу         
        function setPrice(uint tokenId, uint price) public checkTokenOwnerAndAccept(tokenId){
        tokensArr[tokenId].price = price;
    }



    // Contract can have a `constructor` – function that will be called when contract will be deployed to the blockchain.
    // In this example constructor adds current time to the instance variable.
    // All contracts need call tvm.accept(); for succeeded deploy
    constructor() public {
        // Check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and
        // message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        // The current smart contract agrees to buy some gas to finish the
        // current transaction. This actions required to process external
        // messages, which bring no value (henceno gas) with themselves.
        tvm.accept();

      
    }
}