*&---------------------------------------------------------------------*
*& Types for YDS Parts Lookup - Supplier Lead Time (SLT)
*&---------------------------------------------------------------------*

TYPES:
  BEGIN OF ty_esd,
    matnr TYPE matnr,
    esd   TYPE string,
  END OF ty_esd,
  ty_esd_tt TYPE STANDARD TABLE OF ty_esd WITH EMPTY KEY,

  BEGIN OF ty_slt,
    matnr TYPE matnr,
    slt   TYPE char35,
  END OF ty_slt,
  ty_slt_tt TYPE STANDARD TABLE OF ty_slt WITH EMPTY KEY,

  BEGIN OF ty_plant_lgpro,
    werks    TYPE werks_d,
    lgpro    TYPE lgort_d,           " MARC-LGPRO
    priority TYPE i,
  END OF ty_plant_lgpro,
  ty_plant_lgpro_tt TYPE STANDARD TABLE OF ty_plant_lgpro
                       WITH NON-UNIQUE KEY priority werks lgpro,

  BEGIN OF ty_matnr_key,
    matnr TYPE matnr,
  END OF ty_matnr_key,
  ty_matnr_key_tt TYPE SORTED TABLE OF ty_matnr_key WITH UNIQUE KEY matnr,

  BEGIN OF ty_marc_slt,
    matnr TYPE matnr,
    werks TYPE werks_d,
    lgpro TYPE lgort_d,
    plifz TYPE plifz,
  END OF ty_marc_slt,
  ty_marc_slt_tt TYPE STANDARD TABLE OF ty_marc_slt WITH EMPTY KEY.

CONSTANTS:
  BEGIN OF gc_slt,
    no_esd TYPE string VALUE 'No ESD',
    week   TYPE char5  VALUE 'week',
    weeks  TYPE char5  VALUE 'weeks',
  END OF gc_slt.

CONSTANTS:
  gc_no_esd TYPE string VALUE 'No ESD',
  gc_week   TYPE char5  VALUE 'week',
  gc_weeks  TYPE char5  VALUE 'weeks'.
