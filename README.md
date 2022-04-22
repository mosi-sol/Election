# Election
**election** is important for *democracy* in the world. at all every where you can find usecase, for example:
- facebook made by the idea for voting system between two different chicks... :) {by this idea zakerburg start to grow}

### Info:
- *Each update create a new Version, like* -> **`Ver2xx.sol`**
- type ver 1x not reacheable to upgrade, this is just for training how to logic work.
- `Ver2xx.sol` is upgradable.

#

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

---

15-04-2022 friday live course

ver 2 - part 1
##
