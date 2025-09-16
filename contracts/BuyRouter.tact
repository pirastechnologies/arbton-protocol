// BuyRouter.tact
// Main entrypoint for users

contract BuyRouter {
  owner: Address;
  manager: Address;
  arbMaster: Address;
  priceSource: Address;
  paused: Bool;

  init(owner: Address, manager: Address, arbMaster: Address, priceSource: Address) {
    self.owner = owner;
    self.manager = manager;
    self.arbMaster = arbMaster;
    self.priceSource = priceSource;
    self.paused = false;
  }

  fun setPause(p: Bool) {
    require(msg.sender() == self.owner, "not owner");
    self.paused = p;
  }

  // buy with TON
  receive() {
    require(!self.paused, "paused");
    let amountTon = msg.value();
    require(amountTon > 0, "no ton");
    let arbPerTon = get_data<Int>("arb_per_ton"); // prezzo mock
    let arbOut = (amountTon * arbPerTon) / 1_000_000_000; // scaling

    // send arbTON to user (mock, da Treasury in futuro)
    emit("ARB_SENT", msg.sender(), arbOut);

    // forward TON to manager
    send_raw(self.manager, amountTon, null);
    emit("BUY_TON", msg.sender(), amountTon, arbPerTon);
  }
}
