// LiquidityLocker.tact
// Lock LP tokens for a fixed time

contract LiquidityLocker {
  owner: Address;
  unlock_ts: Int;
  lpAllowed: map<Address, Bool>;   // whitelist LP token masters
  totalLocked: Int;

  init(owner: Address, unlock_ts: Int, lpList: map<Address, Bool>) {
    self.owner = owner;
    self.unlock_ts = unlock_ts;
    self.lpAllowed = lpList;
    self.totalLocked = 0;
  }

  // only owner can extend unlock time
  fun setUnlock(ts: Int) {
    require(msg.sender() == self.owner, "not owner");
    require(ts >= self.unlock_ts, "only extend");
    self.unlock_ts = ts;
  }

  // receive JettonTransfer (LP tokens)
  receive(msg: JettonTransfer) {
    let lp = msg.jetton;
    require(self.lpAllowed.get(lp).getOrElse(false), "lp not allowed");
    self.totalLocked += msg.amount;
    emit("LP_LOCKED", lp, msg.amount, msg.from);
  }

  // claim LP after unlock
  fun claim(lp: Address, to: Address, amount: Int) {
    require(msg.sender() == self.owner, "not owner");
    require(now() >= self.unlock_ts, "locked");
    require(self.lpAllowed.get(lp).getOrElse(false), "lp not allowed");
    require(amount > 0, "amount=0");

    let payload = JettonTransfer{
      jetton: lp,
      amount: amount,
      from: myAddress(),
      to: to,
      response_destination: to,
      custom_payload: null
    };
    send(payload, 0);
    self.totalLocked -= amount;
    emit("LP_CLAIMED", lp, amount, to);
  }
}
