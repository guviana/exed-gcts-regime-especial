  METHOD calculate_base.

    " Percentuais gravados como 18,00000 (= 18%) -> fração
    DATA(lv_tax_rate) = to_fraction( is_rates-internal_tax_rate ).
    DATA(lv_deferral) = to_fraction( is_rates-deferral_rate ).
    DATA(lv_mva)      = to_fraction( is_rates-mva_rate ).

    " Denominador: 1 - ( aliquota * ( 1 - diferimento ) )
    DATA(lv_denominator) = 1 - ( lv_tax_rate * ( 1 - lv_deferral ) ).

    IF lv_denominator = 0.
      " Alíquota 100% sem diferimento: fórmula indefinida.
      " O teto do MIN é o bruto, então devolve o bruto.
      rv_base = iv_gross.
      RETURN.
    ENDIF.

    " Numerador: bruto - ( base_mva * ( 1 + mva ) * aliquota )
    DATA(lv_numerator) = CONV decfloat34( iv_gross )
                       - ( CONV decfloat34( iv_mva_base ) * ( ( 1 + lv_mva ) * lv_tax_rate ) ).

    " Arredondamento só no final, para não acumular erro nos intermediários
    rv_base = round( val  = nmin( val1 = lv_numerator / lv_denominator
                                  val2 = CONV decfloat34( iv_gross ) )
                     dec  = iv_decimals
                     mode = cl_abap_math=>round_half_up ).

  ENDMETHOD.