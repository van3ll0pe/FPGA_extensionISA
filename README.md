# FPGA_extensionISA

Réalisé par Iban Leginyora et Arthur Arnold

FPGA utilisé : sipeed tang console 138k LUT : GW5AST-138PG484AC1/I0

## Explication du projet

Le but de ce projet est d'étendre le set d'instruction du CPU RISCV en rajoutant des instructions complexes qui seront éxecutées sur la puce FPGA.
Ainsi la puce FPGA joue le rôle de co processeur permettant de limiter la charge de travail du CPU et d'améliorer la rapidité des calculs.

**L'instruction ajoutée permet de calculer le CRC-32** afin de déterminer des erreurs lui au checksum. Ainsi au lieu de créer une fonction assembleur complexe et coûteuse en cycle, le calcul et rapide et efficace.

## Comment ça fonctionne

Le CPU va devoir réaliser 2 instructions **store** dans 2 adresses spécifiques mappé en mémoire pour utiliser le protocole AXI afin que la puce FPGA puisse récupérer ces valeurs, réaliser le calcul puis enregistrer le résultat dans une adresse spécifique.

Le CPU devra ensuite **LOAD** cette valeur pour récupérer la valeur du CRC.

Ainsi au lieu d'avoir une grande suite d'instruction avec des branchements qui peuvent ralentir la suite d'éxecution du CPU avec des mauvaises prédictions qui clear le pipeline, le CPU va juste réaliser 3 instructions simples pour obtenir le résultat.

## Réalisation du projet

