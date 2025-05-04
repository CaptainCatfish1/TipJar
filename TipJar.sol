// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TipJar - Accepts ETH and ERC20 token tips, with secure withdrawals and audit-ready structure.

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

/// @dev Minimal reentrancy guard (inspired by OpenZeppelin)
abstract contract ReentrancyGuard {
    uint256 private _locked;

    modifier nonReentrant() {
        require(_locked == 0, "ReentrancyGuard: reentrant call");
        _locked = 1;
        _;
        _locked = 0;
    }
}

contract TipJar is ReentrancyGuard {
    address public owner;

    struct Tip {
        address from;
        address token; // address(0) for ETH
        uint256 amount;
        string message;
        string handle;
        uint256 timestamp;
    }

    Tip[] public tips;

    // Track token balances: contract => token => balance
    mapping(address => mapping(address => uint256)) public balances;

    // Events
    event TipReceived(
        address indexed from,
        address indexed token,
        uint256 amount,
        string message,
        string handle,
        uint256 timestamp
    );

    event Withdrawn(
        address indexed to,
        address indexed token,
        uint256 amount,
        uint256 timestamp
    );

    event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Send ETH tip with message and handle (e.g., ENS)
    function sendTipETH(string calldata message, string calldata handle) external payable {
        require(msg.value > 0, "ETH amount must be > 0");
        balances[address(this)][address(0)] += msg.value;

        tips.push(Tip(msg.sender, address(0), msg.value, message, handle, block.timestamp));
        emit TipReceived(msg.sender, address(0), msg.value, message, handle, block.timestamp);
    }

    /// @notice Receive ETH directly without calldata
    receive() external payable {
        require(msg.value > 0, "ETH amount must be > 0");
        balances[address(this)][address(0)] += msg.value;

        tips.push(Tip(msg.sender, address(0), msg.value, "", "", block.timestamp));
        emit TipReceived(msg.sender, address(0), msg.value, "", "", block.timestamp);
    }

    /// @notice Catch invalid calldata + ETH sends
    fallback() external payable {
        require(msg.value > 0, "ETH amount must be > 0");
        balances[address(this)][address(0)] += msg.value;

        tips.push(Tip(msg.sender, address(0), msg.value, "", "", block.timestamp));
        emit TipReceived(msg.sender, address(0), msg.value, "", "", block.timestamp);
    }

    /// @notice Send ERC20 tip with message and handle
    function sendTipToken(
        address token,
        uint256 amount,
        string calldata message,
        string calldata handle
    ) external {
        require(token != address(0), "Invalid token address");
        require(amount > 0, "Amount must be > 0");

        bool success = IERC20(token).transferFrom(msg.sender, address(this), amount);
        require(success, "Token transfer failed");

        balances[address(this)][token] += amount;

        tips.push(Tip(msg.sender, token, amount, message, handle, block.timestamp));
        emit TipReceived(msg.sender, token, amount, message, handle, block.timestamp);
    }

    /// @notice Withdraw ETH tips
    function withdrawETH() external onlyOwner nonReentrant {
        uint256 amount = balances[address(this)][address(0)];
        require(amount > 0, "No ETH to withdraw");

        balances[address(this)][address(0)] = 0;
        (bool sent, ) = payable(owner).call{value: amount}("");
        require(sent, "ETH transfer failed");

        emit Withdrawn(owner, address(0), amount, block.timestamp);
    }

    /// @notice Withdraw ERC20 token tips
    function withdrawToken(address token) external onlyOwner nonReentrant {
        require(token != address(0), "Invalid token");

        uint256 amount = balances[address(this)][token];
        require(amount > 0, "No token balance");

        balances[address(this)][token] = 0;
        bool success = IERC20(token).transfer(owner, amount);
        require(success, "Token withdrawal failed");

        emit Withdrawn(owner, token, amount, block.timestamp);
    }

    /// @notice Transfer ownership to new address
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid new owner");

        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    /// @notice View all recorded tips
    function getAllTips() external view returns (Tip[] memory) {
        return tips;
    }

    /// @notice View contract-held balance for a token (or ETH via address(0))
    function contractBalance(address token) external view returns (uint256) {
        return balances[address(this)][token];
    }

    /// @notice View how many tips were recorded
    function getTipCount() external view returns (uint256) {
        return tips.length;
    }
}

/// Initial commit: TipJar
