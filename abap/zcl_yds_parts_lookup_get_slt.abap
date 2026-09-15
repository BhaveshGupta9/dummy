*&---------------------------------------------------------------------*
*& Method GET_SLT
*& Supplier Lead Time calculation for YDS Parts Lookup OData service
*&
*& Called after GET_ESD. Returns MATNR with SLT as 'XX week' / 'XX weeks'
*& only for materials where ESD = 'No ESD'.
*&
*& Dropship prefix and Active / MTPOS checks are handled by the caller.
*&---------------------------------------------------------------------*

METHOD get_slt.

  TYPES:
    BEGIN OF ty_matnr_line,
      matnr TYPE matnr,
    END OF ty_matnr_line.

  DATA:
    lt_matnr_no_esd TYPE STANDARD TABLE OF ty_matnr_line WITH EMPTY KEY,
    lt_remaining    TYPE STANDARD TABLE OF ty_matnr_line WITH EMPTY KEY,
    lt_marc         TYPE STANDARD TABLE OF marc WITH EMPTY KEY,
    lt_plifz        TYPE ty_marc_plifz_tt,
    ls_plifz        TYPE ty_marc_plifz,
    lv_weeks        TYPE i,
    lv_plifz        TYPE plifz,
    lv_week_label   TYPE char5.

  CLEAR et_slt.

  "--------------------------------------------------------------------
  " 1. Keep only materials where ESD = 'No ESD'
  "--------------------------------------------------------------------
  LOOP AT it_esd INTO DATA(ls_esd) WHERE esd = gc_no_esd.
    APPEND VALUE #( matnr = ls_esd-matnr ) TO lt_matnr_no_esd.
  ENDLOOP.

  IF lt_matnr_no_esd IS INITIAL.
    RETURN.
  ENDIF.

  SORT lt_matnr_no_esd BY matnr.
  DELETE ADJACENT DUPLICATES FROM lt_matnr_no_esd COMPARING matnr.

  lt_remaining = lt_matnr_no_esd.

  "--------------------------------------------------------------------
  " 2. Read PLIFZ from MARC using plant priority from fixed values
  "    Priority sequence: 3035 -> 3036 -> 3037 (set in SET_FIXED_VALUES)
  "--------------------------------------------------------------------
  LOOP AT it_plant_lgort INTO DATA(ls_plant) BY FIELD priority.
    CHECK lt_remaining IS NOT INITIAL.

    SELECT matnr, plifz
      FROM marc
      FOR ALL ENTRIES IN @lt_remaining
      WHERE matnr = @lt_remaining-matnr
        AND werks = @ls_plant-werks
      INTO CORRESPONDING FIELDS OF TABLE @lt_marc.

    LOOP AT lt_marc INTO DATA(ls_marc).
      ls_plifz-matnr = ls_marc-matnr.
      ls_plifz-plifz = ls_marc-plifz.
      INSERT ls_plifz INTO TABLE lt_plifz.

      DELETE lt_remaining WHERE matnr = ls_marc-matnr.
    ENDLOOP.

    CLEAR lt_marc.
  ENDLOOP.

  "--------------------------------------------------------------------
  " 3. Calculate weeks: CEIL( ( PLIFZ + 5 ) / 7 ), format as 'XX week(s)'
  "--------------------------------------------------------------------
  LOOP AT lt_plifz INTO ls_plifz.
    lv_plifz = ls_plifz-plifz.

    " ROUND UP: any fractional result rounds up to the next whole week
    lv_weeks = ceil( conv decfloat34( lv_plifz + 5 ) / 7 ).

    IF lv_weeks = 1.
      lv_week_label = gc_week.
    ELSE.
      lv_week_label = gc_weeks.
    ENDIF.

    APPEND VALUE #(
      matnr = ls_plifz-matnr
      slt   = |{ lv_weeks } { lv_week_label }|
    ) TO et_slt.
  ENDLOOP.

ENDMETHOD.
