pragma solidity ^0.8.10;

interface Interface {
    struct CompBalanceMetadata { uint256 a; uint256 b; address c; }
    struct CTokenUnderlyingPrice { address a; uint256 b; }
    struct CTokenMetadata { address a; uint256 b; uint256 c; uint256 d; uint256 e; uint256 f; uint256 g; uint256 h; uint256 i; bool j; uint256 k; address l; uint256 m; uint256 n; }
    struct AccountLimits { address[] a; uint256 b; uint256 c; }
    struct CTokenBalances { address a; uint256 b; uint256 c; uint256 d; uint256 e; uint256 f; }

    function cTokenBalances(address cToken, address account) external returns (CTokenBalances memory);
    function cTokenBalancesAll(address[] memory cTokens, address account) external returns ((address,uint256,uint256,uint256,uint256,uint256)[] memory);
    function cTokenMetadata(address cToken) external returns (CTokenMetadata memory);
    function cTokenMetadataAll(address[] memory cTokens) external returns ((address,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,bool,uint256,address,uint256,uint256)[] memory);
    function cTokenUnderlyingPrice(address cToken) external returns (CTokenUnderlyingPrice memory);
    function cTokenUnderlyingPriceAll(address[] memory cTokens) external returns ((address,uint256)[] memory);
    function getAccountLimits(address comptroller, address account) external returns (AccountLimits memory);
    function getCompBalanceMetadata(address comp, address account) view external returns (CompBalanceMetadata memory);
    function getCompVotes(address comp, address account, uint32[] memory blockNumbers) view external returns ((uint256,uint256)[] memory);
    function getGovProposals(address governor, uint256[] memory proposalIds) view external returns ((uint256,address,uint256,address[],uint256[],string[],bytes[],uint256,uint256,uint256,uint256,bool,bool)[] memory);
    function getGovReceipts(address governor, address voter, uint256[] memory proposalIds) view external returns ((uint256,bool,bool,uint96)[] memory);
}

