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
    it_esd TYPE ty_esd_tt
  EXPORTING
    et_slt TYPE ty_slt_tt.
```

Uses class attribute `gt_plant_lgpro` (populated in `SET_FIXED_VALUES`).

## Modern ABAP features used

- `FILTER` + `FOR GROUPS` for unique `No ESD` materials
- `FINAL(...)` for immutable locals
- Open SQL inner join on `MARC` + `gt_plant_lgpro` (no FAE)
- `REDUCE` + `UNTIL` for plant-priority resolution
- `VALUE #( FOR ... LET ... IN WHERE ... )` to build `et_slt` in one expression
- `COND #(...)` for singular/plural week label

## Business rules

1. Only processes materials where `ESD = 'No ESD'`.
2. Single `MARC` read via inner join on `WERKS` + `LGPRO` against `gt_plant_lgpro`.
3. Resolves plant fallback priority in memory (3035 → 3036 → 3037).
4. Uses the first plant where the material exists, regardless of PLIFZ value (including 0).
5. Calculates weeks: `CEIL( ( PLIFZ + 5 ) / 7 )` via `( PLIFZ + 11 ) DIV 7`.
6. Returns `MATNR` + `SLT` as `CHAR35`, e.g. `1 week` or `6 weeks`.

## Handled by the calling method (not GET_SLT)

- Active / Discontinued status check
- MTPOS = `ZBNS` dropship prefix (`Dropship - XX week(s)` — singular/plural from `GET_SLT`)
- Clearing ESD when SLT is shown

## Formula examples

| PLIFZ (days) | Calculation | SLT output |
|--------------|-------------|------------|
| 32 | (32+5)/7 = 5.29 | `6 weeks` |
| 0 | (0+5)/7 = 0.71 | `1 week` |
| 2 | (2+5)/7 = 1.00 | `1 week` |
