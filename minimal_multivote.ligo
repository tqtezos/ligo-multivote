(* minimal-multivote *)

type param is 
  | Submit of nat * address  //TODO: add expiration timestamp 
  | Vote of nat * bool


type pending_action is record
  action: address;
  votes: set(address);
end

type auth is record 
  threshold: nat;
  voters: set(address);
end

type storage_type is record
  action_count: nat;
  voters: auth;
  pending_actions: map(nat, pending_action)
end

function main(const p: param; const stotage: unit): (list(operation) * unit) is
  block { skip } with ((nil: list(operation)), unit)