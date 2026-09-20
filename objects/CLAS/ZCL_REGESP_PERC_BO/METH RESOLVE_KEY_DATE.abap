  METHOD resolve_key_date.

    rv_date = COND #( WHEN iv_key_date IS INITIAL
                      THEN cl_abap_context_info=>get_system_date( )
                      ELSE iv_key_date ).

  ENDMETHOD.