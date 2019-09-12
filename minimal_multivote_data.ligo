#include "addresses.ligo"
#include "minimal_multivote.ligo"


/*
"
Submit( 4n,
(\"tz1LMJmzJuoM3AFEgPoQ2kEoPfj9FyskTZpS\": address)
)
"
*/

/*
"Vote(4n, True)"
*/



function param_echo(const p: param): param is
  block { skip } with p

function storage_echo(const p: storage_t): storage_t is
  block { skip } with p