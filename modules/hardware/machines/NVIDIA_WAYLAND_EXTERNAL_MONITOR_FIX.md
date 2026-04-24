# NVIDIA Wayland External Monitor Fix

**Date:** 2026-04-05
**Machine:** Lenovo Legion Pro 7 16IRX9H (RTX 4090 Laptop + Intel UHD Raptor Lake)
**Driver:** NVIDIA 580.142 (proprietary, PRIME sync)
**Kernel:** 6.12.78
**Desktop:** KDE Plasma 6.5.6, Wayland, KWin

## Problem

Connecting an external monitor via USB-C → DisplayPort adapter (through
Thunderbolt 4) and moving the mouse cursor from the laptop screen to the
external monitor causes a **hard system freeze** on Wayland. X11 works fine.

Symptoms:
- SDDM login screen appears on both monitors normally
- Freeze triggers the moment the cursor enters the external display
- Caps lock LED still responds, power button triggers graceful shutdown
- Switching to X11 at the login screen makes everything work

## Root Cause

**NVIDIA Bug 5983006** — confirmed and reproduced by NVIDIA Labs.

In `nvidia-drm/nvidia-drm-fb.c`, the function `nv_drm_framebuffer_init` has a
code path for `non_scanout_mem_backed` framebuffers (system RAM, not VRAM).
When this path is taken, the code explicitly sets `pSurface = NULL` but still
returns success. Later, when KWin Wayland's hardware cursor plane uses this
framebuffer, it dereferences `pSurface` at offset `0x28` → kernel NULL pointer
dereference.

The hardware cursor framebuffer is allocated in system memory on hybrid laptops
(not in VRAM), which triggers this specific code path. The crash happens via:

```
_nv000582kms+0x4/0x10 [nvidia_modeset]    ← reads *(NULL + 0x28)
  nv_drm_framebuffer_create+0x218/0x480 [nvidia_drm]
  drm_internal_framebuffer_create+0x3e2/0x570
  drm_mode_addfb2+0x4a/0xf0              ← ioctl from KWin Wayland
  drm_ioctl+0x2a4/0x510
  __x64_sys_ioctl+0x91/0xd0
```

The bug affects all PRIME modes (sync and offload) and both proprietary and
open NVIDIA kernel modules. It is **not fixed in 595.x**.

## Fix

```nix
KWIN_FORCE_SW_CURSOR = "1";
```

Added to `environment.sessionVariables` in `lenovo-legion-pro7-16irx9h.nix`.

This forces KWin to use software cursor rendering instead of hardware cursor
planes. The software cursor is composited into the main framebuffer by KWin
and never triggers the buggy `non_scanout_mem_backed` DRM framebuffer path.

## Tradeoff

Software cursor adds ~1 frame of cursor latency. Imperceptible for desktop use.

## When to Remove

Monitor NVIDIA driver updates. When Bug 5983006 is fixed upstream (the
`non_scanout_mem_backed` path in `nvidia-drm-fb.c` gets a proper NULL check
or surface creation is made unconditional), remove `KWIN_FORCE_SW_CURSOR` to
restore hardware cursor.

## Approaches Tried (and failed)

| Attempt | Result |
|---------|--------|
| PRIME sync + proprietary 580.142 | Crash on Wayland |
| PRIME sync + open modules 580.142 | Same crash |
| Offload mode + open modules 580.142 | Same crash |
| Upgrade to 595.58.03 via nixpkgs overlay | Kernel symbol mismatch (`devmap_managed_key`) — modules won't load |
| Build 595.58.03 from source via mkDriver | Built successfully but broke boot entirely |
| `KWIN_DRM_DEVICES=/dev/dri/card1` | External monitor not detected (DP outputs are on NVIDIA card0) |
| `KWIN_DRM_NO_MODIFIERS=1` | Still crashed |
| **`KWIN_FORCE_SW_CURSOR=1`** | **Fixed** |

## References

- [NVIDIA Bug 5983006 — Forum thread](https://forums.developer.nvidia.com/t/kernel-null-pointer-dereference-when-using-the-580-142-driver/363409)
- [580 release feedback — workaround confirmations (posts #1050-1068)](https://forums.developer.nvidia.com/t/580-release-feedback-discussion/341205/1050)
- [595 release feedback — bug still present](https://forums.developer.nvidia.com/t/595-release-feedback-discussion/362561?page=15)
- [NVIDIA open-gpu-kernel-modules — nvidia-drm-fb.c source](https://github.com/NVIDIA/open-gpu-kernel-modules/blob/main/kernel-open/nvidia-drm/nvidia-drm-fb.c)
