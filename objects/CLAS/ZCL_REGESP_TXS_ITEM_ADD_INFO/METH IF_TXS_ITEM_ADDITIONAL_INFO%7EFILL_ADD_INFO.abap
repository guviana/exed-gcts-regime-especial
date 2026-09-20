  METHOD if_txs_item_additional_info~fill_add_info.

      " Estrutura de retorno para a tabela ct_item_additional_info
      DATA: ls_additional_info LIKE LINE OF additionalitem_information.

      " 1. Localiza o registro da condição 'ZPRS' na tabela de condições recebida por parâmetro.
      READ TABLE communicationconditionrecord
        WITH KEY conditiontype = 'ZPRS'
        ASSIGNING FIELD-SYMBOL(<fs_condition>).

      IF sy-subrc = 0.
        " 2. Preenche o nome do campo customizado esperado pela engine de taxas externa
        CLEAR ls_additional_info.
        ls_additional_info-type  = 'custom_regEspMvaBaseAmt'.

        " 3. Atribui o valor da condição convertido para string.
        IF <fs_condition>-conditionamountpercentage IS NOT INITIAL.
          ls_additional_info-information = |{ <fs_condition>-conditionamountpercentage }|.
        ENDIF.

        " 4. Insere o campo na tabela modificável de saída da BAdI
        INSERT ls_additional_info INTO TABLE additionalitem_information.
      ENDIF.

*      " 1. Localiza o registro da condição Valor Liquido (access seq. 800) na tabela de condições recebida por parâmetro.
*      READ TABLE communicationconditionrecord
*        WITH KEY accesssequence = '800'
*        ASSIGNING <fs_condition>.
*
*      IF sy-subrc = 0.
*        " 2. Preenche o nome do campo customizado esperado pela engine de taxas externa
*        CLEAR ls_additional_info.
*        ls_additional_info-type  = 'custom_regEspNetPrice'.
*
*        " 3. Atribui o valor da condição convertido para string.
*        IF <fs_condition>-conditionamountpercentage IS NOT INITIAL.
*          ls_additional_info-information = |{ <fs_condition>-conditionamountpercentage }|.
*        ENDIF.
*
*        " 4. Insere o campo na tabela modificável de saída da BAdI
*        INSERT ls_additional_info INTO TABLE additionalitem_information.
*      ENDIF.

  ENDMETHOD.