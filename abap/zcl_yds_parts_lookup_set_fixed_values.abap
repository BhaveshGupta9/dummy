*&---------------------------------------------------------------------*
*& Method SET_FIXED_VALUES (excerpt)
*& Store plant and storage location against VKORG with priority
*&---------------------------------------------------------------------*

METHOD set_fixed_values.

  " ... existing fixed-value logic ...

  CLEAR gt_plant_lgort.

  CASE iv_vkorg.
    WHEN 'YDS1'.  " Adjust sales org as per your implementation
      APPEND VALUE #(
        werks    = '3035'
        lgort    = '3520'
        priority = 1
      ) TO gt_plant_lgort.

      APPEND VALUE #(
        werks    = '3036'
        lgort    = '3610'
        priority = 2
      ) TO gt_plant_lgort.

      APPEND VALUE #(
        werks    = '3037'
        lgort    = '3710'
        priority = 3
      ) TO gt_plant_lgort.

    " Add other VKORG mappings here as required

  ENDCASE.

  SORT gt_plant_lgort BY priority.

ENDMETHOD.
