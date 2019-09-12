#include "addresses.ligo"
#include "minimal_multivote.ligo"


const submit: param = 
  Submit(4n, ("tz1LMJmzJuoM3AFEgPoQ2kEoPfj9FyskTZpS": address))

const vote: param =
  Vote(4n, True)

function param_echo(const p: param): param is
  block { skip } with p


const init_storage: storage_t =
  record
    action_count = 1n;
    voters = record
      threshold = 2n;
      voters = set [
        ("tz1VMZLCc7hRQvvHSsj377FNASJ9BnpDQPNJ": address);
        ("tz1bgkesFfKbQgnmpGvkxDSyQYs8ha6uSiuv": address);
        ("tz1Uev5FnCRhwsKweHKCApXXGgqSfLYBGvWH": address);
      ];
    end;
    pending_actions = (map []: map(nat, pending_action));
  end





function storage_echo(const p: storage_t): storage_t is
  block { skip } with p

