# Election

*Each update create a new Version, like* -> **`Ver1xx.sol`**

---

### Generate & Compaire role: 
```solidity
contract Helper {
    // senat multiuser address
    function getRoleHash(address _senat) pure external returns (bytes4 value) {
        value = bytes4(keccak256(abi.encodePacked(_senat)));
    }
}
```
**role** senatdao: `0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2` = `0x999bf575` 

#

