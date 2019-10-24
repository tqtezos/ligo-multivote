// minimal-multivote 

//TODO: add expiration timestamp 
type action is record
  id: nat;
  target: address;
end

type vote is record
  action_id: nat;
  vote: bool;
end

type param is 
  | Submit of action  
  | Vote of vote


type pending_action is record
  target: address;
  votes: set(address);
end

type auth is record 
  threshold: nat;
  voters: set(address);
end

type storage_t is record
  action_count: nat;
  authorization: auth;
  pending_actions: map(nat, pending_action)
end

type ret_type is list(operation) * storage_t
const nops: list(operation) = nil


function assert(const cond: bool; const msg: string): unit is
  block {
     if not cond 
    then failwith("Unauthorized");
    else skip;
  } with unit


#include "minimal_multivote_mock.ligo"

function authorized(const s: storage_t): unit is
  block {
    const snd: address = mock_sender(unit);
    if not set_mem(snd, s.authorization.voters) 
    then failwith("Unauthorized");
    else skip;
  } with unit

function update_action(const s: storage_t; const id: nat; const action: pending_action): ret_type is
  block { 
    const pending: map(nat, pending_action) = s.pending_actions;
    pending[id] := action;
    s.pending_actions := pending;
   } with (nops, s)

function execute_action(const s: storage_t; const id: nat; const action: pending_action): ret_type is
  block { 
    const ct: contract(unit) = get_contract(action.target);
    const tx: operation = transaction(unit, 0mtz, ct);

    const pending: map(nat, pending_action) = s.pending_actions;
    remove id from map pending;
    s.pending_actions := pending;
   } with (list tx end, s)

function vote_action(const s: storage_t; const action: pending_action; const v: vote): ret_type is
  var ret: ret_type := (nops, s)
  block { 
    const snd: address = mock_sender(unit);
    
    if v.vote 
    then action.votes := set_add(snd, action.votes);
    else action.votes := set_remove(snd, action.votes);

    const nvotes: nat = size(action.votes);
    if nvotes < s.authorization.threshold
    then ret := update_action(s, v.action_id, action);
    else ret := execute_action(s, v.action_id, action);
  } with ret

function vote(const s: storage_t; const v: vote): ret_type is
  block {
      authorized(s);

      const pending: option(pending_action) = s.pending_actions[v.action_id];
      const r: (bool * ret_type) = case pending of
         | Some(p) -> (True, vote_action(s, p, v))
         | None    -> (False, (nops, s)) 
      end;

      if not r.0 
      then failwith("There is no such pending action");
      else skip;

  } with r.1

function append_action(const s: storage_t; const a: address): storage_t is
  block {
    var pending: map(nat, pending_action) := s.pending_actions;
    pending[s.action_count] := record
      target = a;
      votes = (set_empty : set(address));
    end;
    s.action_count := s.action_count + 1n;
    s.pending_actions := pending;
  } with s

function submit(const s: storage_t; const a: action): ret_type is
  var ss: storage_t := s
  block {
    if s.action_count =/= a.id
    then failwith("invalid submittted action id");
    else ss := append_action(s, a.target);
  } with (nops, ss)


function s(const p: param): ret_type is
  block { skip  } with case p of
    | Vote(v)   -> vote(pending_storage_1, v)
    | Submit(a) -> submit(init_storage, a)
  end

function main(const p: param; const s: storage_t): ret_type is
  block { skip } with case p of
    | Vote(v)   -> vote(s, v)
    | Submit(a) -> submit(s, a)
  end
