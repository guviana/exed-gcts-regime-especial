  METHOD if_gslog_ext_tax_calc_payload~extend_payload.

    DATA: lv_cest      TYPE zr_regespperc-Cest,
          lv_bruto     TYPE p LENGTH 15 DECIMALS 2,
          lv_base_mva  TYPE p LENGTH 15 DECIMALS 2,
          lv_bus_trans TYPE string,
          lv_usage     TYPE string,
          lv_ship_to   TYPE string.

      IF zcl_regesp_plant_bo=>is_enabled( pricing_item-werks ) = abap_true.
        IF pricing_item-mvgr4 = '001'.

          "verifica se cliente está marcado como regime especial, se for pular instrucao
          SELECT SINGLE YY1_RegimeEspecial_bus
          FROM I_BusinessPartner
          WITH PRIVILEGED ACCESS
          WHERE BusinessPartner = @pricing_header-kunnr
          INTO  @DATA(lv_regesp_cli).

          CHECK lv_regesp_cli <> 'X'.

          READ TABLE payload-_items ASSIGNING FIELD-SYMBOL(<fs_item>) WITH KEY id = pricing_item-kposn.
          IF sy-subrc = 0.
            READ TABLE <fs_item>-item_classifications ASSIGNING FIELD-SYMBOL(<fs_item_class>) WITH KEY isc_system_code = 'cest'.
            IF sy-subrc = 0.
              lv_cest = <fs_item_class>-isc_code.
            ENDIF.

*            READ TABLE <fs_item>-additional_item_information ASSIGNING FIELD-SYMBOL(<fs_add_info>) WITH KEY type = 'custom_regEspNetPrice'.
*            IF sy-subrc = 0.
*              lv_bruto = <fs_add_info>-information.
*            ENDIF.
            lv_bruto = <fs_item>-unit_price.

            READ TABLE <fs_item>-additional_item_information INTO DATA(ls_add_info) WITH KEY type = 'custom_regEspMvaBaseAmt'.
            IF sy-subrc = 0.
              DATA(lv_index) = sy-tabix.
              lv_base_mva = ls_add_info-information.
              "remove indice custom, nao deve ir para avalara so eh usado para passar valores entre as exits.
              DELETE <fs_item>-additional_item_information INDEX lv_index.
            ENDIF.

            READ TABLE <fs_item>-additional_item_information INTO ls_add_info WITH KEY type = 'businessTransaction'.
            IF sy-subrc = 0.
              lv_bus_trans = ls_add_info-information.
            ENDIF.

            READ TABLE <fs_item>-additional_item_information  INTO ls_add_info  WITH KEY type = 'usage'.
            IF sy-subrc = 0.
              lv_usage = ls_add_info-information.
            ENDIF.

            READ TABLE payload-_locations ASSIGNING FIELD-SYMBOL(<fs_ship_to>) WITH KEY type = 'SHIP_TO'.
            IF sy-subrc = 0.
              lv_ship_to = <fs_ship_to>-state.
            ENDIF.
          ENDIF.

          IF ( lv_bus_trans = 'S003' OR lv_bus_trans = 'S004' OR lv_bus_trans = 'S006' )    "Business Transaction IN (S003,S004,S006)
          AND lv_usage = 'R'                                                                "usage = R
          AND lv_ship_to = 'PR'.                                                            "somente clientes do Parana (ship_to = PR)

            " percentuais vigentes hoje, com material específico
            DATA(ls_rates) = zcl_regesp_perc_bo=>get_rates( iv_ncm            = pricing_item-steuc
                                                            iv_cest           = lv_cest
                                                            iv_material_group = pricing_item-mvgr4
                                                            iv_material       = pricing_item-matnr ).
            IF ls_rates IS NOT INITIAL.
              DATA(lv_calc_result) = zcl_regesp_perc_bo=>calculate_base( iv_gross    = lv_bruto
                                                                         iv_mva_base = lv_base_mva
                                                                         is_rates    = ls_rates ).

              IF lv_calc_result < lv_bruto. "unitPrice
                DATA(lv_icms_st_liquido) = zcl_regesp_perc_bo=>calculate_icsm_st_liquido( iv_invoice_amount = lv_calc_result
                                                                                          iv_last_nf_cost   = lv_base_mva
                                                                                          is_rates          = ls_rates ).

                IF lv_icms_st_liquido > 0.
                  <fs_item>-unit_price = lv_calc_result.
                ENDIF.
              ENDIF.
            ENDIF.

          ENDIF.
        ENDIF.
      ENDIF.

  ENDMETHOD.