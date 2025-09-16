// LiquidityManager.tact
// Adds liquidity and forwards LP to Locker

contract LiquidityManager {
  owner: Address;
  locker: Address;
  lpAllowed: map<Address, Bool>;

  init(owner: Address, locker: Address, lpList: map<Address, Bool>) {
    self.owner = owner;
    self.locker = locker;
    self.lpAllowed = lpList;
  }

  // receive JettonTransfer (LP or quote)
  receive(msg: JettonTransfer) {
    if (self.lpAllowed.get(msg.jetton).getOrElse(false)) {
      // forward LP to locker
      let fwd = JettonTransfer{
        jetton: msg.jetton,
        amount: msg.amount,
        from: myAddress(),
        to: self.locker,
        response_destination: self.locker,
        custom_payload: null
      };
      send(fwd, 0);
      emit("LP_SENT_TO_LOCKER", msg.jetton, msg.amount);
    } else {
      emit("JETTON_IN", msg.jetton, msg.amount, msg.from);
    }
  }
}
