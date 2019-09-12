// minimal-multivote 

//TODO: add expiration timestamp 
type action is record
  id: nat;
  target: address;
end

type param is 
  | Submit of action  
  | Vote of nat * bool


type pending_action is record
  action: address;
  votes: set(address);
end

type auth is record 
  threshold: nat;
  voters: set(address);
end

type storage_t is record
  action_count: nat;
  voters: auth;
  pending_actions: map(nat, pending_action)
end

type ret_type is list(operation) * storage_t
const noOp: list(operation) = nil

function vote(const s: storage_t; const vote: nat * bool): ret_type is
  block {
    skip
  } with (noOp, s)

function submit(const s: storage_t; const a: action): ret_type is
  block {
    skip
  } with (noOp, s)


#include "minimal_multivote_mock.ligo"

// function s(const p: param): ret_type is
//   block { skip } with (noOp, s)
  // case p of
  //   | Vote(v)   -> vote(init_storage, vote)
  //   | Submit(a) -> submit(init_storage, op)
  // end

function main(const p: unit; const stotage: unit): (list(operation) * unit) is
  block { 
    skip
   } with ((nil: list(operation)), unit)



