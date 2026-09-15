*&---------------------------------------------------------------------*
*& Method GET_SLT
*& Supplier Lead Time calculation for YDS Parts Lookup OData service
*&---------------------------------------------------------------------*

METHOD get_slt.

  TYPES:
    BEGIN OF ty_matnr_key,
      matnr TYPE matnr,
    END OF ty_matnr_key,
    ty_matnr_tt TYPE SORTED TABLE OF ty_matnr_key WITH UNIQUE KEY matnr,
    BEGIN OF ty_marc_slt,
      matnr TYPE matnr,
      werks TYPE werks_d,
      plifz TYPE plifz,
    END OF ty_marc_slt,
    ty_marc_ht TYPE HASHED TABLE OF ty_marc_slt WITH UNIQUE KEY matnr werks.

  DATA:
    lt_matnr TYPE ty_matnr_tt,
    lt_marc  TYPE ty_marc_ht,
    lt_werks TYPE RANGE OF werks_d,
    lv_weeks TYPE i.

  CLEAR et_slt.

  " Unique materials where ESD = 'No ESD'
  LOOP AT it_esd INTO DATA(ls_esd) WHERE esd = gc_no_esd.
    INSERT VALUE #( matnr = ls_esd-matnr ) INTO TABLE lt_matnr.
  ENDLOOP.

  CHECK lt_matnr IS NOT INITIAL
    AND it_plant_lgort IS NOT INITIAL.

  lt_werks = VALUE #(
    FOR ls_plant IN it_plant_lgort
    ( sign = 'I' option = 'EQ' low = ls_plant-werks )
  ).

  SELECT matnr, werks, plifz
    FROM marc
    FOR ALL ENTRIES IN @lt_matnr
    WHERE matnr = @lt_matnr-matnr
      AND werks IN @lt_werks
    INTO CORRESPONDING FIELDS OF TABLE @lt_marc.

  CHECK lt_marc IS NOT INITIAL.

  " First matching plant by priority wins; CEIL( ( PLIFZ + 5 ) / 7 )
  LOOP AT lt_matnr INTO DATA(ls_matnr).
    DATA(ls_marc) = VALUE ty_marc_slt( ).
    DATA(lv_found) = abap_false.

    LOOP AT it_plant_lgort INTO DATA(ls_plant) BY FIELD priority.
      READ TABLE lt_marc INTO ls_marc
        WITH KEY matnr = ls_matnr-matnr
                 werks = ls_plant-werks.
      IF sy-subrc = 0.
        lv_found = abap_true.
        EXIT.
      ENDIF.
    ENDLOOP.

    CHECK lv_found = abap_true.

    " Integer ceil: ( plifz + 5 + 6 ) DIV 7
    lv_weeks = ( ls_marc-plifz + 11 ) DIV 7.

    APPEND VALUE #(
      matnr = ls_matnr-matnr
      slt   = |{ lv_weeks } { COND char5( WHEN lv_weeks = 1 THEN gc_week ELSE gc_weeks ) }|
    ) TO et_slt.
  ENDLOOP.

ENDMETHOD.
