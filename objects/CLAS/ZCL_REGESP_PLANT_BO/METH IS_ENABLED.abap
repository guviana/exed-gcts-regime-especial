  METHOD is_enabled.

    rv_enabled = xsdbool( get_validity( iv_plant    = iv_plant
                                        iv_key_date = iv_key_date ) IS NOT INITIAL ).

  ENDMETHOD.