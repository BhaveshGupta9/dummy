*&---------------------------------------------------------------------*
*& Calling method integration (excerpt)
*&---------------------------------------------------------------------*

METHOD get_parts_lookup_data.

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
      it_plant_lgort = gt_plant_lgort
    IMPORTING
      et_slt         = DATA(lt_slt)
  ).

  lt_result = VALUE #(
    FOR result IN lt_result
    LET slt = VALUE ty_slt(
          lt_slt[ matnr = result-matnr ] OPTIONAL
        )
    IN
    (
      VALUE #( BASE result
        slt = COND char35(
                WHEN result-esd = gc_slt-no_esd
                 AND result-status = gc_status_active
                 AND slt-matnr IS NOT INITIAL
                THEN COND #( WHEN lt_mvke[ matnr = result-matnr OPTIONAL ]-mtpos = 'ZBNS'
                             THEN |Dropship - { slt-slt }|
                             ELSE slt-slt )
                ELSE result-slt )
        esd = COND #( WHEN result-esd = gc_slt-no_esd
                       AND result-status = gc_status_active
                       AND slt-matnr IS NOT INITIAL
                      THEN space
                      ELSE result-esd )
      )
    )
  ).

ENDMETHOD.
