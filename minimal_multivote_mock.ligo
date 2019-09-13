/* 
mocking helpers.
because CLI supports only one metaparameter --amount, we will use amount to encode other mocked meta parameters
*/

//for testing purposes lets mock a sender address
//#include "addresses.ligo"

function mock_sender(const p: unit): address is
  var a: address := sender
  block {
    if amount = 1000000mtz then
      a := ("tz1VMZLCc7hRQvvHSsj377FNASJ9BnpDQPNJ": address) //alice
    else if amount = 2000000mtz then
      a := ("tz1bgkesFfKbQgnmpGvkxDSyQYs8ha6uSiuv": address) //bob
    else if amount = 3000000mtz then
      a := ("tz1Uev5FnCRhwsKweHKCApXXGgqSfLYBGvWH": address) //peter
    else if amount = 4000000mtz then
      a := ("tz1LMJmzJuoM3AFEgPoQ2kEoPfj9FyskTZpS": address) //jane
    else
      a := sender
  } with a

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

  const pending_storage: storage_t =
  record
    action_count = 2n;
    voters = record
      threshold = 2n;
      voters = set [
        ("tz1VMZLCc7hRQvvHSsj377FNASJ9BnpDQPNJ": address);
        ("tz1bgkesFfKbQgnmpGvkxDSyQYs8ha6uSiuv": address);
        ("tz1Uev5FnCRhwsKweHKCApXXGgqSfLYBGvWH": address);
      ];
    end;
    pending_actions = map [
      1n -> record
        votes = (set[]: set(address));
        target = ("tz1LMJmzJuoM3AFEgPoQ2kEoPfj9FyskTZpS": address);
      end;
    ];
  end

  const pending_storage_1: storage_t =
  record
    action_count = 2n;
    voters = record
      threshold = 2n;
      voters = set [
        ("tz1VMZLCc7hRQvvHSsj377FNASJ9BnpDQPNJ": address);
        ("tz1bgkesFfKbQgnmpGvkxDSyQYs8ha6uSiuv": address);
        ("tz1Uev5FnCRhwsKweHKCApXXGgqSfLYBGvWH": address);
      ];
    end;
    pending_actions = map [
      1n -> record
        votes = set[ ("tz1bgkesFfKbQgnmpGvkxDSyQYs8ha6uSiuv": address); ];
        target = ("tz1LMJmzJuoM3AFEgPoQ2kEoPfj9FyskTZpS": address);
      end;
    ];
  end

  function t(const p: unit): unit is block {skip} with unit