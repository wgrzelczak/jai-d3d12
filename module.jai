#scope_module
// Config:
USE_DEBUG :: true;

#scope_export
#load "d3d12.jai";
#load "dxgi.jai";
#load "dxc.jai";
#if USE_DEBUG #load "pix.jai";

check_hr :: (hr : HRESULT) {
    assert(hr == S_OK);
}

set_name :: (object : *$T/interface ID3D12Object, name := "Unnamed") #expand {
    wstr := cast(*s16) utf8_to_wide(name);
    vtable(object).SetName(object, wstr);
}

set_name :: (object : *$T/interface ID3D12Object, name := "Unnamed", idx : int) #expand {
    wstr := cast(*s16) utf8_to_wide(tprint("%[%]", name, idx));
    vtable(object).SetName(object, wstr);
}

#scope_module
#import "Windows_Utf8";