*&---------------------------------------------------------------------*
*& Types for YDS Parts Lookup - Supplier Lead Time (SLT)
*&---------------------------------------------------------------------*

" ESD result structure (returned by get_esd)
TYPES: BEGIN OF ty_esd,
         matnr TYPE matnr,
         esd   TYPE string,
       END OF ty_esd,
       ty_esd_tt TYPE STANDARD TABLE OF ty_esd WITH EMPTY KEY.

" SLT result structure (returned by get_slt)
TYPES: BEGIN OF ty_slt,
         matnr TYPE matnr,
         slt   TYPE char35,            " e.g. '6 week(s)'
       END OF ty_slt,
       ty_slt_tt TYPE STANDARD TABLE OF ty_slt WITH NON-UNIQUE KEY matnr.

" Plant / storage location configuration from SET_FIXED_VALUES
TYPES: BEGIN OF ty_plant_lgort,
         werks    TYPE werks_d,
         lgort    TYPE lgort_d,
         priority TYPE i,
       END OF ty_plant_lgort,
       ty_plant_lgort_tt TYPE STANDARD TABLE OF ty_plant_lgort
                            WITH NON-UNIQUE KEY priority werks.

" Internal helper for MARC reads during plant fallback
TYPES: BEGIN OF ty_marc_plifz,
         matnr TYPE matnr,
         plifz TYPE plifz,
       END OF ty_marc_plifz,
       ty_marc_plifz_tt TYPE HASHED TABLE OF ty_marc_plifz
                           WITH UNIQUE KEY matnr.

CONSTANTS:
  gc_no_esd       TYPE string VALUE 'No ESD',
  gc_weeks_suffix TYPE char10 VALUE 'week(s)'.
