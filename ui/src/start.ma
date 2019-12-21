{
  #title(Rakudoc),
  queries: [],
  responses: [],
  query: "type name of routine in here",
  #docserver | [#docserver, : responses?] -> responses?,
  [
    x: 1000,
    gap: 15,
    [
      pad: 10,
      fill: 0 0 (focus?, 80, => 90),
      input: query?,
      focus? | "" -> query?,
      enter? | [routine: query?] -> #docserver,
      enter? | [query?, : queries?] -> queries?,
      enter? | "New routine name?" -> value?,
    ],
    Queries\:,
    queries?.[x=>> [style: bullet, x?]],
    Responses\:,
    responses?
    .[
      x=>>
        [
          style: bullet,
          x? type,
          _,
          [
            style: bold flow,
            fill: colors?."C 0",
            color: colors?."P 0",
            x? type,
            \.,
            x? routine,
          ],
        ],
    ],
  ],
}