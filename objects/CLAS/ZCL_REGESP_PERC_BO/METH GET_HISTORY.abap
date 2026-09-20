  METHOD get_history.

    IF iv_ncm IS INITIAL OR iv_cest IS INITIAL OR iv_material_group IS INITIAL.
      RETURN.
    ENDIF.

    SELECT FROM zr_regespperc
      FIELDS ncm             AS ncm,
             cest            AS cest,
             materialgroup           AS material_group,
             Material           AS material,
             ValidityBegin   AS validity_begin,
             InternalTaxRate AS internal_tax_rate,
             DeferralRate    AS deferral_rate,
             MVARate         AS mva_rate
      WHERE ncm         = @iv_ncm
        AND cest        = @iv_cest
        AND materialgroup       = @iv_material_group
        AND Material       IN ( @iv_material, @space )
*      ORDER BY material desc, validity_begin desc
      INTO TABLE @rt_rates.

    SORT rt_rates BY material DESCENDING validity_begin DESCENDING.

  ENDMETHOD.