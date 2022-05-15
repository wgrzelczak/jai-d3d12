# jai-d3d12
Custom module with DirectX12 auto-generated bindings.

Included submodules:
- d3d12 (optional Agility features)
- dxgi
- dxc
- pix

Each submodule is divided into multiple files:
- `{name}.jai` - it's an entry point to the submodule. Loads other files, and has symbols which could not be generated automatically.
- `{name}_bindings.jai` - auto-generated bindings.
- `{name}_bindings_debug.jai` - auto-generated bindings for debug features.
- `{name}_helpers.jai` - set of helper functions with jai-friendly interface.

# Generating bindings
(Because of compilacted licensing for external codebases I don't include them here)

Confuigure parameters for `generate.jai`:
```
USE_D3D12_AGILITY :: true;
D3D12_AGILITY_SRC :: "d3d12_agility_src/build/native/";

DXGI          :: true;
D3D12         :: true;
DXC           :: true;
PIX           :: true;
```

Download needed sources. All instructions how to do this and links are in `*_src/readme.md`.  

Call `jai generate.jai`.  

Copy dlls next to your executable:
- D3D12Core.dll (for Agility)
- d3d12SDKLayers.dll (for Agility)
- dxcompiler.dll (for dxc)
- dxil.dll (for dxc)
- WinPixEventRuntime.dll (for pix)


# TODO
- complete dxc helpers
- add nvapi submodule
- add example code

