*&---------------------------------------------------------------------*
*& Calling method integration (excerpt)
*& Shows how GET_SLT is invoked after GET_ESD and how SLT is applied
*& to the OData entity response.
*&---------------------------------------------------------------------*

METHOD get_parts_lookup_data.

  DATA:
    lt_slt      TYPE ty_slt_tt,
    ls_slt      TYPE ty_slt,
    lv_slt_text TYPE string.

  " ... existing logic to build lt_matnr, lt_status, lt_mvke ...

  get_esd(
    EXPORTING
      it_matnr  = lt_matnr
      iv_kunnr  = gv_kunnr
      iv_werks  = lv_werks
      it_status = lt_status
    IMPORTING
      et_esd    = DATA(lt_esd)
  ).

  get_slt(
    EXPORTING
      it_esd         = lt_esd
      it_plant_lgort = gt_plant_lgort    " populated by SET_FIXED_VALUES
    IMPORTING
      et_slt         = lt_slt
  ).

  LOOP AT lt_result INTO DATA(ls_result).
    CLEAR ls_result-slt.

    " Only populate SLT when ESD = 'No ESD' and part is Active
    IF ls_result-esd = gc_no_esd
       AND ls_result-status = gc_status_active.

      READ TABLE lt_slt INTO ls_slt
        WITH KEY matnr = ls_result-matnr.
      IF sy-subrc = 0.

        READ TABLE lt_mvke INTO DATA(ls_mvke)
          WITH KEY matnr = ls_result-matnr.
        IF sy-subrc = 0 AND ls_mvke-mtpos = 'ZBNS'.
          " Dropship display
          lv_slt_text = |{ TEXT-dropship_prefix } - { ls_slt-slt } { TEXT-weeks_suffix }|.
          CLEAR ls_result-esd.
        ELSE.
          " Standard display
          lv_slt_text = |{ ls_slt-slt } { TEXT-weeks_suffix }|.
          CLEAR ls_result-esd.
        ENDIF.

        ls_result-slt = lv_slt_text.
      ENDIF.

    ENDIF.

    MODIFY lt_result FROM ls_result.
  ENDLOOP.

ENDMETHOD.

" Text symbols (maintain in SE38/SE80 text elements):
" TEXT-001  EN: week(s)       FR: semaine(s)
" TEXT-002  EN: Dropship      FR: Livraison directe
