pragma solidity 0.8.10;

// Vendor
import "forge-std/Test.sol";
import {FixedPointMathLib} from "solmate/utils/FixedPointMathLib.sol";

import {ERC20} from "solmate/tokens/ERC20.sol";
import {Comptroller} from "../interfaces/core/IComptroller.sol";
import {Unitroller} from "../interfaces/core/IUnitroller.sol";
import {CErc20} from "../interfaces/core/ICErc20.sol";
import {FuseFeeDistributor} from "../interfaces/IFuseFeeDistributor.sol";

contract PauseBorrowOverride is Test {
    Comptroller internal comptrollerImpl;

    function setUp() public {}

    function testPauseBorrowOverride() public {
        // Deploy new comptroller impl
        /*comptrollerImpl = Comptroller(
            deployCode(
                "src/core/Comptroller.sol:Comptroller"
            )
        );*/
        comptrollerImpl = Comptroller(0xE5c78fBe9F5bB3Ee2a41a6b0B0885aA3699D31cB);
        Comptroller defaultImpl = Comptroller(0xE16DB319d9dA7Ce40b666DD2E365a4b8B3C18217);

        // pool 8
        Unitroller pool8Unitroller = Unitroller(0xc54172e34046c1653d1920d40333Dd358c7a1aF4);
        Comptroller pool8Comptroller = Comptroller(0xc54172e34046c1653d1920d40333Dd358c7a1aF4);

        // fuseAdmin
        FuseFeeDistributor fuseAdmin = FuseFeeDistributor(0xa731585ab05fC9f83555cf9Bff8F58ee94e18F85);
    
        address[] memory oldImplementations = new address[](2);
        oldImplementations[0] = address(defaultImpl);
        oldImplementations[1] = address(comptrollerImpl);

        address[] memory newImplementations = new address[](2);
        newImplementations[0] = address(comptrollerImpl);
        newImplementations[1] = address(defaultImpl);

        bool[] memory statuses = new bool[](2);
        statuses[0] = true;
        statuses[1] = true;

        // Call FuseAdmin._editComptrollerImplementationWhitelist
        address fuseAdminOwner = fuseAdmin.owner();
        vm.prank(fuseAdminOwner);
        fuseAdmin._editComptrollerImplementationWhitelist(
            oldImplementations,
            newImplementations,
            statuses
        );
        require(fuseAdmin.comptrollerImplementationWhitelist(address(defaultImpl), address(comptrollerImpl)) == true);

        vm.startPrank(address(fuseAdmin.owner()));

        address[] memory targets = new address[](2);
        targets[0] = address(pool8Unitroller);
        targets[1] = address(comptrollerImpl);

        bytes[] memory data = new bytes[](2);
        data[0] = abi.encodeWithSignature("_setPendingImplementation(address)", comptrollerImpl);
        data[1] = abi.encodeWithSignature("_become(address)", address(pool8Unitroller));
        
        fuseAdmin._callPool(
            targets,
            data
        );
        
        changePrank(address(fuseAdmin));

        pool8Comptroller._setGlobalPauseBorrowOverride(true);
        console.log(pool8Comptroller._globalPauseBorrowOverride());
        
        address user = 0xB290f2F3FAd4E540D0550985951Cdad2711ac34A;
        changePrank(user);

        address DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
        CErc20 DAIf = CErc20(0x7e9cE3CAa9910cc048590801e64174957Ed41d43);
        CErc20 FEIf = CErc20(0xd8553552f8868C1Ef160eEdf031cF0BCf9686945);
        deal(DAI, user, 10000e18);
        require(DAIf.mint(10000e18) == 0, "mint failed");
        address[] memory ctokens = new address[](1);
        ctokens[0] = address(DAIf);
        pool8Comptroller.enterMarkets(ctokens);
        require(FEIf.borrow(3000e18) == 0, "borrow failed");
    }
}
