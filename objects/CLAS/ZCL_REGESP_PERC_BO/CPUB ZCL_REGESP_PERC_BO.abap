CLASS zcl_regesp_perc_bo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES ty_amount TYPE p LENGTH 15 DECIMALS 2.

    TYPES: BEGIN OF ty_rates,
             ncm               TYPE zr_regespperc-ncm,
             cest              TYPE zr_regespperc-cest,
             material_group    TYPE zr_regespperc-materialgroup,
             material          TYPE zr_regespperc-material,
             validity_begin    TYPE datbi,
             internal_tax_rate TYPE ztbregespperc-internal_tax_rate,
             deferral_rate     TYPE ztbregespperc-deferral_rate,
             mva_rate          TYPE ztbregespperc-mva_rate,
           END OF ty_rates.

    TYPES ty_rates_tab TYPE STANDARD TABLE OF ty_rates WITH EMPTY KEY.

    "! Retorna os percentuais vigentes para a combinação informada.
    "! Prioriza o registro do material específico; não havendo, cai para o
    "! registro do grupo (material em branco). Entre vários registros
    "! válidos, devolve o de data de início mais recente.
    "! @parameter iv_material | Opcional - em branco usa apenas a regra do grupo
    "! @parameter iv_key_date | Data de referência (default: data do sistema)
    "! @parameter rs_rates    | Percentuais encontrados (vazio se não houver)
    CLASS-METHODS get_rates
      IMPORTING iv_ncm            TYPE zr_regespperc-ncm
                iv_cest           TYPE zr_regespperc-cest
                iv_material_group TYPE zr_regespperc-materialgroup
                iv_material       TYPE matnr OPTIONAL
                iv_key_date       TYPE datum  OPTIONAL
      RETURNING VALUE(rs_rates)   TYPE ty_rates.

    "! Verifica se existe percentual cadastrado para a combinação informada
    CLASS-METHODS has_rates
      IMPORTING iv_ncm            TYPE zr_regespperc-ncm
                iv_cest           TYPE zr_regespperc-cest
                iv_material_group TYPE zr_regespperc-materialgroup
                iv_material       TYPE zr_regespperc-material OPTIONAL
                iv_key_date       TYPE datum  OPTIONAL
      RETURNING VALUE(rv_exists)  TYPE abap_bool.

    "! Retorna todo o histórico de percentuais da combinação informada,
    "! da vigência mais recente para a mais antiga
    CLASS-METHODS get_history
      IMPORTING iv_ncm            TYPE zr_regespperc-ncm
                iv_cest           TYPE zr_regespperc-cest
                iv_material_group TYPE zr_regespperc-materialgroup
                iv_material       TYPE zr_regespperc-material OPTIONAL
      RETURNING VALUE(rt_rates)   TYPE ty_rates_tab.

    "! Calcula a base reduzida a partir dos percentuais informados.
    "!
    "!   base = MIN( ( bruto - base_mva * ( 1 + mva ) * aliquota )
    "!               / ( 1 - aliquota * ( 1 - diferimento ) ) ,
    "!               bruto )
    "!
    "! @parameter iv_gross    | Valor bruto
    "! @parameter iv_mva_base | Base de cálculo da MVA
    "! @parameter is_rates    | Percentuais (GET_RATES)
    "! @parameter iv_decimals | Casas decimais do arredondamento final
    "! @parameter rv_base     | Base calculada, limitada ao valor bruto
    CLASS-METHODS calculate_base
      IMPORTING iv_gross       TYPE ty_amount
                iv_mva_base    TYPE ty_amount
                is_rates       TYPE ty_rates
                iv_decimals    TYPE i DEFAULT 2
      RETURNING VALUE(rv_base) TYPE ty_amount.

    "! Calcula o ICMS-ST líquido e os valores intermediários.
    "!
    "!   ICMS Proprio       = Valor de NF * AliqIterICMS * ( 1 - Difer )
    "!   Base Calculo ST    = Custo Ultima NF Entrada * ( 1 + MVA )
    "!   ICMS-ST Bruto      = Base Calculo ST * AliqIterICMS
    "!   ICMS-ST Liquido    = ICMS-ST Bruto - ICMS Proprio
    "!
    "! @parameter iv_invoice_amount  | Valor de NF
    "! @parameter iv_last_nf_cost    | Custo da última NF de entrada
    "! @parameter is_rates           | Percentuais vigentes (GET_RATES)
    "! @parameter iv_decimals        | Casas decimais do arredondamento
    "! @parameter iv_clamp_negative  | abap_true zera resultado negativo
    "! @parameter ev_icms_proprio    | ICMS próprio
    "! @parameter ev_base_icms_st    | Base de cálculo do ICMS-ST
    "! @parameter ev_icms_st_bruto   | ICMS-ST bruto
    "! @parameter rv_icms_st_liquido | ICMS-ST líquido
    CLASS-METHODS calculate_icsm_st_liquido
      IMPORTING iv_invoice_amount         TYPE ty_amount
                iv_last_nf_cost           TYPE ty_amount
                is_rates                  TYPE ty_rates
                iv_decimals               TYPE i         DEFAULT 2
      EXPORTING ev_icms_proprio           TYPE ty_amount
                ev_base_icms_st           TYPE ty_amount
                ev_icms_st_bruto          TYPE ty_amount
      RETURNING VALUE(rv_icms_st_liquido) TYPE ty_amount.