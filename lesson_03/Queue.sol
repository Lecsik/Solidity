pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Queue {

    // Массив, хвранящий имена людей, стоящих в очереди
	 string[] public queueArray;
  
	constructor() public {
		// check that contract's public key is set
		require(tvm.pubkey() != 0, 101);
		// Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
	}

	// Modifier that allows to accept some external messages
	modifier checkOwnerAndAccept {
		// Check that message was signed with contracts key.
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}

	///Встать в очередь
	function addtoqueue(string value) public checkOwnerAndAccept {
       queueArray.push(value);
	}

    //Вызвать следующего
    	function customercall() public checkOwnerAndAccept {
            require(!queueArray.empty(), 102);
            
        for (uint i = 0; i<queueArray.length-1; i++){
            queueArray[i] = queueArray[i+1];
        }
            queueArray.pop();
        
            

	}


}