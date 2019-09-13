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
//const nops: list(operation) = nil

function vote(const s: storage_t; const vote: nat * bool): ret_type is
  block {
    skip
  } with ((nil: list(operation)), s)

function append_action(const s: storage_t): storage_t is
  block {
    skip;
  } with s

function submit(const s: storage_t; const a: action): ret_type is
  var ss: storage_t := s
  block {
    if s.action_count =/= a.id
    then fail("invalid submittted action id")
    else ss := append_action(s)
  } with ((nil: list(operation)), ss)


#include "minimal_multivote_mock.ligo"

function s(const p: param): ret_type is
  block { skip  } with case p of
    | Vote(v)   -> vote(init_storage, v)
    | Submit(a) -> submit(init_storage, a)
  end

function main(const p: param; const stotage: storage_t): ret_type is
  block { skip } with case p of
    | Vote(v)   -> vote(init_storage, v)
    | Submit(a) -> submit(init_storage, a)
  end
