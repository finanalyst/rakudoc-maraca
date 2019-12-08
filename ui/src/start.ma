{
  #title(Rakudoc),
  search: ,
  [
    style: bold,
    x: 500,
    gap: 10,
    pad: 20,
    color: colors?.P_0,
    fill: colors?.C_0,
    [style: bold, Search for\:],
    fill: colors?.S1_0,
    input: new? enter? | new? -> #docserver,
    enter? | "" -> new?,
  ],
  [color: colors?.C_0, fill: colors?.S2_0, #docserver.searched],
  [color: colors?.P_0, fill: colors?.S1_0, #docserver.found],
}