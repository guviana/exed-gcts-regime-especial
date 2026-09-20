  METHOD get_validities.

    IF iv_plant IS INITIAL.
      RETURN.
    ENDIF.

    SELECT FROM zr_regespplant
      FIELDS Plant         AS plant,
             ValidityBegin AS validity_begin,
             ValidityEnd   AS validity_end
      WHERE Plant = @iv_plant
      ORDER BY validity_begin
      INTO TABLE @rt_validities.

  ENDMETHOD.