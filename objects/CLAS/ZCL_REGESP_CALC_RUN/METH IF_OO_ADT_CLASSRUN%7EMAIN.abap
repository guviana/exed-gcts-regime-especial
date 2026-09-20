  METHOD if_oo_adt_classrun~main.

    " >>> valores fixos para o teste <
    DATA(lv_ncm)      = CONV char16( '12.1.2' ).
    DATA(lv_cest)     = CONV char9( '4.5.6' ).
    DATA(lv_group)    = CONV char3( '001' ).
    DATA(lv_material) = CONV matnr( '000000000010000002' ).

    DATA(lv_bruto)    = CONV zcl_regesp_perc_bo=>ty_amount( '317.68' ).
    DATA(lv_base_mva) = CONV zcl_regesp_perc_bo=>ty_amount( '143.09' ).

    DATA(ls_rates) = zcl_regesp_perc_bo=>get_rates( iv_ncm            = lv_ncm
                                                    iv_cest           = lv_cest
                                                    iv_material_group = lv_group
                                                    iv_material       = lv_material ).

    IF ls_rates IS INITIAL.
      out->write( 'Nenhum percentual cadastrado para esta combinacao.' ).
      RETURN.
    ENDIF.

    out->write( ls_rates ).

    DATA(lv_base) = zcl_regesp_perc_bo=>calculate_base( iv_gross    = lv_bruto
                                                        iv_mva_base = lv_base_mva
                                                        is_rates    = ls_rates ).

    out->write( |Bruto          { lv_bruto }| ).
    out->write( |Base MVA       { lv_base_mva }| ).
    out->write( |Base calculada { lv_base }| ).

  ENDMETHOD.