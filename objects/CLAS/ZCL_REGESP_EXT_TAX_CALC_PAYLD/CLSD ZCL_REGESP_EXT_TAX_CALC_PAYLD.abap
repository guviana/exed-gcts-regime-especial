class-pool .
*"* class pool for class ZCL_REGESP_EXT_TAX_CALC_PAYLD

*"* local type definitions
include ZCL_REGESP_EXT_TAX_CALC_PAYLD=ccdef.

*"* class ZCL_REGESP_EXT_TAX_CALC_PAYLD definition
*"* public declarations
  include ZCL_REGESP_EXT_TAX_CALC_PAYLD=cu.
*"* protected declarations
  include ZCL_REGESP_EXT_TAX_CALC_PAYLD=co.
*"* private declarations
  include ZCL_REGESP_EXT_TAX_CALC_PAYLD=ci.
endclass. "ZCL_REGESP_EXT_TAX_CALC_PAYLD definition

*"* macro definitions
include ZCL_REGESP_EXT_TAX_CALC_PAYLD=ccmac.
*"* local class implementation
include ZCL_REGESP_EXT_TAX_CALC_PAYLD=ccimp.

*"* test class
include ZCL_REGESP_EXT_TAX_CALC_PAYLD=ccau.

class ZCL_REGESP_EXT_TAX_CALC_PAYLD implementation.
*"* method's implementations
  include methods.
endclass. "ZCL_REGESP_EXT_TAX_CALC_PAYLD implementation
