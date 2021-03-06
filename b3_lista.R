b3_acoes<-tibble::tribble(
   ~Código,          ~Ação,       ~Tipo,  ~Qtde..Teórica, ~`Part..(%)`,
   "RRRP3", "3R PETROLEUM",     "ON NM",   "200.372.163",      "0,388",
   "ALPA4",   "ALPARGATAS",     "PN N1",   "201.257.220",      "0,212",
   "ABEV3",    "AMBEV S/A",        "ON", "4.380.195.841",      "3,170",
   "AMER3",   "AMERICANAS",     "ON NM",   "596.875.824",      "0,429",
   "ASAI3",        "ASSAI",     "ON NM",   "794.531.367",      "0,622",
   "AZUL4",         "AZUL",     "PN N2",   "327.741.172",      "0,228",
   "B3SA3",           "B3", "ON EDJ NM", "5.987.625.321",      "3,573",
   "BPAN4",    "BANCO PAN",     "PN N1",   "341.124.068",      "0,114",
   "BBSE3", "BBSEGURIDADE",     "ON NM",   "671.629.692",      "0,915",
   "BRML3", "BR MALLS PAR",     "ON NM",   "828.273.884",      "0,337",
   "BBDC3",     "BRADESCO",  "ON EJ N1", "1.516.726.535",      "1,213",
   "BBDC4",     "BRADESCO",  "PN EJ N1", "5.160.570.290",      "4,947",
   "BRAP4",    "BRADESPAR",     "PN N1",   "251.402.249",      "0,355",
   "BBAS3",       "BRASIL",     "ON NM", "1.420.530.937",      "2,528",
   "BRKM5",      "BRASKEM",    "PNA N1",   "264.975.728",      "0,560",
   "BRFS3",       "BRF SA",     "ON NM", "1.076.512.610",      "0,834",
  "BPAC11",   "BTGP BANCO",    "UNT N2", "1.301.655.996",      "1,573",
   "CRFB3", "CARREFOUR BR",  "ON EJ NM",   "410.988.561",      "0,362",
   "CCRO3",       "CCR SA",     "ON NM", "1.115.693.556",      "0,771",
   "CMIG4",        "CEMIG",  "PN EJ N1", "1.448.479.060",      "0,823",
   "CIEL3",        "CIELO",     "ON NM", "1.144.359.228",      "0,236",
   "COGN3",     "COGNA ON",     "ON NM", "1.828.106.676",      "0,211",
   "CPLE6",        "COPEL",    "PNB N2", "1.563.365.506",      "0,585",
   "CSAN3",        "COSAN",     "ON NM", "1.171.063.698",      "1,175",
   "CPFE3", "CPFL ENERGIA",     "ON NM",   "187.732.538",      "0,316",
   "CMIN3", "CSNMINERACAO",     "ON N2", "1.120.593.365",      "0,251",
   "CVCB3",   "CVC BRASIL",     "ON NM",   "224.231.429",      "0,093",
   "CYRE3", "CYRELA REALT",     "ON NM",   "281.609.283",      "0,176",
   "DXCO3",        "DEXCO",     "ON NM",   "295.712.871",      "0,162",
   "ECOR3",  "ECORODOVIAS",     "ON NM",   "339.237.914",      "0,104",
   "ELET3",   "ELETROBRAS",     "ON N1",   "985.704.248",      "2,404",
   "ELET6",   "ELETROBRAS",    "PNB N1",   "242.987.127",      "0,594",
   "EMBR3",      "EMBRAER",     "ON NM",   "734.588.205",      "0,476",
   "ENBR3",  "ENERGIAS BR",     "ON NM",   "230.931.405",      "0,255",
  "ENGI11",     "ENERGISA",    "UNT N2",   "248.477.689",      "0,552",
   "ENEV3",        "ENEVA",     "ON NM", "1.257.479.978",      "1,033",
   "EGIE3", "ENGIE BRASIL",     "ON NM",   "255.217.329",      "0,567",
   "EQTL3",   "EQUATORIAL",     "ON NM", "1.100.513.485",      "1,330",
   "EZTC3",        "EZTEC",     "ON NM",   "101.618.236",      "0,079",
   "FLRY3",       "FLEURY",     "ON NM",   "303.373.882",      "0,228",
   "GGBR4",       "GERDAU",     "PN N1", "1.097.534.498",      "1,375",
   "GOAU4",   "GERDAU MET",     "PN N1",   "698.275.321",      "0,370",
   "GOLL4",          "GOL",     "PN N2",   "167.095.214",      "0,087",
   "NTCO3", "GRUPO NATURA",     "ON NM",   "834.914.221",      "0,629",
   "SOMA3",   "GRUPO SOMA",     "ON NM",   "489.316.435",      "0,245",
   "HAPV3",      "HAPVIDA",     "ON NM", "4.454.692.382",      "1,245",
   "HYPE3",       "HYPERA",  "ON EJ NM",   "410.253.528",      "0,841",
  "IGTI11", "IGUATEMI S.A",    "UNT N1",   "180.013.980",      "0,177",
   "IRBR3", "IRBBRASIL RE",     "ON NM", "1.255.286.531",      "0,148",
   "ITSA4",       "ITAUSA",     "PN N1", "4.736.140.654",      "2,188",
   "ITUB4", "ITAUUNIBANCO",     "PN N1", "4.781.077.143",      "5,968",
   "JBSS3",          "JBS",     "ON NM", "1.290.736.673",      "2,288",
   "JHSF3",    "JHSF PART",     "ON NM",   "305.915.142",      "0,102",
  "KLBN11",   "KLABIN S/A",    "UNT N2",   "812.994.397",      "0,881",
   "RENT3",     "LOCALIZA",     "ON NM",   "594.670.317",      "1,645",
   "LCAM3",   "LOCAMERICA",  "ON EJ NM",   "321.385.288",      "0,404",
   "LWSA3",      "LOCAWEB",     "ON NM",   "418.965.264",      "0,132",
   "LREN3", "LOJAS RENNER",  "ON EJ NM",   "977.821.540",      "1,182",
   "MGLU3",  "MAGAZ LUIZA",     "ON NM", "2.896.234.638",      "0,369",
   "MRFG3",      "MARFRIG",     "ON NM",   "348.234.011",      "0,245",
   "CASH3",       "MELIUZ",     "ON NM",   "548.153.725",      "0,034",
   "BEEF3",      "MINERVA",     "ON NM",   "260.409.710",      "0,198",
   "MRVE3",          "MRV",  "ON ED NM",   "294.647.234",      "0,116",
   "MULT3",    "MULTIPLAN",  "ON EJ N2",   "272.718.548",      "0,333",
   "PCAR3", "P.ACUCAR-CBD",     "ON NM",   "156.946.474",      "0,142",
   "PETR3",    "PETROBRAS",     "ON N2", "2.706.334.382",      "4,536",
   "PETR4",    "PETROBRAS",     "PN N2", "4.566.442.248",      "6,924",
   "PRIO3",     "PETRORIO",     "ON NM",   "839.159.130",      "1,018",
   "PETZ3",         "PETZ",  "ON EJ NM",   "336.154.589",      "0,190",
   "POSI3", "POSITIVO TEC",     "ON NM",    "78.053.723",      "0,025",
   "QUAL3",    "QUALICORP",     "ON NM",   "277.027.077",      "0,188",
   "RADL3", "RAIADROGASIL",     "ON NM", "1.071.076.905",      "1,129",
   "RDOR3",    "REDE D OR",     "ON NM",   "772.010.260",      "1,169",
   "RAIL3",    "RUMO S.A.",     "ON NM", "1.216.056.103",      "1,065",
   "SBSP3",       "SABESP",     "ON NM",   "340.001.934",      "0,767",
  "SANB11", "SANTANDER BR",       "UNT",   "362.703.399",      "0,579",
   "CSNA3", "SID NACIONAL",        "ON",   "642.398.790",      "0,587",
   "SLCE3", "SLC AGRICOLA",     "ON NM",    "96.270.946",      "0,234",
  "SULA11",  "SUL AMERICA",    "UNT N2",   "283.167.854",      "0,326",
   "SUZB3",  "SUZANO S.A.",     "ON NM",   "726.779.281",      "1,923",
  "TAEE11",        "TAESA",    "UNT N2",   "218.568.234",      "0,460",
   "VIVT3", "TELEF BRASIL",        "ON",   "413.890.875",      "1,030",
   "TIMS3",          "TIM",  "ON EJ NM",   "808.619.532",      "0,544",
   "TOTS3",        "TOTVS",     "ON NM",   "519.851.955",      "0,662",
   "UGPA3",     "ULTRAPAR",     "ON NM", "1.086.067.887",      "0,738",
   "USIM5",     "USIMINAS",    "PNA N1",   "514.680.651",      "0,251",
   "VALE3",         "VALE",     "ON NM", "3.768.748.489",     "16,027",
   "VIIA3",          "VIA",     "ON NM", "1.596.295.753",      "0,178",
   "VBBR3",        "VIBRA",     "ON NM", "1.131.883.365",      "1,028",
   "WEGE3",          "WEG",  "ON EJ NM", "1.484.859.030",      "2,078",
   "YDUQ3",   "YDUQS PART",     "ON NM",   "300.833.122",      "0,219"
  )

 