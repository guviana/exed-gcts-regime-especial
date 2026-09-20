  METHOD calculate_icsm_st_liquido.

    CLEAR: ev_icms_proprio,
           ev_base_icms_st,
           ev_icms_st_bruto.

    " Percentuais gravados como 18,00000 (= 18%) -> fração
    DATA(lv_tax_rate) = to_fraction( is_rates-internal_tax_rate ).
    DATA(lv_deferral) = to_fraction( is_rates-deferral_rate ).
    DATA(lv_mva)      = to_fraction( is_rates-mva_rate ).

    " ICMS Proprio = Valor de NF * AliqIterICMS * ( 1 - Difer )
    ev_icms_proprio = round( val  = CONV decfloat34( iv_invoice_amount )
                                  * lv_tax_rate
                                  * ( 1 - lv_deferral )
                             dec  = iv_decimals
                             mode = cl_abap_math=>round_half_up ).

    " Base Calculo ICMS-ST = Custo Ultima NF Entrada * ( 1 + MVA )
    ev_base_icms_st = round( val  = CONV decfloat34( iv_last_nf_cost ) * ( 1 + lv_mva )
                             dec  = iv_decimals
                             mode = cl_abap_math=>round_half_up ).

    " ICMS-ST Bruto = Base Calculo ICMS-ST * AliqIterICMS
    ev_icms_st_bruto = round( val  = CONV decfloat34( ev_base_icms_st ) * lv_tax_rate
                              dec  = iv_decimals
                              mode = cl_abap_math=>round_half_up ).

    " ICMS-ST Liquido = ICMS-ST Bruto - ICMS Proprio
    rv_icms_st_liquido = ev_icms_st_bruto - ev_icms_proprio.

  ENDMETHOD.