#scope_module
// Config:
USE_DEBUG :: true;
USE_D3D12_AGILITY :: true;
D3D12_AGILITY_SDK_VERSION :: 700;
D3D12_AGILITY_SDK_PATH :: ".\\";

#scope_export
#load "d3d12.jai";
#load "dxgi.jai";
#load "dxc.jai";
#if USE_DEBUG #load "pix.jai";

#if USE_D3D12_AGILITY {
    #program_export D3D12SDKVersion     : u32 = D3D12_AGILITY_SDK_VERSION;
    #program_export D3D12SDKPath_string :     = #run make_d3d12sdkpath(D3D12_AGILITY_SDK_PATH);
    #program_export D3D12SDKPath        : *u8 = #run D3D12SDKPath_string.data;

    
    // @Cleanup: Next version of compiler will have more convenient method for exporting strings
    make_d3d12sdkpath :: (path : string) -> [] u8 {
        #import "Compiler";
    
        data: [128] u8;
        for 0..path.count-1 data[it] = path[it];
        segment, actually := add_data_segment("D3D12SDKPath_string", .READ);

        result := add_global_data(data, .USER_SEGMENT, segment);
        return result;
    }
}

#run {
    // Copy dlls next to the exe
    {
        copy_dll :: (dir : string, filename : string) {
            #import "Compiler";
            #import "File";
            #import "File_Utilities";
            #import "String";
            w := get_build_options();

            src := tprint("%+%+%+", #filepath, dir, filename);
            dst := tprint("%+%+", w.output_path, filename);
            //copy_file(src, dst); //@Incomplete: for some reason copying files doesn't work with final workspace
        }
        
        #if USE_DEBUG {
            copy_dll("pix_src/bin/x64/", "WinPixEventRuntime.dll");
        }
        #if USE_D3D12_AGILITY {
            copy_dll("d3d12_agility_src/build/native/bin/x64/", "D3D12Core.dll");
            copy_dll("d3d12_agility_src/build/native/bin/x64/", "d3d12SDKLayers.dll");
        }
        //@Incomplete: Add a parameter to not export DXC dlls
        copy_dll("dxc_src/bin/x64/", "dxcompiler.dll");
        copy_dll("dxc_src/bin/x64/", "dxil.dll");
    }
}


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