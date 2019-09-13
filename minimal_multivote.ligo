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


#include "minimal_multivote_mock.ligo"

function authorized(const s: storage_t): unit is
  block {
    const snd: address = mock_sender(unit);
    if not set_mem(snd, s.voters.voters) 
    then fail("Unauthorized");
    else skip;
  } with unit

function vote_action(const s: storage_t; const action: pending_action; const vote: nat*bool): ret_type is
  block { skip } with ((nil: list(operation)), s)

function vote(const s: storage_t; const vote: nat * bool): ret_type is
  var r: ret_type := ((nil: list(operation)), s)
  block {
      authorized(s);
      const pending: option(pending_action) = s.pending_actions[vote.0];
      r := case pending of
         | Some(p) -> r//vote_action(s, p, vote)
         | None    -> r//fail_no_action(r) //fail("There is no such pending action")
      end;
  } with r

function append_action(const s: storage_t; const a: address): storage_t is
  block {
    var pending: map(nat, pending_action) := s.pending_actions;
    pending[s.action_count] := record
      action = a;
      votes = (set_empty : set(address));
    end;
    s.action_count := s.action_count + 1n;
    s.pending_actions := pending;
  } with s

function submit(const s: storage_t; const a: action): ret_type is
  var ss: storage_t := s
  block {
    if s.action_count =/= a.id
    then fail("invalid submittted action id")
    else ss := append_action(s, a.target)
  } with ((nil: list(operation)), ss)


function s(const p: param): ret_type is
  block { skip  } with case p of
    | Vote(v)   -> vote(pending_storage, v)
    | Submit(a) -> submit(init_storage, a)
  end

function main(const p: param; const stotage: storage_t): ret_type is
  block { skip } with case p of
    | Vote(v)   -> vote(init_storage, v)
    | Submit(a) -> submit(init_storage, a)
  end
