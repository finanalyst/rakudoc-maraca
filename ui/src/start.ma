{
  #title(Rakudoc),
  responses: [],
  query: "type name of routine in here",
  #docserver | [#docserver, : responses?] -> responses?,
  [
    gap: 15,
    pad: 20,
    "Query:  ",
    [
      fill: 0 0 (focus?, 80, => 90),
      pad: 10,
      gap: 20,
      input: query?,
      focus? | "" -> query?,
      enter? | [routine: query?] -> #docserver,
      enter? | "" -> query?,
    ],
    Documentation\:,
    responses?
    .[
      resp=>>
        (
          resp? doc,
          [
            style: left bold,
            gap: 10,
            pad: 2 20,
            fill: colors?."C 0",
            color: colors?."P 0",
            round: 20,
            [
              style: left bold,
              resp? type,
              '.',
              resp? routine,
              [
                pad: 2 30,
                round: 5,
                style: normal,
                fill: colors?."S1 0",
                color: colors?."P 0",
                resp? doc,
              ],
            ],
          ],
        ),
    ],
    Responses\:,
    responses?
    .[
      resp=>>
        (
          !resp? doc,
          [
            style: left bold,
            gap: 10,
            pad: 2 20,
            fill: colors?."C 0",
            color: colors?."P 0",
            round: 20,
            dtypes: resp?.types,
            rtn: resp? routine,
            [
              style: left bold,
              rtn?,
              dtypes?
              .[
                dtype=>>
                  [
                    pad: 2 30,
                    fill: colors?."P 0",
                    color: colors?."C 0",
                    round: 5,
                    dtype?,
                    click? | [routine: rtn?, type: dtype?] -> #docserver,
                  ],
              ],
            ],
          ],
        ),
    ],
  ],
}