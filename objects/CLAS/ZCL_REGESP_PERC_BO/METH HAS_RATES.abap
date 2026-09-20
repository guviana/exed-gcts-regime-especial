  METHOD has_rates.

    rv_exists = xsdbool( get_rates( iv_ncm           = iv_ncm
                                    iv_cest          = iv_cest
                                    iv_material_group = iv_material_group
                                    iv_material      = iv_material
                                    iv_key_date      = iv_key_date ) IS NOT INITIAL ).

  ENDMETHOD.