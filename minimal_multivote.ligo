// minimal-multivote 

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

type storage_t is record
  action_count: nat;
  voters: auth;
  pending_actions: map(nat, pending_action)
end

function main(const p: unit; const stotage: unit): (list(operation) * unit) is
  block { 
    skip
   } with ((nil: list(operation)), unit)


function s(const p: unit): operation is
  block { 
    const a: address = "tz1LMJmzJuoM3AFEgPoQ2kEoPfj9FyskTZpS";
    const ct: contract(unit) = get_contract(a);
    const op: operation = transaction(unit, 0mtz, ct)
   } with op

/* 
mocking helpers.
because CLI supports only one metaparameter --amount, we will use amount to encode other mocked meta parameters
*/

//for testing purposes lets mock a sender address
#include "addresses.ligo"

function a_sender(const p: unit): address is
  var a: address := sender
  block {
    if amount = 1000000mtz then
      a := alice
    else if amount = 2000000mtz then
      a := bob
    else if amount = 3000000mtz then
      a := peter
    else if amount = 4000000mtz then
      a := jane
    else
      a := sender
  } with a




