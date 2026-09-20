CLASS zcl_regesp_plant_bo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_validity,
             plant          TYPE werks_d,
             validity_begin TYPE datbi,
             validity_end   TYPE datab,
           END OF ty_validity.

    TYPES ty_validities TYPE STANDARD TABLE OF ty_validity WITH EMPTY KEY.

    "! Verifica se o centro está habilitado para Regime Especial na data informada
    "! @parameter iv_plant    | Centro
    "! @parameter iv_key_date | Data de referência (default: data do sistema)
    "! @parameter rv_enabled  | abap_true se houver vigência ativa
    CLASS-METHODS is_enabled
      IMPORTING iv_plant          TYPE werks_d
                iv_key_date       TYPE datum OPTIONAL
      RETURNING VALUE(rv_enabled) TYPE abap_bool.

    "! Retorna a vigência ativa do centro na data informada
    "! @parameter rs_validity | Vigência encontrada (vazia se não houver)
    CLASS-METHODS get_validity
      IMPORTING iv_plant           TYPE werks_d
                iv_key_date        TYPE datum OPTIONAL
      RETURNING VALUE(rs_validity) TYPE ty_validity.

    "! Retorna todas as vigências cadastradas para o centro
    CLASS-METHODS get_validities
      IMPORTING iv_plant             TYPE werks_d
      RETURNING VALUE(rt_validities) TYPE ty_validities.
