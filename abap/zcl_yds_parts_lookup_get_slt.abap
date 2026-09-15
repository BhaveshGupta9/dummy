*&---------------------------------------------------------------------*
*& Method GET_SLT
*&---------------------------------------------------------------------*

METHOD get_slt.

  FINAL(lt_matnr) = VALUE ty_matnr_tt(
    FOR GROUPS matnr OF esd IN FILTER #( it_esd WHERE esd = gc_slt-no_esd )
    GROUP BY esd-matnr
    ( matnr )
  ).

  IF lt_matnr IS INITIAL OR it_plant_lgort IS INITIAL.
    CLEAR et_slt.
    RETURN.
  ENDIF.

  FINAL(lt_werks) = VALUE ty_werks_range(
    FOR plant IN it_plant_lgort
    ( sign = 'I' option = 'EQ' low = plant-werks )
  ).

  SELECT FROM marc
    FIELDS matnr, werks, plifz
    FOR ALL ENTRIES IN @lt_matnr
    WHERE matnr = @lt_matnr-table_line
      AND werks IN @lt_werks
    INTO TABLE @DATA(lt_marc).

  IF lt_marc IS INITIAL.
    CLEAR et_slt.
    RETURN.
  ENDIF.

  et_slt = VALUE #(
    FOR loop_matnr IN lt_matnr
    LET marc  = REDUCE ty_marc_slt(
                  INIT result = VALUE ty_marc_slt( )
                       found  = abap_false
                  FOR plant IN it_plant_lgort BY FIELD priority
                  FOR line  IN lt_marc
                    WHERE ( matnr = loop_matnr
                        AND werks = plant-werks )
                  NEXT found  = abap_true
                       result = line
                  UNTIL found
                )
        weeks = CONV i( ( marc-plifz + 11 ) DIV 7 )
    IN
    WHERE ( marc-matnr IS NOT INITIAL )
    (
      matnr = loop_matnr
      slt   = |{ weeks } { COND #( WHEN weeks = 1
                                   THEN gc_slt-week
                                   ELSE gc_slt-weeks ) }|
    )
  ).

ENDMETHOD.
