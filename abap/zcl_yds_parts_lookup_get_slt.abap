*&---------------------------------------------------------------------*
*& Method GET_SLT
*&---------------------------------------------------------------------*

METHOD get_slt.

  FINAL(lt_matnr) = VALUE ty_matnr_key_tt(
    FOR GROUPS matnr OF esd IN FILTER #( it_esd WHERE esd = gc_slt-no_esd )
    GROUP BY esd-matnr
    ( matnr = matnr )
  ).

  IF lt_matnr IS INITIAL OR gt_plant_lgpro IS INITIAL.
    CLEAR et_slt.
    RETURN.
  ENDIF.

  SELECT FROM @lt_matnr AS material
    INNER JOIN marc
      ON marc~matnr = material~matnr
    INNER JOIN @gt_plant_lgpro AS plant
      ON marc~werks = plant~werks
     AND marc~lgpro = plant~lgpro
    FIELDS marc~matnr
          ,marc~werks
          ,marc~lgpro
          ,marc~plifz
    INTO CORRESPONDING FIELDS OF TABLE @DATA(lt_marc).

  IF lt_marc IS INITIAL.
    CLEAR et_slt.
    RETURN.
  ENDIF.

  et_slt = VALUE #(
    FOR material IN lt_matnr
    LET marc  = REDUCE ty_marc_slt(
                  INIT result = VALUE ty_marc_slt( )
                       found  = abap_false
                  FOR plant IN gt_plant_lgpro BY FIELD priority
                  FOR line  IN lt_marc
                    WHERE ( matnr = material-matnr
                        AND werks = plant-werks
                        AND lgpro = plant-lgpro )
                  NEXT found  = abap_true
                       result = line
                  UNTIL found
                )
        weeks = CONV i( ( marc-plifz + 11 ) DIV 7 )
    IN
    WHERE ( marc-matnr IS NOT INITIAL )
    (
      matnr = material-matnr
      slt   = |{ weeks } { COND #( WHEN weeks = 1
                                   THEN gc_slt-week
                                   ELSE gc_slt-weeks ) }|
    )
  ).

ENDMETHOD.
