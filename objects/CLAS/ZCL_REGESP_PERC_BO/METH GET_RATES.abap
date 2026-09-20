  METHOD get_rates.

    IF iv_ncm IS INITIAL OR iv_cest IS INITIAL OR iv_material_group IS INITIAL.
      RETURN.
    ENDIF.

    DATA(lv_key_date) = resolve_key_date( iv_key_date ).

    " Material em branco < qualquer material preenchido, portanto o ORDER BY
    " descendente coloca o registro específico antes do registro do grupo.
    " Em seguida, a vigência mais recente que já começou.
    SELECT FROM zr_regespperc
      FIELDS ncm             AS ncm,
             cest            AS cest,
             materialgroup           AS material_group,
             Material           AS material,
             ValidityBegin   AS validity_begin,
             InternalTaxRate AS internal_tax_rate,
             DeferralRate    AS deferral_rate,
             MVARate         AS mva_rate
      WHERE ncm             =  @iv_ncm
        AND cest            =  @iv_cest
        AND materialgroup           =  @iv_material_group
        AND Material           IN ( @iv_material, @space )
        AND ValidityBegin   <= @lv_key_date
*      ORDER BY material DESC, validity_begin DESC
      INTO TABLE @DATA(lt_entries)
      UP TO 1 ROWS.

    IF lt_entries IS NOT INITIAL.
      SORT lt_entries BY material DESCENDING validity_begin DESCENDING.
      rs_rates = lt_entries[ 1 ].
    ENDIF.

  ENDMETHOD.