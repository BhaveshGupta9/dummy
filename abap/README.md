# YDS Parts Lookup - Supplier Lead Time (SLT)

ABAP implementation for the **Supplier Lead Time** field on the YDS Parts Lookup OData service.

## Files

| File | Purpose |
|------|---------|
| `zcl_yds_parts_lookup_types.abap` | Shared type definitions and constants |
| `zcl_yds_parts_lookup_get_slt.abap` | `GET_SLT` method — core calculation logic |
| `zcl_yds_parts_lookup_set_fixed_values.abap` | Plant/storage location priority config |
| `zcl_yds_parts_lookup_caller_integration.abap` | How to call `GET_SLT` and apply display rules |

## Method signature

```abap
METHOD get_slt
  IMPORTING
    it_esd         TYPE ty_esd_tt
    it_plant_lgort TYPE ty_plant_lgort_tt
  EXPORTING
    et_slt         TYPE ty_slt_tt.
```

## Business rules implemented in GET_SLT

1. Only processes materials where `ESD = 'No ESD'`.
2. Reads `MARC-PLIFZ` using plant fallback priority:
   - Plant **3035** (LGORT 3520) — first
   - Plant **3036** (LGORT 3610) — second
   - Plant **3037** (LGORT 3710) — third
3. Uses the first plant where the material exists, regardless of PLIFZ value (including 0).
4. Calculates weeks: `CEIL( ( PLIFZ + 5 ) / 7 )`.
5. Returns `MATNR` + `SLT` as `CHAR35` formatted text, e.g. `6 week(s)`.

## Handled by the calling method (not GET_SLT)

- Active / Discontinued status check
- MTPOS = `ZBNS` dropship prefix (`Dropship - XX week(s)`)
- Clearing ESD when SLT is shown

## Formula examples

| PLIFZ (days) | Calculation | SLT output |
|--------------|-------------|------------|
| 32 | (32+5)/7 = 5.29 | `6 week(s)` |
| 0 | (0+5)/7 = 0.71 | `1 week(s)` |
| 2 | (2+5)/7 = 1.00 | `1 week(s)` |
