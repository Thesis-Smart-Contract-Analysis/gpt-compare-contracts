// https://chatgpt.com/share/644d33ce-986b-4957-ab6d-d96056cfe875

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SafeRemotePurchase {
    address payable public seller;
    address payable public buyer;
    uint public value;

    enum State {
        Created,
        Locked,
        Released,
        Inactive
    }
    State public state;

    modifier onlySeller() {
        require(msg.sender == seller, "Only seller can call this function.");
        _;
    }

    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only buyer can call this function.");
        _;
    }

    modifier inState(State _state) {
        require(state == _state, "Invalid state.");
        _;
    }

    event Aborted();
    event PurchaseConfirmed();
    event ItemReceived();
    event SellerRefunded();

    constructor() payable {
        seller = payable(msg.sender);
        value = msg.value / 2;
        require((2 * value) == msg.value, "Value has to be even.");
        state = State.Created;
    }

    function confirmPurchase() external payable inState(State.Created) {
        require(
            msg.value == (2 * value),
            "Please send in 2x the value of the item."
        );
        buyer = payable(msg.sender);
        state = State.Locked;
        emit PurchaseConfirmed();
    }

    function confirmReceived() external onlyBuyer inState(State.Locked) {
        state = State.Released;
        buyer.transfer(value);
        emit ItemReceived();
    }

    function withdrawSeller() external onlySeller inState(State.Released) {
        state = State.Inactive;
        seller.transfer(3 * value);
        emit SellerRefunded();
    }

    function abort() external onlySeller inState(State.Created) {
        state = State.Inactive;
        seller.transfer(address(this).balance);
        emit Aborted();
    }
}
