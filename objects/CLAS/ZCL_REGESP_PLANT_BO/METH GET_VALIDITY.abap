  METHOD get_validity.

    IF iv_plant IS INITIAL.
      RETURN.
    ENDIF.

    DATA(lv_key_date) = resolve_key_date( iv_key_date ).

    " A validação do BO impede sobreposição, então no máximo uma linha bate na data
    SELECT SINGLE FROM zr_regespplant
      FIELDS Plant         AS plant,
             ValidityBegin AS validity_begin,
             ValidityEnd   AS validity_end
      WHERE Plant         =  @iv_plant
        AND ValidityBegin <= @lv_key_date
        AND ValidityEnd   >= @lv_key_date
      INTO @rs_validity.

  ENDMETHOD.