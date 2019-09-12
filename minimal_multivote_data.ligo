#include "addresses.ligo"
#include "minimal_multivote.ligo"


function submit_p(const p: nat): param is
  block { skip } with Submit(p, jane)

function get_s(const p: unit): unit is
  block { skip } with unit